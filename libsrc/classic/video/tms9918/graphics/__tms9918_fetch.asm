
    MODULE  __tms9918_fetch
    SECTION code_video_vdp
    PUBLIC  __tms9918_fetch

    ; EXTERN  __tms9918_attribute
    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts

    INCLUDE "classic/gfx/grafix.inc"
    INCLUDE "classic/video/tms9918/vdp.inc"

;
;	$Id: __tms9918_fetch.asm $
;


__tms9918_fetch:

    call    l_tms9918_disable_interrupts

IF  VDP_CMD<0
    ld      a, l
    ld      (-VDP_CMD), a
    ld      a, h
    and     @00111111
    ld      (-VDP_CMD), a
    ld      a, (-VDP_DATAIN)
ELSE
    push    bc
    ld      bc, VDP_CMD
    out     (c), l
    ld      a, h                        ; MSB of video mem ptr
    and     @00111111                   ; masked with "read command" bits
    out     (c), a
    ld      bc, VDP_DATAIN
    ld      bc, VDP_DATAIN              ;delay
    nop
    in      a, (c)
    pop     bc
ENDIF

    ex      af, af
    call    l_tms9918_enable_interrupts
    ex      af, af
    ret
