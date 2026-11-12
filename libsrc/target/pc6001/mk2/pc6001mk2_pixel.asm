; PC-6001mkII 320x200 console and graphics (mode MC6847_MODE_MK2 = 3 of
; classic/video/mc6847): two bit planes, plane 0 at the screen's base (the crt's
; __pc6001mk2_vram: $C000 for the disc, $8000 for a cartridge) and plane 1 $2000
; on, 40 bytes a pixel row, the leftmost pixel of a byte its bit 7; a pixel's
; pen is its plane 0 bit + 2 * its plane 1 bit, and the four pens are the
; colours of the set $C0 chooses (the default set 4 is green, yellow, blue, red:
; -pragma-define:CRT_PC6001MK2_COLOURSET=n).  The console is 40x25 cells of 8x8
; pixels, a cell its glyph in the ink pen over the paper pen.
; In pc6001mk2.lib, linked ahead of pc6001_clib by -subtype=mk2disc, so these
; replace the do-nothing stubs the PC-6001 has.

    SECTION     code_driver
    PUBLIC      __pc6001mk2_plotpixel
    PUBLIC      __pc6001mk2_respixel
    PUBLIC      __pc6001mk2_xorpixel
    PUBLIC      __pc6001mk2_pointxy
    PUBLIC      __pc6001mk2_getmaxx
    PUBLIC      __pc6001mk2_getmaxy
    PUBLIC      w_plotpixel
    PUBLIC      w_respixel
    PUBLIC      w_xorpixel
    PUBLIC      w_pointxy
    PUBLIC      w_pixeladdress
    PUBLIC      getmaxx
    PUBLIC      _getmaxx
    PUBLIC      getmaxy
    PUBLIC      _getmaxy
    EXTERN      __gfx_coords
    EXTERN      __pc6001mk2_ink
    EXTERN      __pc6001mk2_paper
    EXTERN      __pc6001mk2_vram

; Entry: hl = x, de = y.  Exit: carry set if the pixel is on the screen: hl =
; the byte in plane 0, c = the pixel's mask (the leftmost pixel is bit 7),
; (__gfx_coords) = x, y;
; else NC.  Uses a, b, de.
pixel_addr:
    ld          a, h
    cp          2
    ret         nc                      ; (x < 512)
    ld          a, l
    push        hl
    ld          bc, 320
    or          a
    sbc         hl, bc
    pop         hl
    ret         nc                      ; x >= 320
    ld          a, d
    or          a
    ret         nz
    ld          a, e
    cp          200
    ret         nc
    ld          (__gfx_coords), hl
    ld          (__gfx_coords+2), de
    ld          a, l
    and         7
    ld          b, a
    ld          c, $80
    jr          z, mask_done
mask_loop:
    srl         c
    djnz        mask_loop
mask_done:
    ld          a, l                    ; x / 8
    srl         h
    rra
    srl         a
    srl         a
    ld          b, a                    ; b = x / 8 (under 40)
    ld          l, e
    ld          h, 0
    ld          d, h
    ld          e, l
    add         hl, hl
    add         hl, hl
    add         hl, de                  ; y * 5
    add         hl, hl
    add         hl, hl
    add         hl, hl                  ; y * 40
    ld          e, b
    ld          d, 0
    add         hl, de
    ld          de, __pc6001mk2_vram
    add         hl, de
    scf
    ret

; hl = x, de = y: hl = de = the byte in plane 0, a = the pixel's bit number (7
; for the leftmost)
w_pixeladdress:
    call        pixel_addr
    jr          c, pa_ok
    ld          hl, 0
    ld          a, 0
    jr          pa_out
pa_ok:
    ld          a, c
    ld          b, 7
pa_bit:
    rlca
    jr          c, pa_found
    djnz        pa_bit
pa_found:
    ld          a, b
pa_out:
    ld          d, h
    ld          e, l
    ret

; Set the pixel in both planes to the pen in b: hl = the byte in plane 0, c =
; the mask
put_pen:
    ld          a, c
    cpl
    ld          d, a                    ; the other pixels
    ld          a, (hl)
    and         d
    bit         0, b
    jr          z, p0
    or          c
p0: ld          (hl), a
    ld          a, h
    add         a, $20
    ld          h, a
    ld          a, (hl)
    and         d
    bit         1, b
    jr          z, p1
    or          c
p1: ld          (hl), a
    ret

__pc6001mk2_plotpixel:
w_plotpixel:
    call        pixel_addr
    ret         nc
    ld          a, (__pc6001mk2_ink)
    ld          b, a
    jr          put_pen

__pc6001mk2_respixel:
w_respixel:
    call        pixel_addr
    ret         nc
    ld          a, (__pc6001mk2_paper)
    ld          b, a
    jr          put_pen

; xor the ink into the pixel's pen
__pc6001mk2_xorpixel:
w_xorpixel:
    call        pixel_addr
    ret         nc
    ld          a, (__pc6001mk2_ink)
    ld          b, a
    bit         0, b
    jr          z, x0
    ld          a, (hl)
    xor         c
    ld          (hl), a
x0: ld          a, h
    add         a, $20
    ld          h, a
    bit         1, b
    ret         z
    ld          a, (hl)
    xor         c
    ld          (hl), a
    ret

; NZ if the pixel is not the paper pen (a pixel off the screen is not)
__pc6001mk2_pointxy:
w_pointxy:
    call        pixel_addr
    jr          c, pt_on
    xor         a
    ret
pt_on:
    ld          a, (__pc6001mk2_paper)
    ld          b, a
    ld          a, (hl)
    and         c
    jr          z, pt0
    ld          a, 1
pt0:
    ld          d, a                    ; the pen's bit 0
    ld          a, h
    add         a, $20
    ld          h, a
    ld          a, (hl)
    and         c
    jr          z, pt1
    ld          a, 2
pt1:
    or          d                       ; the pen
    xor         b                       ; 0 if it is the paper
    ret

__pc6001mk2_getmaxx:
getmaxx:
_getmaxx:
    ld          hl, 319
    ret

__pc6001mk2_getmaxy:
getmaxy:
_getmaxy:
    ld          hl, 199
    ret
