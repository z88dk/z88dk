;
; Console ioctls: the font (characters 32-127) and the UDGs (128-255) are pointers to 8 bytes a character, the font starting at character 32 and the
; UDGs at 128.  Mode 0 is 40-column text, mode 1 is 80-column text, and mode 2 is graphics (40 x 25).  Font and UDG ioctls are available in all modes.
;
    MODULE  generic_console_ioctl
    SECTION code_clib
    PUBLIC  generic_console_ioctl
    EXTERN  generic_console_cls
    EXTERN  mz2500_gfx_init
    EXTERN  __mz2500_textcon_load_pcg
    EXTERN  __mz2500_textcon_rom
    EXTERN  __mz2500_textcon_init
    EXTERN  __mz2500_con_mode
    EXTERN  __console_w
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR|CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS

; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg
    ld      a, b
    or      c
    jr      nz, new_font
    call    __mz2500_textcon_rom        ;(no font: the text screen goes back to the ROM's glyphs)
    jr      success
new_font:
    ld      (generic_console_font32), bc
    call    __mz2500_textcon_load_pcg
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, check_mode
    ld      (generic_console_udg32), bc
    ld      a, b
    or      c
    call    nz, __mz2500_textcon_load_pcg
    jr      success
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, failure
    ld      a, c
    cp      3
    jr      nc, failure
    and     a
    jr      z, text_40
    cp      1
    jr      z, text_80
    jr      graphics_mode
text_40:
    ld      a, $0f                       ;set PIO port A to output
    out     ($e9), a
    in      a, ($e8)
    and     $df                          ;CH80 = 0: 40 columns
    out     ($e8), a
    xor     a
    ld      (__mz2500_con_mode), a
    ld      hl, 40 + 25 * 256
    ld      (__console_w), hl
    call    __mz2500_textcon_init
    jr      clear
text_80:
    ld      a, $0f                       ;set PIO port A to output
    out     ($e9), a
    in      a, ($e8)
    or      $20                          ;CH80 = 1: 80 columns
    out     ($e8), a
    ld      a, 1
    ld      (__mz2500_con_mode), a
    ld      hl, 80 + 25 * 256
    ld      (__console_w), hl
    call    __mz2500_textcon_init
    jr      clear
graphics_mode:
    ld      a, 2
    ld      (__mz2500_con_mode), a
    ld      hl, 40 + 25 * 256
    ld      (__console_w), hl
    call    mz2500_gfx_init
clear:
    call    generic_console_cls
    jr      success
failure:
    scf
    ret
