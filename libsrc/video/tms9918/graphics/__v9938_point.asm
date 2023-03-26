

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_point

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __v9938_get_vdp_status
EXTERN  __v9938_wait_vdp


;****************************************************************
;  List 4.21   POINT sample
;                to use, set H, L as follows
;                POINT ( x:HD, y:LE )
;                returns:   A := COLOR CODE
;****************************************************************
__v9938_point:
    call    l_tms9918_disable_interrupts
    call    __v9938_wait_vdp

    ld      a,32
    out     (VDP_CMD),a
    ld      a,80H+17
    out     (VDP_CMD),a

    ld      bc,VDP_PORT3
    xor     a
    out     (c),h
    out     (c),d
    out     (c),l
    out     (c),e

    out     (VDP_CMD),a
    ld      A,80H+45
    out     (VDP_CMD),a
    ld      A,01000000B
    out     (VDP_CMD),a
    ld      A,80H+46
    out     (VDP_CMD),a
    call    __v9938_wait_vdp
    ld      a,7
    call    __v9938_get_vdp_status
    push    af
    xor     a
    call    __v9938_get_vdp_status
    pop     hl
    call    l_tms9918_enable_interrupts
    ld      a,h
    ret


ENDIF