;
; Sharp MZ-2500 graphics: the code of plot, unplot, xorplot and point
;
; Define one of NEEDplot, NEEDunplot, NEEDxor, NEEDpoint before including.
;
; Entry: hl = x (0..319), de = y (0..199); nothing is drawn outside the screen.
; The byte of the pixel is at y * 40 + x / 8 in each plane and the pixel is bit (x & 7).
;
; plot and unplot use the video RAM's read-modify-write page ($30, which writes all four planes at once): with the CG registers in PSET mode
; (register 5 = $4F: all four planes) and the colour in registers 0-3 (a plane's byte is $FF if that bit of the colour is set), a byte written to the
; page is a mask of pixels to set to that colour.  point reads the page, which loads the four plane bytes into latches that ports $BC-$BF return.
; The page is mapped in the graphics window (__MZ2500_GFX_WINDOW, window 2 by default) and that window is put back afterwards.
; xorplot has no read-modify-write mode, so it maps each plane page ($20, $22, $24, $26: the blue, red, green and intensity planes of screen A) in
; turn into the graphics window.
; Exit: point returns the pixel value (0..15) in a, nz if it is not 0.

    EXTERN  __gfx_coords
    EXTERN  __mz2500_gfx_ink
    EXTERN  __mz2500_gfx_paper
    EXTERN  __mz2500_cg_setcolour
    EXTERN  __mz2500_mask_table
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __MZ2500_GFX_WINDOW
    EXTERN  __MZ2500_GFX_BASE
    EXTERN  __MZ2500_GFX_PAGE

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
    ld      c, a                        ;c = the bit
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
    ld      de, __MZ2500_GFX_BASE
    add     hl, de                      ;the byte in the window
    ld      b, 0
    ld      de, __mz2500_mask_table
    ex      de, hl
    add     hl, bc
    ld      c, (hl)                     ;c = the mask of the pixel
    ex      de, hl                      ;hl = the byte again
    ld      e, c                        ;e = the mask
IF  NEEDplot|NEEDunplot|NEEDxor
  IF    NEEDplot|NEEDxor
    ld      a, (__mz2500_gfx_ink)
    xor     15
  ELSE
    ld      a, (__mz2500_gfx_paper)
  ENDIF
ENDIF
IF  NEEDplot|NEEDunplot
    call    __mz2500_cg_setcolour       ;(registers 0-5 for this colour; changes only af)
ENDIF
IF  NEEDxor
    ld      c, a                        ;c = the colour
    ld      a, e
    cpl
    ld      d, a                        ;d = the other pixels of the byte
ENDIF
IF  NEEDpoint
    ld      a, 7                        ;register 7 = 0: read the planes without a comparison
    out     ($bc), a
    xor     a
    out     ($bd), a
    ld      c, a                        ;c collects the colour
ENDIF
    call    l_push_di                   ;(interrupts off, their state kept)
    ld      a, __MZ2500_GFX_WINDOW
    out     ($b4), a
    in      a, ($b5)
    push    af                          ;the window as it is
IF  NEEDplot|NEEDunplot|NEEDpoint
    ld      a, __MZ2500_GFX_WINDOW
    out     ($b4), a
    ld      a, $30
    out     ($b5), a
  IF    NEEDpoint
    ld      a, (hl)                     ;the read loads the latches
    in      a, ($bc)
    and     e
    add     a, 255                      ;carry if the pixel is set
    rr      c
    in      a, ($bd)
    and     e
    add     a, 255
    rr      c
    in      a, ($be)
    and     e
    add     a, 255
    rr      c
    in      a, ($bf)
    and     e
    add     a, 255
    rr      c
  ELSE
    ld      (hl), e                     ;PSET: the byte is the mask of the pixels to set
  ENDIF
ENDIF
IF  NEEDxor
    ld      b, __MZ2500_GFX_PAGE
plane_loop:
    ld      a, __MZ2500_GFX_WINDOW
    out     ($b4), a
    ld      a, b
    out     ($b5), a
    rrc     c
    jr      nc, next_plane
    ld      a, (hl)
    xor     e
    ld      (hl), a
next_plane:
    inc     b
    inc     b
    ld      a, b
    cp      __MZ2500_GFX_PAGE + 8
    jr      nz, plane_loop
ENDIF
    ld      a, __MZ2500_GFX_WINDOW
    out     ($b4), a
    pop     af
    out     ($b5), a                    ;the window put back
    call    l_pop_ei
IF  NEEDpoint
    ld      a, c                        ;the planes are in the top nibble, plane 0 in bit 4
    rrca
    rrca
    rrca
    rrca
    and     15
ENDIF
    pop     bc                          ;Restore callers
    ret
