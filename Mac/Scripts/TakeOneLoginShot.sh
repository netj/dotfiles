#!/usr/bin/env bash
# Takes a photo with Mac's built-in camera silently under ~/.loginshots/
# 
# Requires several packages, which can be installed with:
# 
#    brew install imagesnap
# 
# To also record geolocation, install these as well:
# 
#    brew install exiftool
#    mkdir -p /Applications/bin
# 
# Either LocateMe:
# 
#    curl -RLo- http://downloads.sourceforge.net/project/iharder/locateme/LocateMe-v0.2.tgz |
#    tar xf - --strip-components=1 -C /Applications/bin/ '*/LocateMe'
# 
# Or, whereami:
# 
#    open http://d.pr/f/C2qV/download
#    ditto -xk whereami*.zip .
#    mv whereami /Applications/bin/
# 
# 
# Launch it with watch-syslog.sh from cron:
# 
#    */23 *   * * *   exec watch-syslog.sh 'loginwindow\[[0-9]\+\]: in pam_sm_setcred(): Establishing credentials'  ~/.loginshots.pid  bash -c 'sleep 3; TakeOneLoginShot.sh' &>/dev/null #>>~/tmp/loginshots.log 2>&1
#    @reboot          exec watch-syslog.sh 'loginwindow\[[0-9]\+\]: in pam_sm_setcred(): Establishing credentials'  ~/.loginshots.pid  bash -c 'sleep 3; TakeOneLoginShot.sh' &>/dev/null #>>~/tmp/loginshots.log 2>&1
# 
# 
# They need to be installed (symlink'ed) in /usr/bin/ to be used from GUI.
# 
#    sudo ln -sfn $(brew --prefix)/bin/imagesnap   /usr/bin/
#    sudo ln -sfn $(brew --prefix)/bin/geolocation /usr/bin/
#         ln -sfn    /Applications/bin/LocateMe    /usr/bin/
#         ln -sfn    /Applications/bin/whereami    /usr/bin/
# 
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-11-17
set -eu

: \
    ${DateFormat:=%Y/%m/%d-%H%M%S} \
    ${MinSecsBetweenShots:=5} \
    ${NumRetries:=3} \
    ${JPEGQuality:=20} \
    #

[ -d ~/.loginshots ] || {
    ln -sfn ~/Dropbox/Photos/LoginShots ~/.loginshots
    mkdir -p $(readlink ~/.loginshots)
}
LoginShotsFolder=~/.loginshots

event=${*:-}
tag=${event:+.${event}}

filename="$LoginShotsFolder/$(date +"$DateFormat")${tag}.jpg"
mkdir -p "$(dirname "$filename")"

latest="$LoginShotsFolder/LATEST${tag}.JPG"

# try not to take too many shots in a short period
timediff=$(( $(date +%s) - $(date -r "$latest" +%s 2>/dev/null || echo 0) ))
if [[ $timediff -lt $MinSecsBetweenShots ]]; then
    echo >&2 "throttling shots: only ${timediff}s have past"
    exit 2
fi

# take a shot
delay=4
for i in $(seq $NumRetries); do
    imagesnap "$filename" & pid=$!
    sleep $delay
    if [ -s "$filename" ]; then
        break
    elif ps -o pid= -p $pid &>/dev/null; then
        kill $pid
    fi
    let delay+=2
done
if ! [ -s "$filename" ]; then
    echo >&2 "imagesnap failed ($NumRetries tries) for $filename"
    exit 4
fi

# and compress
sips -s format jpeg -s formatOptions $JPEGQuality "$filename"

# and record geolocation
# See: http://apple.stackexchange.com/questions/60152/is-there-a-way-to-access-a-macs-geolocation-from-terminal-mountain-lion
# See: http://scribblesandsnaps.com/2011/11/23/easy-geotagging-with-exiftool/
# See: http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/GPS.html
if eval $(
    set -o pipefail
    if type LocateMe &>/dev/null; then
        # XXX LocateMe on OS X 10.8 does not update location itself, so using whereami before it
        ! type whereami &>/dev/null || whereami >&2
        LocateMe -f 'GPSLatitude={LAT}; GPSLongitude={LON}; GPSAltitude={ALT}'
    elif type whereami &>/dev/null; then
        whereami | grep 'Longitude\|Latitude' | sed 's/^/GPS/; s/: /=/'
    fi | tee /dev/stderr
); then
    GPSLatitudeRef=N GPSLongitudeRef=E
    case $GPSLatitude  in -*) GPSLatitudeRef=S  GPSLatitude=${GPSLatitude#-}   ;; esac
    case $GPSLongitude in -*) GPSLongitudeRef=W GPSLongitude=${GPSLongitude#-} ;; esac
    exiftool -GPSLatitudeRef=$GPSLatitudeRef   -GPSLatitude=$GPSLatitude   \
             -GPSLongitudeRef=$GPSLongitudeRef -GPSLongitude=$GPSLongitude \
             ${GPSAltitude:+-GPSAltitude=$GPSAltitude} \
        "$filename"
    rm -f "$filename"_original
fi

# update the latest pointer
ln -sfn "${filename#$LoginShotsFolder/}" "$latest"
