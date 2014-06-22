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



## Envy Code R, Damien Guard's coding font (monospace)
# See: http://damieng.com/fonts/envy-code-r
EnvyCodeRFontsURL := http://download.damieng.com/fonts/original/EnvyCodeR-PR7.zip
EnvyCodeRFontsArchive := EnvyCodeR.zip
EnvyCodeRFonts := \
    Envy?Code?R?Bold.ttf   \
    Envy?Code?R?Italic.ttf \
    Envy?Code?R.ttf        \
    #
include EnvyCodeRFonts.mk

## Inconsolata (monospace)
# See: http://www.levien.com/type/myfonts/inconsolata.html
InconsolataFontsURL := http://www.levien.com/type/myfonts/Inconsolata.otf
InconsolataFonts := \
    Inconsolata.otf \
    #
include InconsolataFonts.mk

## Anonymous Pro
# See: http://www.marksimonson.com/fonts/view/anonymous-pro
AnonymousProFontsURL := http://www.marksimonson.com/assets/content/fonts/AnonymousPro-1.002.zip
AnonymousProFontsArchive := AnonymousPro.zip
AnonymousProFonts := \
    Anonymous?Pro.ttf    \
    Anonymous?Pro?I.ttf  \
    Anonymous?Pro?B.ttf  \
    Anonymous?Pro?BI.ttf \
    #
include AnonymousProFonts.mk

## Ubuntu Font Family (monospace, sans-serif)
# See: http://font.ubuntu.com
UbuntuFontsURL := http://font.ubuntu.com/download/ubuntu-font-family-0.80.zip
UbuntuFontsArchive := Ubuntu.zip
UbuntuFonts := \
    UbuntuMono-R.ttf  \
    UbuntuMono-RI.ttf \
    UbuntuMono-B.ttf  \
    UbuntuMono-BI.ttf \
    Ubuntu-R.ttf      \
    Ubuntu-RI.ttf     \
    Ubuntu-B.ttf      \
    Ubuntu-BI.ttf     \
    Ubuntu-M.ttf      \
    Ubuntu-MI.ttf     \
    Ubuntu-L.ttf      \
    Ubuntu-LI.ttf     \
    Ubuntu-C.ttf      \
    #
include UbuntuFonts.mk

## Consola Mono (monospace)
# See: http://openfontlibrary.org/en/font/consolamono
ConsolaMonoFontsURL := http://openfontlibrary.org/assets/downloads/consolamono/61cc2afcc4eca96efe7c6ebf178d39df/consolamono.zip
ConsolaMonoFontsArchive := ConsolaMono.zip
ConsolaMonoFonts := \
    ConsolaMono.ttf      \
    ConsolaMono-Bold.ttf \
    #
include ConsolaMonoFonts.mk

## Fantasque Sans Mono (monospace)
# See: http://openfontlibrary.org/en/font/fantasque-sans-mono
FantasqueSansMonoFontsURL := http://openfontlibrary.org/assets/downloads/fantasque-sans-mono/d9468644396932f3eea03b16c132f620/fantasque-sans-mono.zip
FantasqueSansMonoFontsArchive := FantasqueSansMono.zip
FantasqueSansMonoFonts := \
    FantasqueSansMono-Regular.ttf    \
    FantasqueSansMono-RegItalic.ttf  \
    FantasqueSansMono-Bold.ttf       \
    FantasqueSansMono-BoldItalic.ttf \
    #
include FantasqueSansMonoFonts.mk

## ProFont (monospace)
# See: http://tobiasjung.name/profont/
ifneq ($(uname),Darwin)
    ProFontFontsURL := http://tobiasjung.name/downloadfile.php?file=ProFontWinTweaked.zip
    ProFontFontsArchive := ProFont.zip
    ProFontFonts := \
        ProFontWindows.ttf
        #
    include ProFontFonts.mk
    ProFontBoldFontsURL := http://tobiasjung.name/downloadfile.php?file=ProFont-Windows-Bold.zip
    ProFontBoldFontsArchive := ProFontBold.zip
    ProFontBoldFonts := \
        ProFontWindows-Bold.ttf \
        #
    include ProFontBoldFonts.mk
else
    ## ProFontX for Mac OS X
    # See: http://faisal.com/software/profontx/
    ProFontXFontsURL := http://faisal.com/software/profontx/ProFontX.zip
    ProFontXFontsArchive := ProFontX.zip
    ProFontXFonts := \
        ProFontX \
        #
    include ProFontXFonts.mk
endif

## Courier Code (monospace)
# See: http://openfontlibrary.org/en/font/courier-code
CourierCodeFontsURL := http://openfontlibrary.org/assets/downloads/courier-code/d0b044fc63eb2e97d49d433acac9053d/courier-code.zip
CourierCodeFontsArchive := CourierCode.zip
CourierCodeFonts := \
    CourierCode-Roman.ttf      \
    CourierCode-Italic.ttf     \
    CourierCode-Bold.ttf       \
    CourierCode-BoldItalic.ttf \
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
# See: http://hangeul.naver.com
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

## Crimson (serif)
# See: http://openfontlibrary.org/en/font/crimson
CrimsonFontsURL := http://openfontlibrary.org/assets/downloads/crimson/6feb6f6187adb04e0ea4a40f69101d98/crimson.zip
CrimsonFontsArchive := Crimson.zip
CrimsonFonts := \
    Crimson-Roman.otf      \
    Crimson-Italic.otf     \
    Crimson-Bold.otf       \
    #
include CrimsonFonts.mk
# See: http://sourceforge.net/projects/crimsontext/
CrimsonTextFontsURL := http://www.fontsquirrel.com/fonts/download/crimson
CrimsonTextFontsArchive := CrimsonText.zip
CrimsonTextFonts := \
    CrimsonText-Roman.ttf          \
    CrimsonText-Italic.ttf         \
    CrimsonText-SemiBold.ttf       \
    CrimsonText-SemiBoldItalic.ttf \
    CrimsonText-Bold.ttf           \
    CrimsonText-BoldItalic.ttf     \
    #
include CrimsonTextFonts.mk

## Vollkorn (serif)
# See: http://vollkorn-typeface.com
VollkornFontsURL := http://vollkorn-typeface.com/download/vollkorn-3-005.zip
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
# See: http://sourceforge.net/projects/sourcecodepro.adobe/
SourceCodeProFontsURL := http://downloads.sourceforge.net/project/sourcecodepro.adobe/SourceCodePro_FontsOnly-1.017.zip
SourceCodeProFontsArchive := SourceCodePro.zip
SourceCodeProFonts := \
    SourceCodePro-Regular.ttf    \
    SourceCodePro-ExtraLight.ttf \
    SourceCodePro-Light.ttf      \
    SourceCodePro-Semibold.ttf   \
    SourceCodePro-Bold.ttf       \
    SourceCodePro-Black.ttf      \
    #
include SourceCodeProFonts.mk

## Adobe's Source Serif Pro (serif)
# See: http://sourceforge.net/projects/sourceserifpro.adobe/
SourceSerifProFontsURL := http://downloads.sourceforge.net/project/sourceserifpro.adobe/SourceSerifPro_FontsOnly-1.014.zip
SourceSerifProFontsArchive := SourceSerifPro.zip
SourceSerifProFonts := \
    SourceSerifPro-Regular.ttf      \
    SourceSerifPro-It.ttf           \
    SourceSerifPro-ExtraLight.ttf   \
    SourceSerifPro-ExtraLightIt.ttf \
    SourceSerifPro-Light.ttf        \
    SourceSerifPro-LightIt.ttf      \
    SourceSerifPro-Semibold.ttf     \
    SourceSerifPro-SemiboldIt.ttf   \
    SourceSerifPro-Bold.ttf         \
    SourceSerifPro-BoldIt.ttf       \
    SourceSerifPro-Black.ttf        \
    SourceSerifPro-BlackIt.ttf      \
    #
include SourceSerifProFonts.mk

## Adobe's Source Sans Pro (sans-serif)
# See: http://sourceforge.net/projects/sourcesans.adobe/
SourceSansProFontsURL := http://downloads.sourceforge.net/project/sourcesans.adobe/SourceSansPro_FontsOnly-1.050.zip
SourceSansProFontsArchive := SourceSansPro.zip
SourceSansProFonts := \
    SourceSansPro-Regular.ttf      \
    SourceSansPro-It.ttf           \
    SourceSansPro-ExtraLight.ttf   \
    SourceSansPro-ExtraLightIt.ttf \
    SourceSansPro-Light.ttf        \
    SourceSansPro-LightIt.ttf      \
    SourceSansPro-Semibold.ttf     \
    SourceSansPro-SemiboldIt.ttf   \
    SourceSansPro-Bold.ttf         \
    SourceSansPro-BoldIt.ttf       \
    SourceSansPro-Black.ttf        \
    SourceSansPro-BlackIt.ttf      \
    #
include SourceSansProFonts.mk

## Crusoe Text (sans-serif)
# See: http://openfontlibrary.org/en/font/crusoe-text
CrusoeTextFontsURL := http://openfontlibrary.org/assets/downloads/crusoe-text/e045c0cbb955e2c4cc1dfbbf844b240c/crusoe-text.zip
CrusoeTextFontsArchive := CrusoeText.zip
CrusoeTextFonts := \
    CrusoeText-Regular.ttf \
    CrusoeText-Italic.ttf  \
    CrusoeText-Bold.ttf    \
    #
include CrusoeTextFonts.mk

## Avería Serif (serif)
# See: http://openfontlibrary.org/en/font/averia-serif
AveriaSerifFontsURL := http://openfontlibrary.org/assets/downloads/averia-serif/51e3ae7cf61b932c613416e6e0a05e40/averia-serif.zip
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

