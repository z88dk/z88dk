

    SECTION code_video_vdp

    INCLUDE "classic/video/tms9918/vdp.inc"


IFDEF   V9938

    PUBLIC  __v9938_mode7_vpeek

    EXTERN  __v9938_mode7_xypos
    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts
    EXTERN  __tms9918_vpeek_continue
    EXTERN  __tms9918_attribute
    EXTERN  SETRD


__v9938_mode7_vpeek:
    ; b = x, c = y
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;save buffer
    ex      de, hl
    call    __v9938_mode7_xypos

    call    l_tms9918_disable_interrupts

    ld      b, 8
vpeek_mode7_row_loop:
    push    bc
    push    de                          ;Save buffer
    push    hl                          ;We don't need hl for now, so we can use that reg for something useful
    call    SETRD

    ld      d, @10000000
    ld      c, 0                        ;Resultant byte

    ld      a, 4                        ;We need to do this loop twice
vpeek_mode7_loop_2:
    ex      af, af
  IF    VDP_DATAIN<0
    ld      a, (-VDP_DATAIN)
  ELIF  VDP_DATAIN<256
    in      a, (VDP_DATAIN)
  ELSE
    ;; TODO
  ENDIF
    ld      h,a
    ld      a, (__tms9918_attribute)
    rlca
    rlca
    rlca
    rlca
    and     @11110000       ;paper
    ld      l,a

    ld      a,h
    and     @11110000
    cp      l
    jr      z,not_set
    ld      a, c
    or      d
    ld      c, a
not_set:
    srl     d

    ld      a, (__tms9918_attribute)
    and     @00001111
    ld      l,a

    ld      a, h
    and     @00001111
    cp      l
    jr      z,not_set2
    ld      a, c
    or      d
    ld      c, a
not_set2:
    srl     d
    ex      af, af
    dec     a
    jr      nz, vpeek_mode7_loop_2

    ; We have the pixel data for this row in c
    pop     hl                          ;screen address
    pop     de                          ;Buffer
    ld      a, c
    ld      (de), a
    inc     de
    ld      bc, 256
    add     hl, bc
    pop     bc
    djnz    vpeek_mode7_row_loop
    call    l_tms9918_enable_interrupts
    jp      __tms9918_vpeek_continue

ENDIF
