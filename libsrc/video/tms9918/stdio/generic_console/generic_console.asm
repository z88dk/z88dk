

    MODULE	tms9918_generic_console
    SECTION code_video_vdp

    EXTERN	__tms9918_cls
    PUBLIC  __tms9918_scrollup
    PUBLIC  __tms9918_printc
    PUBLIC  __tms9918_set_ink
    PUBLIC  __tms9918_set_paper
    PUBLIC  __tms9918_set_attribute
    EXTERN  __tms9918_2bpp_attr
    EXTERN  __tms9918_8bpp_attr

    EXTERN  __tms9918_spec_funcs
    EXTERN  __tms9918_spec_funcs_end
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_map_colour
    EXTERN  __tms9918_scroll_func
    EXTERN  __tms9918_printc_func
    EXTERN  __tms9918_gencon_hook

    EXTERN  __vdp_mode0_term
    EXTERN  __vdp_mode1_term
    EXTERN  __vdp_mode0_80col_term
    EXTERN  __vdp_mode2_term
    EXTERN  __vdp_mode3_term
    EXTERN  __vdp_mode4_term
    EXTERN  __vdp_mode5_term
    EXTERN  __vdp_mode6_term
    EXTERN  __vdp_mode8_term
    EXTERN  __vdp_mode1_2_term
    

    EXTERN  l_dcal

    INCLUDE "video/tms9918/vdp.inc"


;
; The SPC-1000 has both a MC6847 and optionally a TMS9228A
;
; To support both we want the MC6847 to be the primary, and
; the VDP as the slave, so don't export the tms symbols as
; generic_console_*
;
; The Tatung Einstein has a TMS9928A as a main display and
; an 80 column 6845 as a secondary display.
;
IF VDP_EXPORT_DIRECT = 1
    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    defc        generic_console_cls = __tms9918_cls
    defc        generic_console_scrollup = __tms9918_scrollup
    defc        generic_console_printc = __tms9918_printc
    defc        generic_console_set_ink = __tms9918_set_ink
    defc        generic_console_set_paper = __tms9918_set_paper
    defc        generic_console_set_attribute = __tms9918_set_attribute
ENDIF


__tms9918_set_attribute:
    ret

__tms9918_set_ink:
IFDEF V9938
    ld      (__tms9918_8bpp_attr+0),a
ENDIF
    call    __tms9918_map_colour
IFDEF V9938
    ld      c,a     ;Save it for a moment
    rrca
    rrca
    and     @11000000
    ld      (__tms9918_2bpp_attr+0),a
    ld      a,c
ENDIF
    rla
    rla
    rla
    rla
    and     @11110000
    ld      b,0x0f
set_attr:
    ld      c,a
    ld      hl,__tms9918_attribute
    ld      a,(hl)
    and     b
    or      c
    ld      (hl),a
    ret

__tms9918_set_paper:
IFDEF V9938
    ld      (__tms9918_8bpp_attr+1),a
ENDIF
    call    __tms9918_map_colour
    and     15
IFDEF V9938
    ld      c,a     ;Save it for a moment
    rrca
    rrca
    and     @11000000
    ld      (__tms9918_2bpp_attr+1),a
    ld      a,c
ENDIF
    ld      b,0xf0
    jr      set_attr
        


__tms9918_scrollup:
    push    de
    push    bc
    ld      hl,(__tms9918_scroll_func)
    call    l_dcal
    pop     bc
    pop     de
    ret

; c = x
; b = y
; a = d = character to print
; e = raw
__tms9918_printc:
    push    ix
    ld      hl,(__tms9918_printc_func)
    call    l_dcal
    pop     ix
    ret

; Entry: a = screenmode
__tms9918_gencon_hook_func:
    ld      e,a
    ld      hl,mode_term_table - 2
loop:
    inc     hl
    inc     hl
    ld      a,(hl)
    inc     hl
    cp      255
    ret     z
    cp      e
    jr      nz,loop
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    ld      de,__tms9918_spec_funcs
    ld      bc, +(__tms9918_spec_funcs_end - __tms9918_spec_funcs)
    ldir
    ret


    SECTION rodata_video_vdp

mode_term_table:
    defb    0
    defw    __vdp_mode0_term
IF V9938 | F18A
    defb    80
    defw    __vdp_mode0_80col_term
ENDIF
    defb    1
    defw    __vdp_mode1_term
    defb    2
    defw    __vdp_mode2_term
    defb    3
    defw    __vdp_mode3_term
IFDEF V9938
    defb    4
    defw    __vdp_mode4_term
    defb    5
    defw    __vdp_mode5_term
    defb    6
    defw    __vdp_mode6_term
    defb    8
    defw    __vdp_mode8_term
ENDIF
    defb    81
    defw    __vdp_mode1_2_term
    defb    $ff


    SECTION code_crt_init

    ; Register a hook function so that we can get in on the mode changing too
    ld      hl,__tms9918_gencon_hook_func
    ld      (__tms9918_gencon_hook),hl

