;
; Console colours (conio colours, or the pixel values if CLIB_CONIO_NATIVE_COLOUR is set).  Inverse is read from generic_console_flags when a
; character is drawn.
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_set_ink
    PUBLIC  __mz2500_gfxcon_set_paper
    EXTERN  conio_map_colour
    EXTERN  __mz2500_con_ink
    EXTERN  __mz2500_con_paper

__mz2500_gfxcon_set_ink:
    call    conio_map_colour
    and     15
    ld      (__mz2500_con_ink), a
    ret

__mz2500_gfxcon_set_paper:
    call    conio_map_colour
    and     15
    ld      (__mz2500_con_paper), a
    ret
