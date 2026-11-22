;
; Samsung SPC-1500 graphics: plot, unplot, xorplot and point.  Define one of
; NEEDplot, NEEDunplot, NEEDxor, NEEDpoint first.
;
; Entry: hl = x (0..319), de = y (0..199); nothing is drawn outside the screen.
; The pixel is at the I/O address $4000 + (y & 7) * $800 + (y / 8) * 40 + x / 8
; in the blue plane, bit 7 - (x & 7), and the same, $4000 on, in the red and the
; green plane (see
; spc1500_gfx.asm).  plot sets the pixel to the ink pen: in each plane the bit
; is set or cleared by the pen's bit for that plane (blue 1, red 2, green 4);
; unplot does the same with
; the paper pen; xorplot flips the pixel in the planes where ink and paper
; differ, which turns it from one pen to the other; point reads the three
; planes.
; Exit: point returns the pen (0..7) in a, nz if not 0.

    EXTERN  __gfx_coords
    EXTERN  __spc1500_con_ink
    EXTERN  __spc1500_con_paper

    ld      a, d                        ;y 0..199 (the high byte must be 0: a negative y is off the screen too)
    or      a
    ret     nz
    ld      a, e
    cp      200
    ret     nc
    ld      a, h                        ;x 0..319
    or      a
    jr      z, x_ok
    dec     a
    ret     nz
    ld      a, l
    cp      64
    ret     nc
x_ok:
    ld      (__gfx_coords), hl          ;x
    ld      (__gfx_coords+2), de        ;y
    push    bc
    ld      a, l
    and     7
    ld      b, a
    ld      a, $80
    jr      z, mask_done
mask_loop:
    rrca
    djnz    mask_loop
mask_done:
    ex      af, af'                     ;(a' = the pixel's mask)
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l                           ;hl = the byte's column (0..39)
    ex      de, hl                      ;hl = y, de = the column
    ld      a, l
    and     7
    add     a, a
    add     a, a
    add     a, a                        ;(y & 7) * 8: the high byte of the line's offset
    ld      c, a
    ld      a, l
    rrca
    rrca
    rrca
    and     $1f
    ld      l, a
    ld      h, 0                        ;hl = y / 8, the character row
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ;* 8
    ld      b, h
    push    bc                          ;[line, row * 8 high]  (c is the line)
    ld      b, h
    ld      c, l
    add     hl, hl
    add     hl, hl                      ;* 32
    add     hl, bc                      ;* 40
    add     hl, de                      ;+ the column
    pop     bc
    ld      a, c
    add     a, h
    add     a, $40
    ld      b, a
    ld      c, l                        ;bc = the blue plane's I/O address of the byte
    ex      af, af'
    ld      l, a                        ;l = the pixel's mask
IF  NEEDplot
    ld      a, (__spc1500_con_ink)
ENDIF
IF  NEEDunplot
    ld      a, (__spc1500_con_paper)
ENDIF
IF  NEEDxor
    ld      a, (__spc1500_con_ink)
    ld      d, a
    ld      a, (__spc1500_con_paper)
    xor     d
ENDIF
IF  NEEDplot|NEEDunplot|NEEDxor
    ld      d, a                        ;d = the pen's bits, one a plane
ENDIF
IF  NEEDpoint
    ld      d, 0
ENDIF
    ld      e, 3                        ;the planes
plane:
IF  NEEDplot|NEEDunplot
    in      a, (c)
    ld      h, a                        ;the byte
    ld      a, l
    srl     d                           ;the pen's bit for this plane
    jr      nc, clear
    or      h                           ;the pixel set
    jr      store
clear:
    cpl
    and     h                           ;the pixel cleared
store:
    out     (c), a
ENDIF
IF  NEEDxor
    srl     d
    jr      nc, skip
    in      a, (c)
    xor     l                           ;the pixel flipped
    out     (c), a
skip:
ENDIF
IF  NEEDpoint
    in      a, (c)
    and     l                           ;the pixel's bit
    add     a, $ff                      ;carry if it is set
    rr      d                           ;(the planes' bits end up in d's top three, blue lowest)
ENDIF
    ld      a, b
    add     a, $40                      ;the next plane
    ld      b, a
    dec     e
    jr      nz, plane
IF  NEEDpoint
    ld      a, d
    rrca
    rrca
    rrca
    rrca
    rrca
    and     7
ENDIF
    pop     bc                          ;Restore callers
IF  NEEDpoint
    and     a
ENDIF
    ret
