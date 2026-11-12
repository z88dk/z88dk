; The default font of the mkII's 320x200 console (the PC-6001's is the ROM's
; character generator, which a program of its own does not have mapped): z88dk's
; 8x8 ZX font.  Another is chosen as elsewhere, with
; -pragma-redirect:CRT_FONT=_font_8x8_xxx or by the console's ioctl.

    SECTION     rodata_driver

    PUBLIC      CRT_FONT
    EXTERN      _font_8x8_zx_system

    defc        CRT_FONT=_font_8x8_zx_system
