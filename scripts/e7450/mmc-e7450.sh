rmmod sdhci sdhci_pci sdhci_acpi
sleep 1
rmmod sdhci
sleep 1
modprobe sdhci debug_quirks2="0x10000"
sleep 1
modprobe sdhci_pci
