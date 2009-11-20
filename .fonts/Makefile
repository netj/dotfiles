# Makefile for setting up netj's fonts
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-03-20

NanumFonts := 나눔고딕.ttf 나눔고딕Bold.ttf

.PHONY: all clean distclean
all: $(NanumFonts)
	# installing free Microsoft fonts
	! type apt-get || sudo apt-get install msttcorefonts
clean:
	rm -f NanumFont_TTF.zip
distclean: clean
	rm -f *.ttf

$(NanumFonts): NanumFont_TTF.zip
	unzip -o -O cp949 NanumFont_TTF.zip $@
NanumFont_TTF.zip:
	wget -N http://static.campaign.naver.com/nfs1/file/2008/11/hangeul2715/NanumFont_TTF.zip
