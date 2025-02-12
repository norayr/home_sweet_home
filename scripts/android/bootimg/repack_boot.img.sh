#mkbootimg --kernel zImage \
/home/inky/src/not_mine/c/mkbootimg/mkbootimg.py --kernel zImage \
          --ramdisk new_initrd.img \
          --base 0x30000000 \
          --kernel_offset 0x00008000 \
          --ramdisk_offset 0x01000000 \
          --tags_offset 0x00000100 \
          --cmdline "no_console_suspend" \
          --pagesize 4096 \
          --output new_boot.img

