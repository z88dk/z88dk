;
;	Sharp MZ-2500 graphics: fill an area
;
;	void fill(int x, int y);
;
;	Fills the 4-connected area of colour 0 pixels round (x,y) with the ink colour, up to any pixel that is not colour 0 and the edges of the screen, like the
;	generic fill (which this replaces: it recurses a pixel at a time).  Nothing is done if (x,y) is off the screen or is not colour 0, or if the ink is 0.
;
;	A scanline fill: a seed is a pixel; the run of colour 0 pixels in its row is found, filled eight pixels at a time with the read-modify-write page (see
;	w_pixel.inc), and the rows above and below it are searched for runs of colour 0 pixels under it, whose first pixels are the new seeds.  Which pixels of a byte
;	are colour 0 comes from the latches that reading the page loads.  The seeds are kept in a table of FL_SEEDS: if it fills, seeds are dropped, and the
;	area is not completely filled (only an area with a great many separate openings in a row needs more).  Interrupts are off, and window 2 is the page, only
;	while a seed is dealt with.
;

    SECTION code_clib

    PUBLIC  fill
    PUBLIC  _fill
    PUBLIC  ___fill
    EXTERN  __mz2500_gfx_ink
    EXTERN  __mz2500_cg_setcolour
    EXTERN  __mz2500_mask_table
    EXTERN  l_push_di
    EXTERN  l_pop_ei

    defc    FL_SEEDS = 200

fill:
_fill:
___fill:
    pop     bc
    pop     de                          ; y
    pop     hl                          ; x
    push    hl
    push    de
    push    bc
    ld      a, d                        ; y 0..199
    or      a
    ret     nz
    ld      a, e
    cp      200
    ret     nc
    ld      a, h                        ; x 0..319
    or      a
    jr      z, x_ok
    dec     a
    ret     nz
    ld      a, l
    cp      64
    ret     nc
x_ok:
    ld      a, (__mz2500_gfx_ink)
    xor     15
    ret     z                           ; (filling colour 0 with colour 0)
    call    __mz2500_cg_setcolour       ; PSET with the ink (leaves hl and de)
    ld      a, 7                        ; register 7 = 0: reads load the latches without a comparison
    out     ($bc), a
    xor     a
    out     ($bd), a
    push    hl
    ld      hl, fl_stack
    ld      (fl_sp), hl
    pop     hl
    call    fl_push                     ; the first seed: hl = x, e = y
fl_loop:
    call    fl_pop
    ret     c                           ; no more seeds
    call    fl_process
    jr      fl_loop

; ---- the seeds -----------------------------------------------------------------------------------------------------------------------------------

; hl = x, e = y.  A full table drops the seed.  Uses af, de, hl
fl_push:
    ld      (fl_tx), hl
    ld      a, e
    ld      (fl_ty), a
    ld      hl, (fl_sp)
    ld      de, fl_stack_end
    or      a
    sbc     hl, de
    ret     nc
    add     hl, de
    ld      de, (fl_tx)
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    ld      a, (fl_ty)
    ld      (hl), a
    inc     hl
    ld      (fl_sp), hl
    ret

; exit: hl = x, e = y, carry clear; or carry set if there are no seeds.  Uses af, de, hl
fl_pop:
    ld      hl, (fl_sp)
    ld      de, fl_stack
    or      a
    sbc     hl, de
    jr      nz, have_seed
    scf
    ret
have_seed:
    add     hl, de
    dec     hl
    ld      a, (hl)
    ld      (fl_ty), a
    dec     hl
    ld      d, (hl)
    dec     hl
    ld      e, (hl)
    ld      (fl_sp), hl
    ex      de, hl
    ld      a, (fl_ty)
    ld      e, a
    or      a
    ret

; ---- a seed ----------------------------------------------------------------------------------------------------------------------------------------

; hl = x, e = y
fl_process:
    ld      (fl_x), hl
    ld      a, e
    ld      (fl_y), a
    call    l_push_di
    ld      a, 2
    out     ($b4), a
    in      a, ($b5)
    push    af                          ; window 2 as it is
    ld      a, 2
    out     ($b4), a
    ld      a, $30
    out     ($b5), a                    ; the read-modify-write page
    call    fl_body
    ld      a, 2
    out     ($b4), a
    pop     af
    out     ($b5), a
    call    l_pop_ei
    ret

fl_body:
    ld      a, (fl_y)
    call    fl_rowaddr
    ld      (fl_row), hl
    ld      hl, (fl_x)                  ; the seed's byte
    ld      a, l
    and     7
    ld      c, a                        ; c = its bit
    call    fl_hl_div8
    ld      e, l
    ld      d, 0
    ld      hl, (fl_row)
    add     hl, de
    call    fl_empty                    ; a = the pixels of colour 0 in the byte
    ld      e, a
    call    fl_bitmask                  ; a = 1 << c
    and     e
    ret     z                           ; the seed is not colour 0
    call    fl_findleft
    call    fl_findright
    call    fl_setup_span
    call    fl_writespan
    ld      a, (fl_y)
    or      a
    jr      z, no_up
    dec     a
    ld      (fl_y2), a
    call    fl_scanrow
no_up:
    ld      a, (fl_y)
    cp      199
    ret     z
    inc     a
    ld      (fl_y2), a
    jp      fl_scanrow

; hl = hl / 8 (a byte column)
fl_hl_div8:
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    ret

; a = y: hl = the address of the row in window 2.  Uses de
fl_rowaddr:
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl                      ; y * 8
    ld      d, h
    ld      e, l
    add     hl, hl
    add     hl, hl                      ; y * 32
    add     hl, de
    ld      de, $4000
    add     hl, de
    ret

; hl = the address of a byte of the page.  Exit: a = the pixels of that byte that are colour 0 (a bit each, bit 0 the leftmost).  Uses d
fl_empty:
    ld      a, (hl)                     ; (the read loads the latches)
    in      a, ($bc)
    ld      d, a
    in      a, ($bd)
    or      d
    ld      d, a
    in      a, ($be)
    or      d
    ld      d, a
    in      a, ($bf)
    or      d
    cpl
    ret

; c = a bit 0-7: a = 1 << c
fl_bitmask:
    push    hl
    ld      hl, __mz2500_mask_table
    ld      a, c
    add     a, l
    ld      l, a
    jr      nc, bm_ok
    inc     h
bm_ok:
    ld      a, (hl)
    pop     hl
    ret

; ---- the run of the seed's row ---------------------------------------------------------------------------------------------------------------------

; The first pixel (fl_xl) of the run of colour 0 pixels that holds the seed.  b = the byte column, c = the bit, hl = the byte, e = its colour 0 pixels shifted
; so that the bit we are at is bit 7
fl_findleft:
    ld      hl, (fl_x)
    ld      a, l
    and     7
    ld      c, a
    call    fl_hl_div8
    ld      b, l
    ld      hl, (fl_row)
    ld      e, b
    ld      d, 0
    add     hl, de
    call    fl_empty
    ld      e, a
    ld      a, 7
    sub     c
    jr      z, fl_l_loop
    ld      d, a
    ld      a, e
fl_l_sh:
    add     a, a
    dec     d
    jr      nz, fl_l_sh
    ld      e, a
fl_l_loop:
    ld      a, c
    or      a
    jr      z, fl_l_edge
    sla     e
    jp      p, fl_l_found               ; the pixel to the left is not colour 0
    dec     c
    jr      fl_l_loop
fl_l_edge:                              ; at the left of the byte
    ld      a, b
    or      a
    jr      z, fl_l_zero
fl_l_prev:
    dec     b
    dec     hl
    call    fl_empty
    cp      $ff
    jr      nz, fl_l_part
    ld      a, b
    or      a
    jr      z, fl_l_zero                ; all of it, up to the edge of the screen
    jr      fl_l_prev
fl_l_part:
    ld      e, a
    bit     7, e
    jr      z, fl_l_next                ; its last pixel is not colour 0: the run starts at the next byte
    ld      c, 7
    jr      fl_l_loop
fl_l_next:
    inc     b
    ld      c, 0
    jr      fl_l_found
fl_l_zero:
    ld      b, 0
    ld      c, 0
fl_l_found:
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      e, c
    ld      d, 0
    add     hl, de
    ld      (fl_xl), hl
    ret

; The last pixel (fl_xr) of the run.  e = the byte's pixels shifted so that the bit we are at is bit 0
fl_findright:
    ld      hl, (fl_x)
    ld      a, l
    and     7
    ld      c, a
    call    fl_hl_div8
    ld      b, l
    ld      hl, (fl_row)
    ld      e, b
    ld      d, 0
    add     hl, de
    call    fl_empty
    ld      e, a
    ld      a, c
    or      a
    jr      z, fl_r_loop
    ld      d, a
    ld      a, e
fl_r_sh:
    srl     a
    dec     d
    jr      nz, fl_r_sh
    ld      e, a
fl_r_loop:
    ld      a, c
    cp      7
    jr      z, fl_r_edge
    srl     e
    bit     0, e
    jr      z, fl_r_found               ; the pixel to the right is not colour 0
    inc     c
    jr      fl_r_loop
fl_r_edge:                              ; at the right of the byte
    ld      a, b
    cp      39
    jr      z, fl_r_last
fl_r_next:
    inc     b
    inc     hl
    call    fl_empty
    cp      $ff
    jr      nz, fl_r_part
    ld      a, b
    cp      39
    jr      z, fl_r_last
    jr      fl_r_next
fl_r_part:
    ld      e, a
    bit     0, e
    jr      z, fl_r_prev                ; its first pixel is not colour 0: the run ends in the byte before
    ld      c, 0
    jr      fl_r_loop
fl_r_prev:
    dec     b
    ld      c, 7
    jr      fl_r_found
fl_r_last:
    ld      b, 39
    ld      c, 7
fl_r_found:
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      e, c
    ld      d, 0
    add     hl, de
    ld      (fl_xr), hl
    ret

; The bytes of the run, and the masks of its pixels in its first and last byte
fl_setup_span:
    ld      hl, (fl_xl)
    ld      a, l
    and     7
    ld      e, a
    ld      d, 0
    ld      hl, fl_lo_table
    add     hl, de
    ld      a, (hl)
    ld      (fl_ml), a
    ld      hl, (fl_xl)
    call    fl_hl_div8
    ld      a, l
    ld      (fl_xlb), a
    ld      hl, (fl_xr)
    ld      a, l
    and     7
    ld      e, a
    ld      d, 0
    ld      hl, fl_hi_table
    add     hl, de
    ld      a, (hl)
    ld      (fl_mh), a
    ld      hl, (fl_xr)
    call    fl_hl_div8
    ld      a, l
    ld      (fl_xrb), a
    ret

; b = a byte column of the run: a = the mask of the run's pixels in it.  Uses d
fl_spanmask:
    ld      a, (fl_xlb)
    cp      b
    ld      a, $ff
    jr      nz, sm_first
    ld      a, (fl_ml)
sm_first:
    ld      d, a
    ld      a, (fl_xrb)
    cp      b
    jr      nz, sm_last
    ld      a, (fl_mh)
    and     d
    ret
sm_last:
    ld      a, d
    ret

; PSET the run: the byte is the mask of the pixels to give the ink colour
fl_writespan:
    ld      hl, (fl_row)
    ld      a, (fl_xlb)
    ld      b, a
    ld      e, a
    ld      d, 0
    add     hl, de
fl_w_loop:
    call    fl_spanmask
    ld      (hl), a
    inc     hl
    ld      a, (fl_xrb)
    cp      b
    ret     z
    inc     b
    jr      fl_w_loop

; ---- the rows above and below ------------------------------------------------------------------------------------------------------------------

; fl_y2 = a row next to the run: a seed for each run of colour 0 pixels in it that has pixels under (or over) the run, at its first pixel there
fl_scanrow:
    ld      a, (fl_y2)
    call    fl_rowaddr
    ld      a, (fl_xlb)
    ld      b, a
    ld      e, a
    ld      d, 0
    add     hl, de
    xor     a
    ld      (fl_carry), a
fl_s_loop:
    call    fl_empty
    ld      c, a
    call    fl_spanmask
    and     c
    ld      c, a                        ; c = the pixels of colour 0 within the run
    add     a, a
    ld      d, a
    ld      a, (fl_carry)
    or      d
    cpl
    and     c
    ld      d, a                        ; d = those whose left neighbour is not: where a run starts
    ld      a, c
    rlca
    and     1
    ld      (fl_carry), a
    ld      e, 0
fl_s_bits:
    ld      a, d
    or      a
    jr      z, fl_s_next
    srl     d
    jr      nc, fl_s_nb
    push    hl
    push    de
    push    bc
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      d, 0
    add     hl, de                      ; x = the column * 8 + the bit
    ld      a, (fl_y2)
    ld      e, a
    call    fl_push
    pop     bc
    pop     de
    pop     hl
fl_s_nb:
    inc     e
    jr      fl_s_bits
fl_s_next:
    inc     hl
    ld      a, (fl_xrb)
    cp      b
    ret     z
    inc     b
    jr      fl_s_loop

    SECTION rodata_clib
fl_lo_table:
    defb    $ff, $fe, $fc, $f8, $f0, $e0, $c0, $80      ; the pixels from this one to the right edge of the byte
fl_hi_table:
    defb    $01, $03, $07, $0f, $1f, $3f, $7f, $ff      ; the pixels from the left edge to this one

    SECTION bss_clib
fl_sp:      defw    0
fl_tx:      defw    0
fl_ty:      defb    0
fl_x:       defw    0
fl_y:       defb    0
fl_y2:      defb    0
fl_row:     defw    0
fl_xl:      defw    0
fl_xr:      defw    0
fl_xlb:     defb    0
fl_xrb:     defb    0
fl_ml:      defb    0
fl_mh:      defb    0
fl_carry:   defb    0
fl_stack:   defs    FL_SEEDS * 3
fl_stack_end:
