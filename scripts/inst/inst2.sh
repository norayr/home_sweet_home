set -x
CHROOT="/mnt/gentoo"
ROOT="/dev/sda1"
SWAP="/dev/sda2"
CHOST="x86_64-pc-linux-gnu"
MARCH="core2"
CPU_FLAGS="mmx mmxext sse sse2 sse3 ssse3"
NCPU="3"

export PS1="(chroot) $PS1"

#echo "hello from chroot"
#echo "set root password"
#passwd
#useradd -m inky
#passwd inky
#gpasswd -a inky wheel

#if ping -c 1 google.com &> /dev/null
#then
ego sync

#echo "# <fs>                  <mountpoint>    <type>          <opts>          <dump/pass>" > /etc/fstab
#echo "$ROOT               /               ext4            noatime         0 1" >> /etc/fstab
#echo "$SWAP               none            swap            sw              0 0"
#cp fstab /etc/
cp /usr/share/zoneinfo/Asia/Yerevan /etc/localtime

MCONF="/etc/portage/make.conf"
#echo "CFLAGS=\"-O2 -march=$MARCH -O2 -pipe\"" > $MCONF
#echo "CXXFLAGS=\"-O2 -march=$MARCH -O2 -pipe\"" >> $MCONF
#echo "CPU_FLAGS_X86=\"$CPU_FLAGS\"" >> $MCONF
#echo "CHOST=\"$CHOST\"" >> $MCONF
#echo "MAKEOPTS=\"-j$NCPU\"" >> $MCONF

#echo "CODECS=\"a52 aac dirac dts dv dvd dvdnav faad ffmpeg flac fluidsynth lame mad mikmod mp2 mp3 midi ogg portaudio quicktime schroedinger speex theora timidity v4l vorbis vst wavpack webm x264\"" >> $MCONF
#echo "IMAGES=\"aalib apng jpeg exif gif mng png pnm svg tiff webp xpm\"" >> $MCONF
#echo "MINUS=\"-bindist -dbus -python -fortran -gnome -gstreamer -hal -arts -java -kde -llvm -perl -qt3 -qt4 -qt5 -qt -pulseaudio -systemd\"" >> $MCONF
#echo "DOC_FORMATS=\"djvu pdf\"" >> $MCONF
#echo "GENERAL=\"X alsa bash-completion bluetooth cairo crypt cups dbus evdev gles2 icu introspection ipv4 ipv6 jack musicbrainz ncurses nls nptl openmp spell ssl threads truetype unicode usb xrandr xscreensaver\"" >> $MCONF
#echo "USE=\"\$CODECS \$IMAGES \$MINUS \$MINUS \$DOC_FORMATS \$GENERAL\"" >> $MCONF
#echo "#ACCEPT_KEYWORDS=\"~amd64\"" >> $MCONF
#echo "#ACCEPT_LICENSE=\"*\"" >> $MCONF
#echo "LINGUAS=\"en hy_AM\"" >> $MCONF
#echo "L10N=\"en hy\"" >> $MCONF
#echo "DISTDIR=\"/funtoo/distfiles\"" >> $MCONF
#echo "PKGDIR=\"/funtoo/packages\"" >> $MCONF
#echo "VIDEO_CARDS=\"nouveau intel i965\"" >> $MCONF
#echo "CAMERAS=\"canon\"" >> $MCONF
#echo "QEMU_USER_TARGETS=\"x86_64 arm armeb ppc\"" >> $MCONF
#echo "QEMU_SOFTMMU_TARGETS=\"x86_64 arm ppc\"" >> $MCONF
#echo "PYTHON_TARGETS=\"python3_6 python2_7\"" >> $MCONF
#echo "PYTHON_SINGLE_TARGET=\"python3_6\"" >> $MCONF
#echo "LLVM_TARGETS=\"X86\"" >> $MCONF
#echo "CODECS=\"\"" >> $MCONF

#cp portage/make.conf /etc/portage/
#cp portage/package.use /etc/portage/
sed -i 's/keymap="us"/keymap="dvorak"/' /etc/conf.d/keymaps
echo 'modules="cpufreq_userspace acpi_cpufreq snd_mixer_oss"' >> /etc/conf.d/modules
emerge iucode_tool intel-microcode grub linux-firmware app-misc/screen app-misc/mc wireless-tools wpa_supplicant
grub-install --target=i386-pc --no-floppy /dev/sda
ego boot update

emerge lm_sensors windowmaker xorg-x11 xterm arandr xscreensaver bubblemon wmbattery wmclock wmix wmmemload wmmon+smp wmwifi sshfs encfs sudo pwgen syslog-ng vim pidgin fpc lazarus ddd tkdiff gimp darktable geeqie imagemagick qrencode dino mplayer tcptraceroute traceroute bind-tools openntpd telnet-bsd tigervnc whois youtube-dl tor exfat-utils fuse-exfat terminology firefox seamonkey thunderbird 
grub-install --target=i386-pc --no-floppy /dev/sda
ego boot update
#else
#  echo "no network"
#fi
