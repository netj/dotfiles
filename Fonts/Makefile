# Makefile for installing fine fonts
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-03-20

uname := $(shell uname)
ifeq ($(uname),Darwin)
    # Mac
    uname_version := $(uname)-$(shell sw_vers -productVersion 2>/dev/null)
    FONTSDIR := ~/Library/Fonts
else
    uname_version := $(uname)
    FONTSDIR := ~/.fonts
endif


.PHONY: all install uninstall clean
all: install

# we'd like to generate a pattern of Makefile rules implicitly when including
%Fonts.mk: genFontsFetchRules Makefile; @./$< $* >$@

## Envy Code R, Damien Guard's coding font
## See: http://damieng.com/fonts/envy-code-r
EnvyCodeRFontsURL := http://download.damieng.com/fonts/original/EnvyCodeR-PR7.zip
EnvyCodeRFontsArchive := EnvyCodeR.zip
EnvyCodeRFonts := \
    Envy?Code?R?Bold.ttf   \
    Envy?Code?R?Italic.ttf \
    Envy?Code?R.ttf        \
    #
include EnvyCodeRFonts.mk

# Powerline/vim-airline fonts
PowerlineSymbolsFontsURL := https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
PowerlineSymbolsFontsArchive := PowerlineSymbols.otf
PowerlineSymbolsFonts := \
    PowerlineSymbols.otf \
    #
include PowerlineSymbolsFonts.mk
# pre-patched versions
PowerlineFonts := powerline-fonts
InstalledFiles += $(FONTSDIR)/$(PowerlineFonts)
$(FONTSDIR)/powerline-fonts: $(PowerlineFonts)
	cd $(PowerlineFonts) && git pull
	rsync -avH --exclude=/.git $</ $@/
$(PowerlineFonts):
	git clone https://github.com/netj/powerline-fonts.git $@

## Nanum Fonts
ifneq (,$(filter Darwin-10.6 Darwin-10.6.%,$(uname_version)))
# Mac OS X Lion and later (Darwin-10.7+) includes Nanum Fonts
NanumFontsURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip
NanumFonts := \
    NanumGothic.ttf             \
    NanumGothicBold.ttf         \
    NanumGothicExtraBold.ttf    \
    NanumMyeongjo.ttf           \
    NanumMyeongjoBold.ttf       \
    NanumMyeongjoExtraBold.ttf  \
    NanumBrush.ttf              \
    NanumPen.ttf                \
    #
include NanumFonts.mk
endif

## Nanum Eco Fonts
NanumGothicEcoFontsURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFontSetup_TTF_GOTHICECO.zip
NanumGothicEcoFonts := \
    NanumGothicEco.ttf \
    NanumGothicEcoBold.ttf \
    NanumGothicEcoExtraBold.ttf \
    #
include NanumGothicEcoFonts.mk
NanumMyeongjoEcoFontsURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFontSetup_TTF_MYUNGJOECO.zip
NanumMyeongjoEcoFonts := \
    NanumMyeongjoEco.ttf \
    NanumMyeongjoEcoBold.ttf \
    NanumMyeongjoEcoExtraBold.ttf \
    #
include NanumMyeongjoEcoFonts.mk

## Nanum Gothic Coding Font
NanumGothicCodingFontsURL := http://dev.naver.com/frs/download.php/441/NanumGothicCoding-2.0.zip
NanumGothicCodingFonts := \
    나눔고딕코딩-Bold.ttf 나눔고딕코딩-Bold.ttf \
    나눔고딕코딩.ttf 나눔고딕코딩.ttf \
    #
include NanumGothicCodingFonts.mk

## Nanum Gothic Light Font
NanumGothicLightFontsURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFontSetup_TTF_GOTHICLIGHT.zip
NanumGothicLightFonts := \
    NanumGothicLight.ttf \
    #
include NanumGothicLightFonts.mk


## Seoul Fonts
# See: http://www.seoul.go.kr/v2012/seoul/symbol/font.html
SeoulFontsURL := http://www.seoul.go.kr/v2012/seoul/symbol/download.php?div=Zm9udDAy
SeoulFontsArchive := SeoulFonts_TTF.zip
SeoulFonts := \
    SeoulHangangB.ttf   \
    SeoulHangangEB.ttf  \
    SeoulHangangL.ttf   \
    SeoulHangangM.ttf   \
    SeoulNamsanB.ttf    \
    SeoulNamsanEB.ttf   \
    SeoulNamsanL.ttf    \
    SeoulNamsanM.ttf    \
    SeoulNamsanvert.ttf \
    #
include SeoulFonts.mk


## Dijkstra
DijkstraFontsURL := http://www.fonts101.com/download/34398/Dijkstra/A5922C74E09F7630B830C8BDB36343B0.aspx
DijkstraFontsArchive := Dijkstra.zip
DijkstraFonts := \
    dijkstra.ttf \
    #
include DijkstraFonts.mk

## Bubblegum
BubblegumSansFontsURL := http://www.fontsquirrel.com/fonts/download/bubblegum-sans
BubblegumSansFontsArchive := BubblegumSans.zip
BubblegumSansFonts := \
    BubblegumSans-Regular.otf \
    #
include BubblegumSansFonts.mk

## Microsoft free fonts
msttcorefonts:
ifneq ($(uname),Darwin)
	! type apt-get >/dev/null 2>&1 || dpkg -L msttcorefonts >/dev/null 2>&1 || sudo apt-get install msttcorefonts
endif


install: $(InstalledFiles) \
    msttcorefonts          \
    #
uninstall:
	rm -f $(InstalledFiles)

clean:
	rm -rf *.mk $(IntermediateDirs)
cleaner: clean
	rm -f $(IntermediateFiles) 

