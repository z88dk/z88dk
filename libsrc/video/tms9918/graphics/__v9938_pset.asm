

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC __v9938_pset

EXTERN  __gfx_coords

EXTERN __v9938_wait_vdp
EXTERN l_tms9918_disable_interrupts
EXTERN l_tms9918_enable_interrupts

;****************************************************************
;  List 4.20   PSET sample
;                to use, set H, L, E, A as follows
;                pset (x:HD, y:LE), color:b, logi-OP:A
;****************************************************************
;

; a = 0 - place
; a = 0011 - xor


__v9938_pset:
    ld      c,a
    call    l_tms9918_disable_interrupts
    call    __v9938_wait_vdp
    ld      a,c
    push    af

    ld      a,36
    out     (VDP_CMD),a
    ld      a,$80+17
    out     (VDP_CMD),a

    ld      a,b         ;Save away the colour
    ex      af,af
    ld      bc,VDP_PORT3
    out     (c),h
    out     (c),d
    out     (c),l
    out     (c),e

    ld      a,44
    out     (VDP_CMD),a
    ld      a,$80+17
    out     (VDP_CMD),a

    ex      af,af       ;Get colour back
    out     (c),a
    xor     a
    out     (c),a

    ld      e,01010000B
    pop     af
    or      e
    out     (c),a

    call    __v9938_wait_vdp
    call    l_tms9918_enable_interrupts
    ret



ENDIF