; PC-6001mkII 320x200 console and graphics (mode MC6847_MODE_MK2 = 3 of
; classic/video/mc6847): two bit planes, plane 0 at the screen's base (the crt's
; __pc6001mk2_vram: $C000 for the disc, $8000 for a cartridge) and plane 1 $2000
; on, 40 bytes a pixel row, the leftmost pixel of a byte its bit 7; a pixel's
; pen is its plane 0 bit + 2 * its plane 1 bit, and the four pens are the
; colours of the set $C0 chooses (the default set 4 is green, yellow, blue, red:
; -pragma-define:CRT_PC6001MK2_COLOURSET=n).  The console is 40x25 cells of 8x8
; pixels, a cell its glyph in the ink pen over the paper pen.
; In pc6001mk2.lib, linked ahead of pc6001_clib by -subtype=mk2disc, so these
; replace the do-nothing stubs the PC-6001 has.

    SECTION     code_driver
    PUBLIC      __pc6001mk2_set_mode
    PUBLIC      __pc6001mk2_init
    EXTERN      __pc6001mk2_cls
    EXTERN      __pc6001mk2_colourset
    EXTERN      __pc6001mk2_b0
    EXTERN      __mc6847_mode
    EXTERN      __console_w
    EXTERN      generic_console_caps
    INCLUDE     "ioctl.def"

    defc        MODE_MK2=3
    defc        CAPS_MK2=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR

    PUBLIC      CLIB_GENCON_CAPS_MK2
    defc        CLIB_GENCON_CAPS_MK2=CAPS_MK2

; The ioctl IOCTL_GENCON_SET_MODE for mode 3
; (classic/video/mc6847/stdio/generic_console_ioctl.asm): the video hardware
; ($C1 first: an emulator takes the VRAM base at the $B0 write; $B0: bits 2-1
; choose the screen's base, bit 0 clear has the timer running; the crt's
; __pc6001mk2_b0), a 40x25 console, the screen cleared.  Exit: nc.
__pc6001mk2_set_mode:
__pc6001mk2_init:
    ld          a, MODE_MK2
    ld          (__mc6847_mode), a
    ld          de, 40+25*256
    ld          (__console_w), de
    ld          a, CAPS_MK2
    ld          (generic_console_caps), a
    xor         a
    out         ($c1), a
    ld          a, __pc6001mk2_colourset
    out         ($c0), a
    ld          a, __pc6001mk2_b0
    out         ($b0), a
    call        __pc6001mk2_cls
    and         a
    ret
