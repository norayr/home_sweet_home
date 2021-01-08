# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias "r"="sudo -i"
alias "flist"="flatpak --user remote-ls flathub"

#remove flatpak
#zypper remove flatpak flatpak-runner flatpak-maliit-plugin-qt"
#rm -rf /home/defaultuser/.local/share/flatpak/
