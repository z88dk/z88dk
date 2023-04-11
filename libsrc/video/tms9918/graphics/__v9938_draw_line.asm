
SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_draw_line

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __v9938_wait_vdp
EXTERN  __gfx_coords


;****************************************************************
;  List 4.16   LINE sample
;                to use, set H, L, D, e, B, A and go
;                draw LINE (H,L)-(D,E) with color B, log-op A
;****************************************************************
;
;----- program start -----

__v9938_draw_line:   
    ld      (__gfx_coords),de
    ld      c,a
    call    l_tms9918_disable_interrupts
    ld      a,c
    push    af                      ;save LOGICAL OPERATION
    push    bc                      ;save COLOR
    call    __v9938_wait_vdp
    ld      a,36
    out     (VDP_CMD),a
    ld      a,$80+17
    out     (VDP_CMD),a                   ;R#17 := 36

    ld      bc,VDP_PORT3
    xor     a
    out     (c),h                   ;DX
    out     (c),a
    out     (c),l                   ;DY
    out     (c),a

    ld      a,h                     ;make DX and DIX
    sub     d
    ld      d,00000100B
    jp      nc,LINE1
    ld      D,00000000B
    neg
LINE1:  
    ld      h,a                     ;H := DX , D := DIX

    ld      a,l                     ;make DY and DIY
    sub     e
    ld      e,00001000B
    jp      nc,LINE2
    ld      e,00000000B
    neg
LINE2:  
    ld      L,a                     ;L := DY , E := DIY

    cp      h                       ;make Maj and Min
    jp      c,LINE3
    xor     a
    out     (c),l                   ;long side
    out     (c),a
    out     (c),h                   ;short side
    out     (c),a
    ld      a,00000001B             ;MAJ := 1
    jp      LINE4

LINE3:  
    xor     a
    out     (c),h                   ;NX
    out     (c),a
    out     (c),l                   ;NY
    out     (c),a
    ld      a,00000000B             ;MAJ := 0

LINE4:  
    or      d
    or      e                       ;A := DIX , DIY , MAJ
    pop     hl                      ;H := COLOR
    out     (c),h
    out     (c),a
    pop     af                      ;A := LOGICAL OPERATION
    or      01110000B
    out     (c),a
    ld      a,$8F
    out     (c),a
    call    __v9938_wait_vdp
    call    l_tms9918_enable_interrupts
    ret

ENDIF