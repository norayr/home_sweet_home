# original version of script is at https://gist.github.com/MichaelBitard/3531813
# -- noch
rules="85-typematrix.rules"
setmap="set_typematrix_dvp"

all: install

install:
				cp $(rules)  /etc/udev/rules.d/
				cp $(setmap) /usr/bin/

uninstall:
				rm /etc/udev/rules.d/$(rules)
				rm /usr/bin/$(setmap)
