

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
;                pset (x:H, y:L), color:E, logi-OP:A
;****************************************************************
;

; a = 0 - place
; a = 0011 - xor


__v9938_pset:
    ld      (__gfx_coords),hl
    ld      d,a
    call    l_tms9918_disable_interrupts
    ld      a,d
    push    af
    call    __v9938_wait_vdp

    ld      a,36
    out     (VDP_CMD),a
    ld      a,$80+17
    out     (VDP_CMD),a

    ld      bc,VDP_PORT3
    xor     a
    out     (c),h
    out     (c),a
    out     (c),l
    out     (c),a

    ld      a,44
    out     (VDP_CMD),a
    ld      a,$80+17
    out     (VDP_CMD),a

    out     (c),e
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