#this is used when the pinebook booted from sdcard because emmc is disabled, to enable emmc
echo fe330000.mmc >/sys/bus/platform/drivers/sdhci-arasan/unbind
echo fe330000.mmc >/sys/bus/platform/drivers/sdhci-arasan/bind
