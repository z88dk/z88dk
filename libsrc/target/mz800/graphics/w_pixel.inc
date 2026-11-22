;
; Sharp MZ-800 graphics: plot, unplot, xorplot and point.  Define one of NEEDplot, NEEDunplot, NEEDxor, NEEDpoint first.
;
; Entry: hl = x (0..319), de = y (0..199); nothing is drawn outside the screen.
; The pixel is at $8000 + y * 40 + x / 8, bit (x & 7), in each plane.  The video RAM is paged in only for the access, with interrupts off (this code is in code_driver, below $8000).
; plot and unplot use the PSET write format ($CC = $C0 | pen): the byte written (the pixel's mask) sets that pixel to the pen, with no read.  xorplot uses the XOR format on the
; planes where ink and paper differ, which flips the pixel between them.  point reads each plane through the read format ($CD).
; Exit: point returns the pen (0..3) in a, nz if not 0.

    EXTERN  __gfx_coords
    EXTERN  __mz800_con_ink
    EXTERN  __mz800_con_paper
    EXTERN  l_push_di
    EXTERN  l_pop_ei

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
    ld      a, 1
    jr      z, mask_done
mask_loop:
    add     a, a
    djnz    mask_loop
mask_done:
    ld      c, a                        ;c = the mask of the pixel
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l                           ;hl = the byte of the line
    push    hl
    ex      de, hl                      ;hl = y
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ;y * 8
    ld      d, h
    ld      e, l
    add     hl, hl
    add     hl, hl                      ;y * 32
    add     hl, de                      ;y * 40
    pop     de
    add     hl, de
    ld      de, $8000
    add     hl, de                      ;the byte in the video RAM
IF  NEEDplot
    ld      a, (__mz800_con_ink)
    or      $C0
ENDIF
IF  NEEDunplot
    ld      a, (__mz800_con_paper)
    or      $C0
ENDIF
IF  NEEDxor
    ld      a, (__mz800_con_ink)
    ld      b, a
    ld      a, (__mz800_con_paper)
    xor     b
    or      $20                         ;the XOR format on the planes where they differ
ENDIF
IF  NEEDplot|NEEDunplot|NEEDxor
    ld      d, a                        ;d = the write format
ENDIF
    call    l_push_di                   ;(interrupts off, their state kept)
    in      a, ($e0)                    ;the video RAM in
IF  NEEDplot|NEEDunplot|NEEDxor
    ld      a, d
    out     ($cc), a
    ld      a, c
    ld      (hl), a
ENDIF
IF  NEEDpoint
    ld      a, 1
    out     ($cd), a                    ;read plane I
    ld      a, (hl)
    and     c
    ld      d, 0
    jr      z, p1
    inc     d
p1: ld      a, 2
    out     ($cd), a                    ;read plane II
    ld      a, (hl)
    and     c
    jr      z, p2
    inc     d
    inc     d
p2:
ENDIF
    in      a, ($e1)                    ;the video RAM out
    call    l_pop_ei
IF  NEEDpoint
    ld      a, d
    and     a
ENDIF
    pop     bc                          ;Restore callers
    ret
