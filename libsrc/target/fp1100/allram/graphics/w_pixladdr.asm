; Pixel addressing for the all-RAM console.  The screen is 320x200 on three planes (blue $2000, red $6000, green $A000), 40x25 cells of 8 bytes, a cell's
; lines in order, the leftmost pixel of a byte its bit 0.  The planes are in the sub-CPU's video RAM, so a pixel is a command to the sub program (../sub/sub.s.in).

    MODULE  fp1100_allram_w_pixladdr
    SECTION code_driver

    PUBLIC  w_pixeladdress
    PUBLIC  fp1100_pixel_addr
    PUBLIC  fp1100_pixel_send
    PUBLIC  __fp1100_plot_buffer
    EXTERN  __gfx_coords
    EXTERN  fp1100_sub_send

    INCLUDE "../sub/sub.inc"

; Entry: hl = x, de = y.  Exit: carry set if the pixel is on the screen, else NC.  If it is: (__gfx_coords) = x, y, hl = the blue plane byte, c = the
; mask (1 << (x & 7)).  Uses a, b, de.
fp1100_pixel_addr:
    push    hl
    ld      bc, 320
    or      a
    sbc     hl, bc
    pop     hl
    ret     nc
    ld      a, d
    or      a
    ret     nz
    ld      a, e
    cp      200
    ret     nc
    ld      (__gfx_coords), hl
    ld      (__gfx_coords + 2), de
    ld      a, l
    and     7
    ld      b, a
    ld      c, 1
    jr      z, pa_mask
pa_sh:
    sla     c
    djnz    pa_sh
pa_mask:
    ld      a, l
    and     $F8
    ld      l, a
    push    hl                          ; x & ~7
    ld      a, e
    and     7
    ld      b, a                        ; the line in the cell
    ld      a, e
    and     $F8
    ld      l, a
    ld      h, 0                        ; y & ~7, which is 8 * the cell row
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      d, h
    ld      e, l                        ; * 8
    add     hl, hl
    add     hl, hl                      ; * 32
    add     hl, de                      ; * 40: a row of cells is 320 bytes
    pop     de
    add     hl, de
    ld      e, b
    ld      d, 0
    add     hl, de
    ld      de, $2000
    add     hl, de
    scf
    ret

; hl = x, de = y: hl = de = the blue plane byte, a = the pixel's bit (0 to 7).  (The screen is not readable: it is only the address.)
w_pixeladdress:
    ld      a, l
    and     7
    push    af
    call    fp1100_pixel_addr
    jr      c, wp_ok
    ld      hl, 0
wp_ok:
    ld      d, h
    ld      e, l
    pop     af
    ret

; hl = the byte, c = the mask, b = the colour (bits 0 to 2, bit 3: flip): the sub program's Pix.
fp1100_pixel_send:
    ld      a, SUB_PIX
    call    fp1100_sub_send
    ld      a, l
    call    fp1100_sub_send
    ld      a, h
    call    fp1100_sub_send
    ld      a, c
    call    fp1100_sub_send
    ld      a, b
    jp      fp1100_sub_send

    SECTION bss_clib

__fp1100_plot_buffer:
    defs    9
