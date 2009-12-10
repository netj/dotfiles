# Makefile for setting up netj's fonts
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-03-20

NanumFontURL := http://static.campaign.naver.com/0/hangeul/renew/download/NanumFont_TTF.zip
NanumFonts := \
    나눔고딕.ttf           \
    나눔고딕Bold.ttf       \
    나눔고딕ExtraBold.ttf  \
    나눔명조.ttf           \
    나눔명조Bold.ttf       \
    나눔명조ExtraBold.ttf  \
    #

.PHONY: all clean distclean NanumFont_TTF.zip
all: $(NanumFonts)
	# installing free Microsoft fonts
	! type apt-get &>/dev/null || dpkg -l msttcorefonts &>/dev/null || \
	sudo apt-get install msttcorefonts
clean:
	rm -f NanumFont_TTF.zip
distclean: clean
	rm -f *.ttf

$(NanumFonts): NanumFont_TTF.zip
	unzip -o -O cp949 NanumFont_TTF.zip $@
NanumFont_TTF.zip:
	wget -N $(NanumFontURL)
