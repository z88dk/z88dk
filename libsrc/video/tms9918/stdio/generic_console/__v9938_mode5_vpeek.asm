

SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"


IFDEF V9938

PUBLIC  __v9938_mode5_vpeek

EXTERN  __v9938_mode5_xypos
EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __tms9918_vpeek_continue
EXTERN  __tms9918_attribute
EXTERN  SETRD

__v9938_mode5_vpeek:
    ; b = x, c = y
    ld      hl,-8
    add     hl,sp
    ld      sp,hl
    push    hl                ;save buffer
    ex      de,hl
    call    __v9938_mode5_xypos
    call    l_tms9918_disable_interrupts
    ld      b,8
vpeek_mode5_row_loop:
    push    bc
    push    de      ;Save buffer

    call    SETRD

    ld      d,@10000000
    ld      c,0     ;Resultant byte
    ld      a,4     ;4 bytes to do
vpeek_mode5_loop:
    ex      af,af
    ld      a,(__tms9918_attribute)       ;current paper colour
    and     15
    ld      e,a
IF VDP_DATAIN < 0
    ld      a,(-VDP_DATAIN)
ELIF VDP_DATAIN < 256
    in      a,(VDP_DATAIN)
ELSE
    ;; TODO
ENDIF
    ld      b,a
    and     @11110000
    jr      z,first_nibble_not_set      ; Pen 0
    cp      e
    jr      z,first_nibble_not_set      ; It's the same as the current background 
    ld      a,c
    or      d
    ld      c,a
first_nibble_not_set:
    srl     d

    ld      a,b         ;Get the byte back in
    and     @00001111
    jr      z,second_nibble_not_set     ;Pen 0
    ; Rotate background colour
    srl     e
    srl     e
    srl     e
    srl     e
    cp      e
    jr      z,second_nibble_not_set     ;It's the same as the current background
    ld      a,c
    or      d
    ld      c,a
second_nibble_not_set:
    srl     d
    ex      af,af
    dec     a
    jr      nz,vpeek_mode5_loop
    pop     de
    ld      a,c
    ld      (de),a
    inc     de
    ld      bc,128
    add     hl,bc
    pop     bc
    djnz    vpeek_mode5_row_loop 
    call    l_tms9918_enable_interrupts
    jp      __tms9918_vpeek_continue

ENDIF