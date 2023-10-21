;
; Extremely putc implementation for low resolution graphics
; and small memory sizes
;
; Sept 2018 - Stefano
;
; Much More Generic version
; Uses clg, plot and unplot
;
;
; $Id: w_putc4x6.asm $
;

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics


        PUBLIC  putc4x6
        PUBLIC  _putc4x6

        EXTERN  swapgfxbk
        EXTERN  __graphics_end

        EXTERN  plot
        EXTERN  unplot
        EXTERN  clg
        EXTERN  l_graphics_cmp
        INCLUDE "graphics/grafix.inc"


putc4x6:
_putc4x6:
        ld      hl, 2
        add     hl, sp

        ld      a, (hl)

        cp      12                      ; cls ?
        jr      nz, nocls
        ld      hl, 0
        ld      (x_4x6), hl
        ld      (y_4x6), hl

        jp      clg
nocls:

        cp      10
        jp      z, do_nl
        cp      13
        jp      z, do_nl

        cp      8
        jr      nz, nobs
        ld      hl, (x_4x6)
        ld      de, 4
        sbc     hl, de
        jr      c, nobs1
        ld      (x_4x6), hl
nobs1:
        ld      a, ' '
        call    nolower
        ld      hl, (x_4x6)
        ld      de, 4
        sbc     hl, de
        ld      (x_4x6), hl
        ret

nobs:
        cp      97
        jr      c, nolower
        sub     32                      ; uppercase only
nolower:
        sub     32

        ld      (chr), a

        push    ix
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        ld      a, (chr)
        rra

        ld      e, a
        add     a
        add     a
        add     e                       ; a=a*5 !

        ld      d, 0
        ld      e, a
        ld      hl, font4x5
        add     hl, de

        ld      b, 5
rowloop:
        push    bc
        push    hl
        ld      a, (chr)
        rra                             ; even odd ?
        ld      a, (hl)
        jr      nc, iseven
        rla
        rla
        rla
        rla
iseven:
        ld      b, 4
        ld      c, a

        ld      de, (x_4x6)
colloop:
        rl      c                       ; cy = pixel status
        push    bc
        push    de
        ld      de, (y_4x6)
        push    de

        jr      nc, noplot
        call    plot
        jr      nores
noplot:
        call    unplot
nores:
        pop     de
        pop     de
        inc     de

        pop     bc
        djnz    colloop

        ld      hl, (y_4x6)
        inc     hl
        ld      (y_4x6), hl

        pop     hl
        inc     hl
        pop     bc
        djnz    rowloop

        ld      b, 4
        ld      de, (x_4x6)
lrloop:
        push    bc
        push    de
        ld      de, (y_4x6)
        push    de
        call    unplot
        pop     de
        pop     de
    ;ld    a,e            ; keep new x position
        inc     de
        pop     bc
        djnz    lrloop

        push    hl
        ld      hl, maxx
        call    l_graphics_cmp
        pop     hl
        call    nc, do_nl

        ld      (x_4x6), de             ; update x position

        push    hl
        ld      hl, (y_4x6)
        ld      de, 4                   ; 4+1 (CY is set)
        sbc     hl, de
        ld      (y_4x6), hl
        pop     hl

    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
        pop     ix
        ret
    ENDIF
do_nl:
        push    hl
        ld      hl, (y_4x6)
        ld      de, 6
        add     hl, de
        ld      (y_4x6), hl
        ex      de, hl
        ld      hl, 0
        ld      (x_4x6), hl             ; update x position
        pop     hl
        ret


        SECTION bss_graphics

        PUBLIC  x_4x6
        PUBLIC  _x_4x6
        PUBLIC  y_4x6
        PUBLIC  _y_4x6

x_4x6:
_x_4x6:
        defw    0

y_4x6:
_y_4x6:
        defw    0

chr:
        defb    0



        SECTION rodata_graphics

; 4x5 font (it will be 4x6 because the driver adds a bottom blank row)
font4x5:
        defb    0x04, 0x04, 0x04, 0x00, 0x04
        defb    0xAA, 0xAE, 0x0A, 0x0E, 0x0A
        defb    0x48, 0xC2, 0xE4, 0x68, 0x42
        defb    0xC4, 0xC8, 0x60, 0xC0, 0xE0
        defb    0x28, 0x44, 0x44, 0x44, 0x28
        defb    0xA0, 0x44, 0xEE, 0x4e, 0xA0
        defb    0x00, 0x00, 0x0E, 0x40, 0x80
        defb    0x00, 0x02, 0x04, 0x08, 0x40
        defb    0x44, 0xAC, 0xE4, 0xA4, 0x44
        defb    0xCC, 0x22, 0x64, 0x82, 0xEC
        defb    0xAE, 0xA8, 0xEC, 0x22, 0x2C
        defb    0x4E, 0x82, 0xC2, 0xA2, 0x42
        defb    0x44, 0xAA, 0x46, 0xA2, 0x42
        defb    0x00, 0x44, 0x00, 0x44, 0x08
        defb    0x20, 0x4E, 0x80, 0x4E, 0x20
        defb    0x8C, 0x42, 0x24, 0x40, 0x84
        defb    0xC4, 0x2A, 0x6E, 0xAA, 0x4A
        defb    0xC4, 0xAA, 0xC8, 0xAA, 0xC4
        defb    0xCE, 0xA8, 0xAC, 0xA8, 0xCE
        defb    0xE6, 0x88, 0xCA, 0x8A, 0x86
        defb    0xAE, 0xA4, 0xE4, 0xA4, 0xAE
        defb    0x6A, 0x2C, 0x2C, 0xAC, 0x4A
        defb    0x8A, 0x8E, 0x8E, 0x8E, 0xEE
        defb    0xA4, 0xEA, 0xEA, 0xEA, 0xA4
        defb    0xC4, 0xAA, 0xCA, 0x8E, 0x86
        defb    0xC6, 0xA8, 0xC4, 0xC2, 0xAC
        defb    0xEA, 0x4A, 0x4A, 0x4A, 0x4E
        defb    0xAE, 0xAE, 0xAE, 0x4E, 0x44
        defb    0xAA, 0xAA, 0x44, 0xA4, 0xA4
        defb    0xE6, 0x24, 0x44, 0x84, 0xE6
        defb    0x0C, 0x84, 0x44, 0x24, 0x0C
        defb    0x40, 0xA0, 0x00, 0x00, 0x0E
        defb    0x40, 0x26, 0x0A, 0x0A, 0x06

  ENDIF
