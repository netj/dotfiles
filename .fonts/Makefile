# Makefile for setting up netj's fonts
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-03-20

ifeq ($(shell uname),Darwin)
    # Mac
    FONTSDIR := ~/Library/Fonts
else
    FONTSDIR := .
endif

NanumFontURL := http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip
NanumFontsZip := $(shell basename $(NanumFontURL))
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

.PHONY: all clean distclean $(NanumFontsZip)
all: $(NanumFonts)
	# installing free Microsoft fonts
	! type apt-get &>/dev/null || dpkg -l msttcorefonts &>/dev/null || \
	sudo apt-get install msttcorefonts
clean:
	rm -f $(NanumFontsZip)
distclean: clean
	rm -f $(NanumFonts)

$(NanumFonts): $(NanumFontsZip)
	unzip -o $< $(@F) -d $(@D)
$(NanumFontsZip):
	wget -N $(NanumFontURL)

