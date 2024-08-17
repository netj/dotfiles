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
%Fonts.mk: genFontsFetchRules Makefile
	@./$< $* >$@


## Noto Fonts by Google (Pan-CJK Sans-serif)
# See: https://fonts.google.com/noto
ifeq ($(uname),Darwin) # OS X (Mac)
    NotoFontsURL := https://www.google.com/get/noto/pkgs/Noto.zip
else
ifeq ($(patsubst CYGWIN_NT*,,$(uname)),) # Windows
    NotoFontsURL := https://www.google.com/get/noto/pkgs/Noto-windows.zip
else # Linux, etc.
    NotoFontsURL := https://www.google.com/get/noto/pkgs/Noto-hinted.zip
endif
endif
NotoFontsArchive := $(shell basename $(NotoFontsURL))
NotoFonts := \
    Noto*.ttf \
    #
#include NotoFonts.mk  # FIXME Noto-*.zip URLs stopped working


## Envy Code R, Damien Guard's coding font (monospace)
# See: https://damieng.com/fonts/envy-code-r
EnvyCodeRFontsURL := https://download.damieng.com/fonts/original/EnvyCodeR-PR7.zip
EnvyCodeRFontsArchive := EnvyCodeR.zip
EnvyCodeRFonts := \
    Envy?Code?R?Bold.ttf   \
    Envy?Code?R?Italic.ttf \
    Envy?Code?R.ttf        \
    #
include EnvyCodeRFonts.mk

## Inconsolata (monospace)
# See: https://levien.com/type/myfonts/inconsolata.html
InconsolataFontsURL := https://github.com/googlefonts/Inconsolata/releases/download/v3.000/fonts_ttf.zip
InconsolataFontsArchive := Inconsolata.zip
InconsolataFonts := \
    Inconsolata-*.ttf \
    #
include InconsolataFonts.mk

## Anonymous Pro
# See: https://www.marksimonson.com/fonts/view/anonymous-pro
AnonymousProFontsURL := https://www.marksimonson.com/assets/content/fonts/AnonymousPro-1_002.zip
AnonymousProFontsArchive := AnonymousPro.zip
AnonymousProFonts := \
    Anonymous?Pro*.ttf \
    #
include AnonymousProFonts.mk

## Ubuntu Font Family (monospace, sans-serif)
# See: https://design.ubuntu.com/font
UbuntuFontsURL := https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
UbuntuFontsArchive := Ubuntu.zip
UbuntuFonts := \
    UbuntuMono-*.ttf  \
    Ubuntu-*.ttf      \
    #
include UbuntuFonts.mk

## Consola Mono (monospace)
# See: https://fontlibrary.org/en/font/consolamono
ConsolaMonoFontsURL := https://fontlibrary.org/assets/downloads/consolamono/61cc2afcc4eca96efe7c6ebf178d39df/consolamono.zip
ConsolaMonoFontsArchive := ConsolaMono.zip
ConsolaMonoFonts := \
    ConsolaMono*.ttf \
    #
include ConsolaMonoFonts.mk

## Fantasque Sans Mono (monospace)
# See: https://fontlibrary.org/en/font/fantasque-sans-mono
FantasqueSansMonoFontsURL := https://fontlibrary.org/assets/downloads/fantasque-sans-mono/d9468644396932f3eea03b16c132f620/fantasque-sans-mono.zip
FantasqueSansMonoFontsArchive := FantasqueSansMono.zip
FantasqueSansMonoFonts := \
    FantasqueSansMono-*.ttf \
    #
include FantasqueSansMonoFonts.mk

## ProFont (monospace)
# See: https://tobiasjung.name/profont/
ifneq ($(uname),Darwin)
    ProFontFontsURL := https://tobiasjung.name/downloadfile.php?file=ProFontWinTweaked.zip
    ProFontFontsArchive := ProFont.zip
    ProFontFonts := \
        ProFontWindows.ttf
        #
    include ProFontFonts.mk
    ProFontBoldFontsURL := https://tobiasjung.name/downloadfile.php?file=ProFont-Windows-Bold.zip
    ProFontBoldFontsArchive := ProFontBold.zip
    ProFontBoldFonts := \
        ProFontWindows-Bold.ttf \
        #
    include ProFontBoldFonts.mk
else
    ## ProFontX for Mac OS X
    # See: https://www.faisal.com/software/profontx/
    ProFontXFontsURL := https://www.faisal.com/software/profontx/ProFontX.zip
    ProFontXFontsArchive := ProFontX.zip
    ProFontXFonts := \
        ProFontX \
        #
    include ProFontXFonts.mk
endif

## Courier Code (monospace)
# See: https://fontlibrary.org/en/font/courier-code
CourierCodeFontsURL := https://fontlibrary.org/assets/downloads/courier-code/d0b044fc63eb2e97d49d433acac9053d/courier-code.zip
CourierCodeFontsArchive := CourierCode.zip
CourierCodeFonts := \
    CourierCode-*.ttf \
    #
include CourierCodeFonts.mk

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
# See: https://hangeul.naver.com/fonts/search?f=nanum
ifneq (,$(filter Darwin-10.6 Darwin-10.6.%,$(uname_version)))
# Mac OS X Lion and later (Darwin-10.7+) includes Nanum Fonts
NanumFontsURL := https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-gothic.zip
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
NanumGothicEcoFontsURL := https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-gothic-eco.zip
NanumGothicEcoFonts := \
    NanumGothicEco*.ttf \
    #
include NanumGothicEcoFonts.mk
NanumMyeongjoEcoFontsURL := https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-myeongjo-eco.zip
NanumMyeongjoEcoFonts := \
    NanumMyeongjoEco*.ttf \
    #
include NanumMyeongjoEcoFonts.mk

## Nanum Gothic Coding Font
NanumGothicCodingFontsURL := https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-gothic-coding.zip
NanumGothicCodingFonts := \
    D2CodingAll/D2Coding-*-all.ttc \
    #
include NanumGothicCodingFonts.mk

## Nanum Gothic Light Font
NanumGothicLightFontsURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFontSetup_TTF_GOTHICLIGHT.zip  # FIXME to https://hangeul.naver.com/fonts/search?f=nanum
NanumGothicLightFonts := \
    NanumGothicLight.ttf \
    #
include NanumGothicLightFonts.mk


## Seoul Fonts
# See: https://english.seoul.go.kr/seoul-views/seoul-symbols/5-fonts/
SeoulFontsURL := https://english.seoul.go.kr/wp-content/uploads/2013/12/TTF_Manual%20installment_5.zip
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

## Crimson (serif)
# See: https://fontlibrary.org/en/font/crimson
CrimsonFontsURL := https://fontlibrary.org/assets/downloads/crimson/6feb6f6187adb04e0ea4a40f69101d98/crimson.zip
CrimsonFontsArchive := Crimson.zip
CrimsonFonts := \
    Crimson-*.otf 
    #
include CrimsonFonts.mk
# See: https://fonts.google.com/specimen/Crimson+Text
CrimsonTextFontsURL := https://www.fontsquirrel.com/fonts/download/crimson
CrimsonTextFontsArchive := CrimsonText.zip
CrimsonTextFonts := \
    CrimsonText-*.ttf \
    #
include CrimsonTextFonts.mk

## Vollkorn (serif)
# See: http://vollkorn-typeface.com
VollkornFontsURL := https://www.fontsquirrel.com/fonts/download/vollkorn
VollkornFontsArchive := Vollkorn.zip
VollkornFonts := \
    Vollkorn-Regular.ttf        \
    Vollkorn-Italic.ttf         \
    Vollkorn-Medium.ttf         \
    Vollkorn-MediumItalic.ttf   \
    Vollkorn-SemiBold.ttf       \
    Vollkorn-SemiBoldItalic.ttf \
    Vollkorn-Bold.ttf           \
    Vollkorn-BoldItalic.ttf     \
    #
include VollkornFonts.mk

## Adobe's Source Code Pro (monospace)
# See: https://adobe-fonts.github.io/source-code-pro/
SourceCodeProFontsURL := https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip
SourceCodeProFontsArchive := SourceCodePro.zip
SourceCodeProFonts := \
    TTF/SourceCodePro-*.ttf \
    #
include SourceCodeProFonts.mk

## Adobe's Source Serif 4 (serif)
# See: https://adobe-fonts.github.io/source-serif/
SourceSerif4FontsURL := https://github.com/adobe-fonts/source-serif/releases/download/4.004R/source-serif-4.004.zip
SourceSerif4FontsArchive := SourceSerif4.zip
SourceSerif4Fonts := \
    SourceSerif4-*.ttf \
    #
include SourceSerif4Fonts.mk

## Adobe's Source Sans 3 (sans-serif)
# See: https://adobe-fonts.github.io/source-sans/
SourceSans3FontsURL := https://github.com/adobe-fonts/source-sans/releases/download/3.052R/TTF-source-sans-3.052R.zip
SourceSans3FontsArchive := SourceSans3.zip
SourceSans3Fonts := \
    TTF/SourceSans3-*.ttf \
    #
include SourceSans3Fonts.mk

## Crusoe Text (sans-serif)
# See: https://fontlibrary.org/en/font/crusoe-text
CrusoeTextFontsURL := https://fontlibrary.org/assets/downloads/crusoe-text/e045c0cbb955e2c4cc1dfbbf844b240c/crusoe-text.zip
CrusoeTextFontsArchive := CrusoeText.zip
CrusoeTextFonts := \
    CrusoeText-Regular.ttf \
    CrusoeText-Italic.ttf  \
    CrusoeText-Bold.ttf    \
    #
include CrusoeTextFonts.mk

## Avería Serif (serif)
# See: https://fontlibrary.org/en/font/averia-serif
AveriaSerifFontsURL := https://fontlibrary.org/assets/downloads/averia-serif/51e3ae7cf61b932c613416e6e0a05e40/averia-serif.zip
AveriaSerifFontsArchive := AveriaSerif.zip
AveriaSerifFonts := \
    AveriaSerif-Regular.ttf     \
    AveriaSerif-Italic.ttf      \
    AveriaSerif-Light.ttf       \
    AveriaSerif-LightItalic.ttf \
    AveriaSerif-Bold.ttf        \
    AveriaSerif-BoldItalic.ttf  \
    #
include AveriaSerifFonts.mk

## Dijkstra
# See: https://fontsgeek.com/fonts/Dijkstra-Regular
DijkstraFontsURL := https://media.fontsgeek.com/download/zip/d/i/dijkstra-regular_iBTmg.zip
DijkstraFontsArchive := Dijkstra.zip
DijkstraFonts := \
    Dijkstra?Regular.ttf \
    #
include DijkstraFonts.mk

## Bubblegum
BubblegumSansFontsURL := https://www.fontsquirrel.com/fonts/download/bubblegum-sans
BubblegumSansFontsArchive := BubblegumSans.zip
BubblegumSansFonts := \
    BubblegumSans-Regular.otf \
    #
include BubblegumSansFonts.mk


## Microsoft free fonts
msttcorefonts:
ifneq ($(uname),Darwin)
	! type apt-get >/dev/null 2>&1 || \
	dpkg -L msttcorefonts >/dev/null 2>&1 || \
	dpkg -L ttf-mscorefonts-installer >/dev/null 2>&1 || \
	sudo apt-get install msttcorefonts
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

