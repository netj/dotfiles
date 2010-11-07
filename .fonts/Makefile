# Makefile for setting up netj's fonts
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-03-20

ifeq ($(shell uname),Darwin)
    # Mac
    FONTSDIR := ~/Library/Fonts
else
    FONTSDIR := .
endif

UNZIP = unzip -o $< $(@F) -d $(@D)

.PHONY: all install uninstall clean
all: install
# end of prologue


# Microsoft free fonts
msttcorefonts:
	! type apt-get &>/dev/null || dpkg -l msttcorefonts &>/dev/null || \
	sudo apt-get install msttcorefonts


## Nanum Fonts
NanumFontNames := \
    NanumGothic.ttf             \
    NanumGothicBold.ttf         \
    NanumGothicExtraBold.ttf    \
    NanumMyeongjo.ttf           \
    NanumMyeongjoBold.ttf       \
    NanumMyeongjoExtraBold.ttf  \
    NanumBrush.ttf              \
    NanumPen.ttf                \
    #
NanumFonts := $(NanumFontNames:%=$(FONTSDIR)/%)
NanumFontsURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip
NanumFontsZip := $(shell basename $(NanumFontsURL))
$(NanumFonts): $(NanumFontsZip)
	$(UNZIP)
$(NanumFontsZip):
	wget -N $(NanumFontsURL)
IntermediateFiles += $(NanumFontsZip)
InstalledFiles += $(NanumFonts)


## Seoul Fonts
SeoulFontNames := \
    SeoulHangangB.ttf	\
    SeoulHangangEB.ttf	\
    SeoulHangangL.ttf	\
    SeoulHangangM.ttf	\
    SeoulNamsanB.ttf	\
    SeoulNamsanEB.ttf	\
    SeoulNamsanL.ttf	\
    SeoulNamsanM.ttf	\
    SeoulNamsanvert.ttf	\
    #
SeoulFonts := $(SeoulFontNames:%=$(FONTSDIR)/%)
SeoulFontsZip := SeoulFonts_TTF.zip
$(SeoulFonts): $(SeoulFontsZip)
	$(UNZIP)
$(SeoulFontsZip):
	wget -NO $@ 'http://design.seoul.go.kr/js/boardFileDown.php?model=PolicyData&id=251&field_path=file_path&field_name=file_name1&no=1&is_crypt=false'
IntermediateFiles += $(SeoulFontsZip)
InstalledFiles += $(SeoulFonts)


## Dijkstra
DijkstraFontNames := \
    dijkstra.ttf	\
    #
DijkstraFonts := $(DijkstraFontNames:%=$(FONTSDIR)/%)
DijkstraFontsZip := Dijkstra.zip
$(DijkstraFonts): $(DijkstraFontsZip)
	$(UNZIP)
$(DijkstraFontsZip):
	wget -NO $@ http://www.fonts101.com/download/34398/Dijkstra/A5922C74E09F7630B830C8BDB36343B0.aspx
IntermediateFiles += $(DijkstraFontsZip)
InstalledFiles += $(DijkstraFonts)




# begin of epilogue
install: $(InstalledFiles) \
    msttcorefonts	\
    #
uninstall:
	rm -f $(InstalledFiles)
clean:
	rm -f $(IntermediateFiles)
