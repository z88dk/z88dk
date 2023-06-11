SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_YMMM

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __v9938_wait_vdp

;****************************************************************
;  List 4.9   YMMM sample
;               to use, set L, E, B, C, D(bit 2) and go
;               VRAM (B,l)-(*,e) ⟶ VRAM (B,C)
;               DIX must be set in D(bit 2)
;****************************************************************
;
__v9938_YMMM:   
    call    l_tms9918_disable_interrupts
    push    bc
    call    __v9938_wait_vdp
    ld      a,34
    VDPOUT(VDP_CMD)
    ld      a,17+$80
    VDPOUT(VDP_CMD)     ;Set R#17 = 34 (so writes go there?)

    ld      bc,VDP_PORT3        ;sx
    out     (c),l
    xor     a
    out     (c),a

    ld      a,l                     ;make NY and DIY
    sub     e
    ld      e,00001000B
    jp      nc,YMMM1
    ld      e,00000000B
    neg
YMMM1:  
    ld      l,a                     ;L := NY , D := DIY

    ld      a,d
    or      e

    pop     de                      ;restore DX,dY
    push    af                      ;save DIX,dIY
    xor     a
    out     (c),d                   ;DX
    out     (c),a
    out     (c),e                   ;DY
    out     (c),a
    out     (c),a                   ;dummy
    out     (c),a                   ;dummy
    out     (c),l                   ;NY
    out     (c),a
    out     (c),a                   ;dummy
    pop     af
    out     (c),a                   ;DIX and DIY
    ld      a,11100000B             ;YMMM command
    out     (c),a
    call    __v9938_wait_vdp
    call    l_tms9918_enable_interrupts
    ret


ENDIF
