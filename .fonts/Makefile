# Makefile for setting up netj's fonts
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-03-20

ifeq ($(shell uname),Darwin)
    # Mac
    FONTSDIR := ~/Library/Fonts
else
    FONTSDIR := .
endif

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
	unzip -o $< $(@F) -d $(@D)
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
	unzip -o $< $(@F) -d $(@D)
$(SeoulFontsZip):
	wget -NO $@ 'http://design.seoul.go.kr/js/boardFileDown.php?model=PolicyData&id=251&field_path=file_path&field_name=file_name1&no=1&is_crypt=false'
IntermediateFiles += $(SeoulFontsZip)
InstalledFiles += $(SeoulFonts)



# begin of epilogue
install: $(InstalledFiles) \
    msttcorefonts	\
    #
uninstall:
	rm -f $(InstalledFiles)
clean:
	rm -f $(IntermediateFiles)
