

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"


IFDEF V9938

PUBLIC  __v9938_mode8_vpeek

EXTERN  __v9938_mode8_xypos
EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __tms9918_vpeek_continue
EXTERN  __tms9918_8bpp_attr
EXTERN  SETRD

__v9938_mode8_vpeek:
    ; b = x, c = y
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    push    hl                ;save buffer
    ex      de,hl
    call    __v9938_mode8_xypos
    call    l_tms9918_disable_interrupts
    ld      b,8
vpeek_mode8_row_loop:
    push    bc
    push    de      ;Save buffer

    call    SETRD

    ld      a,(__tms9918_8bpp_attr+1)       ;current paper
    ld      e,a
    ld      d,@10000000
    ld      c,0     ;Resultant byte

    ld      b,8     ;4 bytes to do
vpeek_mode8_loop:
IF VDP_DATAIN < 0
    ld      a,(-VDP_DATAIN)
ELIF VDP_DATAIN < 256
    in      a,(VDP_DATAIN)
ELSE
    ;; TODO
ENDIF
    cp      e
    jr      z,bit_not_set
    and     a
    jr      z,bit_not_set
    ld      a,c
    or      d
    ld      c,a
bit_not_set:
    srl     d
    djnz    vpeek_mode8_loop
    pop     de
    ld      a,c
    ld      (de),a
    inc     de
    ld      bc,256
    add     hl,bc
    pop     bc
    djnz    vpeek_mode8_row_loop 
    call    l_tms9918_enable_interrupts
    jp      __tms9918_vpeek_continue

ENDIF