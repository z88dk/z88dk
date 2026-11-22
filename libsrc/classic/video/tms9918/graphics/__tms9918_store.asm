
    MODULE  __tms9918_store
    SECTION code_video_vdp
    PUBLIC  __tms9918_store

    EXTERN  __tms9918_attribute
    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts

    INCLUDE "classic/gfx/grafix.inc"
    INCLUDE "classic/video/tms9918/vdp.inc"

;
;	$Id: __tms9918_store.asm $
;


__tms9918_store:
         ; ->   ld (hl),a ... (offset) = pattern

    ex      af, af
    call    l_tms9918_disable_interrupts
    ld      a, l                        ; LSB of video memory ptr
IF  VDP_CMD<0
    VDPOUT  (VDP_CMD)
    ld      a, h
    and     @00111111
    or      @01000000
    VDPOUT  (VDP_CMD)
    push    bc                          ; delay
    pop     bc
    ex      af, af
    VDPOUT  (VDP_DATA)
    push    bc                          ; delay
    pop     bc

   ; And support colour as well
    ex      af, af
    ld      a, l
    VDPOUT  (VDP_CMD)
    ld      a, h
    add     $20                         ;Move to bitmap to colour
    and     @00111111
    or      @01000000
    VDPOUT  (VDP_CMD)
    ld      a, (__tms9918_attribute)
    push    bc
    pop     bc
    VDPOUT  (VDP_DATA)

ELSE

    push    bc
    ld      bc, VDP_CMD
    out     (c), a
    ld      a, h                        ; MSB of video mem ptr
    and     @00111111                   ; masked with "write command" bits
    or      @01000000
    out     (c), a
    ex      af, af
    ld      bc, VDP_DATA
    push    bc                          ; delay
    pop     bc
    out     (c), a

   ; And support colour as well
    ex      af, af
    ld      bc, VDP_CMD
    push    bc                          ;delay
    pop     bc
    out     (c), l
    ld      a, h                        ; MSB of video mem ptr
    add     $20
    and     @00111111                   ; masked with "write command" bits
    or      @01000000
    out     (c), a
    ld      a, (__tms9918_attribute)
    ld      bc, VDP_DATA
    out     (c), a
    ex      af, af
    pop     bc

ENDIF
    ex      af, af
    call    l_tms9918_enable_interrupts
    ex      af, af
    ret

