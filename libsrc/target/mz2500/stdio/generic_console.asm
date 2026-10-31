; Sharp MZ-2500 console: the mode dispatcher
;
; The console has three modes, chosen with ioctl IOCTL_GENCON_SET_MODE (the default is CRT_MZ2500_CON_MODE, see the crt0):
;   0  the 40-column text screen, with ROM glyphs or an optional custom font and UDGs, 8 colours (text_console.asm)
;   1  the 80-column text screen, with ROM glyphs or an optional custom font and UDGs
;   2  the graphics screen, 320x200 in 16 colours, with the font and UDGs: 40 x 25 (the gfxcon files)
; These routines send each call to the one for the mode.  Neither uses the IPL.

    SECTION code_clib
    PUBLIC  generic_console_set_attribute
    PUBLIC  __mz2500_con_mode
    EXTERN  __MZ2500_CON_MODE
    EXTERN  mz2500_gfx_init
    EXTERN  __mz2500_textcon_init
    PUBLIC  generic_console_cls
    EXTERN  __mz2500_gfxcon_cls
    EXTERN  __mz2500_textcon_cls
    PUBLIC  generic_console_scrollup
    EXTERN  __mz2500_gfxcon_scrollup
    EXTERN  __mz2500_textcon_scrollup
    PUBLIC  generic_console_printc
    EXTERN  __mz2500_gfxcon_printc
    EXTERN  __mz2500_textcon_printc
    PUBLIC  generic_console_vpeek
    EXTERN  __mz2500_gfxcon_vpeek
    EXTERN  __mz2500_textcon_vpeek
    PUBLIC  generic_console_set_ink
    EXTERN  __mz2500_gfxcon_set_ink
    EXTERN  __mz2500_textcon_set_ink
    PUBLIC  generic_console_set_paper
    EXTERN  __mz2500_gfxcon_set_paper
    EXTERN  __mz2500_textcon_set_paper

generic_console_cls:
    push    af
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, graphics_cls
    pop     af
    jp      __mz2500_textcon_cls
graphics_cls:
    pop     af
    jp      __mz2500_gfxcon_cls

generic_console_scrollup:
    push    af
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, graphics_scrollup
    pop     af
    jp      __mz2500_textcon_scrollup
graphics_scrollup:
    pop     af
    jp      __mz2500_gfxcon_scrollup

generic_console_printc:
    push    af
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, graphics_printc
    pop     af
    jp      __mz2500_textcon_printc
graphics_printc:
    pop     af
    jp      __mz2500_gfxcon_printc

generic_console_vpeek:
    push    af
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, graphics_vpeek
    pop     af
    jp      __mz2500_textcon_vpeek
graphics_vpeek:
    pop     af
    jp      __mz2500_gfxcon_vpeek

generic_console_set_ink:
    push    af
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, graphics_set_ink
    pop     af
    jp      __mz2500_textcon_set_ink
graphics_set_ink:
    pop     af
    jp      __mz2500_gfxcon_set_ink

generic_console_set_paper:
    push    af
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, graphics_set_paper
    pop     af
    jp      __mz2500_textcon_set_paper
graphics_set_paper:
    pop     af
    jp      __mz2500_gfxcon_set_paper

generic_console_set_attribute:
    ret

    SECTION code_crt_init
    ld      a, (__mz2500_con_mode)
    cp      2
    jr      z, gfx_init
    call    __mz2500_textcon_init
    call    __mz2500_textcon_cls
    jr      no_gfx_init
gfx_init:
    call    mz2500_gfx_init             ;320x200 in 16 colours and the palette
    call    __mz2500_gfxcon_cls
no_gfx_init:

    SECTION data_clib
__mz2500_con_mode:  defb    __MZ2500_CON_MODE

