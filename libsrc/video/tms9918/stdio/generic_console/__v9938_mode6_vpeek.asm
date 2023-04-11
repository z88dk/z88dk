

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"


IFDEF V9938

PUBLIC  __v9938_mode6_vpeek

EXTERN  __v9938_mode6_xypos
EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __tms9918_vpeek_continue
EXTERN  __tms9918_2bpp_attr
EXTERN  SETRD


__v9938_mode6_vpeek:
    ; b = x, c = y
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    push    hl                ;save buffer
    ex      de,hl
    call    __v9938_mode6_xypos

    call    l_tms9918_disable_interrupts

    ld      b,8
vpeek_mode6_row_loop:
    push    bc
    push    de      ;Save buffer
    push    hl          ;We don't need hl for now, so we can use that reg for something useful
    call    SETRD

    ld      d,@10000000
    ld      c,0     ;Resultant byte
    ld      a,2     ;We need to do this loop twice
vpeek_mode6_loop_2:
    ex      af,af
    ld      e,@11000000
IF VDP_DATAIN < 0
    ld      a,(-VDP_DATAIN)
ELIF VDP_DATAIN < 256
    in      a,(VDP_DATAIN)
ELSE
    ;; TODO
ENDIF
    ld      h,a
    ld      a,(__tms9918_2bpp_attr+1)
    ld      l,a

    ld      b,4         ;4 interations
vpeek_mode6_loop_3:
    ld      a,h
    and     e
    jr      z,mode6_not_set
    cp      l
    jr      z,mode6_not_set
    ld      a,c
    or      d
    ld      c,a
mode6_not_set:
    srl     l
    srl     l
    srl     d
    srl     e
    srl     e
    djnz    vpeek_mode6_loop_3
    ex      af,af
    dec     a
    jr      nz,vpeek_mode6_loop_2
    pop     hl      ;screen address
    pop     de      ;Buffer
    ld      a,c
    ld      (de),a
    inc     de
    ld      bc,128
    add     hl,bc
    pop     bc
    djnz    vpeek_mode6_row_loop
    call    l_tms9918_enable_interrupts
    jp      __tms9918_vpeek_continue

ENDIF