; w_line_r for the all-RAM console: every draw, undraw, xordraw (and the -to and -r forms) ends here with the starting point in __gfx_coords, ix = the pixel
; routine and hl, de = the relative end.  A line wholly on the screen, drawn with plot, unplot or xor, is one command to the sub program (Line in
; ../sub/sub.s.in), which steps it itself; the starting pixel is not drawn here (the callers have done that).  Any other goes to the stock routine
; (w_liner_generic.asm), which leaves the clipping to the pixel routine.

    MODULE  fp1100_allram_w_liner
    SECTION code_clib

    PUBLIC  w_line_r
    EXTERN  w_line_generic
    EXTERN  w_plotpixel
    EXTERN  w_respixel
    EXTERN  w_xorpixel
    EXTERN  __gfx_coords
    EXTERN  __fp1100_attr
    EXTERN  fp1100_pixel_addr
    EXTERN  fp1100_sub_send

    INCLUDE "../sub/sub.inc"

w_line_r:
    ld      (ln_dx), hl
    ld      (ln_dy), de
    push    ix
    pop     bc
    ld      hl, w_plotpixel
    or      a
    sbc     hl, bc
    jr      nz, lr1
    ld      a, (__fp1100_attr)
    and     7                           ; plot: the ink
    jr      lr_go
lr1:
    ld      hl, w_respixel
    or      a
    sbc     hl, bc
    jr      nz, lr2
    ld      a, (__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    and     7                           ; unplot: the paper
    jr      lr_go
lr2:
    ld      hl, w_xorpixel
    or      a
    sbc     hl, bc
    jp      nz, generic
    ld      a, (__fp1100_attr)
    and     7
    or      8                           ; xor: the ink, flipped
lr_go:
    ld      (ln_mc), a
    ld      hl, (__gfx_coords)          ; both ends on the screen?
    call    chkx
    jp      nc, generic
    ld      de, (__gfx_coords + 2)
    call    chky
    jp      nc, generic
    ld      hl, (ln_dx)
    ld      de, (__gfx_coords)
    add     hl, de
    ld      (ln_x1), hl
    call    chkx
    jp      nc, generic
    ld      hl, (ln_dy)
    ld      de, (__gfx_coords + 2)
    add     hl, de
    ld      (ln_y1), hl
    ex      de, hl
    call    chky
    jp      nc, generic

    ld      c, 0                        ; flags: bit 0 x is the major axis, bit 1 x steps up, bit 2 y steps down
    ld      hl, (ln_dx)
    bit     7, h
    jr      nz, lr_nx
    set     1, c
    jr      lr_ax
lr_nx:
    call    negate
lr_ax:
    ld      (ln_adx), hl
    ld      hl, (ln_dy)
    bit     7, h
    jr      nz, lr_ny
    set     2, c
    jr      lr_ay
lr_ny:
    call    negate
lr_ay:
    ld      (ln_ady), hl
    ex      de, hl                      ; de = |dy|
    ld      hl, (ln_adx)
    ld      a, h
    or      l
    or      d
    or      e
    ret     z                           ; (no distance: nothing to draw)
    or      a
    sbc     hl, de                      ; |dx| - |dy|
    jr      c, lr_ymaj
    set     0, c
    ld      hl, (ln_adx)                ; x is the major axis
    ld      (ln_major), hl
    ld      (ln_minor), de
    jr      lr_go2
lr_ymaj:
    ld      (ln_major), de              ; y is the major axis
    ld      hl, (ln_adx)
    ld      (ln_minor), hl
lr_go2:
    ld      a, c
    ld      (ln_flags), a
    ld      hl, (__gfx_coords)
    ld      de, (__gfx_coords + 2)
    call    fp1100_pixel_addr           ; hl = the start byte, c = the mask
    ld      (ln_addr), hl
    ld      a, c
    ld      (ln_mask), a
    ld      a, SUB_LINE & $FF
    call    fp1100_sub_send
    ld      a, (ln_addr)
    call    fp1100_sub_send
    ld      a, (ln_addr + 1)
    call    fp1100_sub_send
    ld      a, (ln_mask)
    call    fp1100_sub_send
    ld      a, (ln_mc)
    call    fp1100_sub_send
    ld      a, (ln_flags)
    call    fp1100_sub_send
    ld      a, (ln_major)               ; the steps
    call    fp1100_sub_send
    ld      a, (ln_major + 1)
    call    fp1100_sub_send
    ld      a, (ln_minor)
    call    fp1100_sub_send
    ld      a, (ln_major)               ; the major, and the error starts at half of it
    call    fp1100_sub_send
    ld      a, (ln_major + 1)
    call    fp1100_sub_send
    ld      hl, (ln_major)
    srl     h
    rr      l
    ld      a, l
    call    fp1100_sub_send
    ld      a, h
    call    fp1100_sub_send
    ld      hl, (ln_x1)                 ; the end is the current point
    ld      (__gfx_coords), hl
    ld      hl, (ln_y1)
    ld      (__gfx_coords + 2), hl
    ret

generic:
    ld      hl, (ln_dx)
    ld      de, (ln_dy)
    jp      w_line_generic

; hl = x: carry if it is 0 to 319.  Keeps hl.
chkx:
    push    hl
    ld      bc, 320
    or      a
    sbc     hl, bc
    pop     hl
    ret

; de = y: carry if it is 0 to 199.
chky:
    ld      a, d
    or      a
    ret     nz
    ld      a, e
    cp      200
    ret

negate:
    xor     a
    sub     l
    ld      l, a
    ld      a, 0
    sbc     a, h
    ld      h, a
    ret

    SECTION bss_clib
ln_dx:      defw    0
ln_dy:      defw    0
ln_adx:     defw    0
ln_ady:     defw    0
ln_x1:      defw    0
ln_y1:      defw    0
ln_major:   defw    0
ln_minor:   defw    0
ln_addr:    defw    0
ln_mask:    defb    0
ln_mc:      defb    0
ln_flags:   defb    0
