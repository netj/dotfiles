# gnome-terminal profile
NAME=Wizard
install:
	key=/apps/gnome-terminal/global/profile_list;\
	profiles=`gconftool --get $$key | \
	sed -e 's/^\[\|\]$$//g' | tr , '\n' | grep -v "^$(NAME)$$" | \
	grep -v '^$$' | tr '\n' ,`; \
	gconftool --set --type=list --list-type=string \
		$$key "[$${profiles}$(NAME)]"
	gconftool --load gconf.xml
