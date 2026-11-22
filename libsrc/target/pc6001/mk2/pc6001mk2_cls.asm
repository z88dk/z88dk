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
    PUBLIC      __pc6001mk2_cls
    PUBLIC      __pc6001mk2_scrollup
    EXTERN      __pc6001mk2_paper
    EXTERN      __pc6001mk2_vram

; Both planes to the paper pen (the screen's base is the crt's:
; __pc6001mk2_vram, $C000 or $8000)
__pc6001mk2_cls:
    push        bc
    push        de
    push        hl
    ld          hl, __pc6001mk2_vram
    ld          de, __pc6001mk2_vram+1
    ld          bc, 7999
    ld          a, (__pc6001mk2_paper)
    rrca
    sbc         a, a                    ; $FF if the paper's plane 0 bit is set
    ld          (hl), a
    ldir
    ld          hl, __pc6001mk2_vram+$2000
    ld          de, __pc6001mk2_vram+$2001
    ld          bc, 7999
    ld          a, (__pc6001mk2_paper)
    rrca
    rrca
    sbc         a, a
    ld          (hl), a
    ldir
    pop         hl
    pop         de
    pop         bc
    ret

; Up one text row: 24 rows of 320 bytes in each plane, and the last row to the
; paper
__pc6001mk2_scrollup:
    push        bc
    push        de
    push        hl
    ld          hl, __pc6001mk2_vram+320
    ld          de, __pc6001mk2_vram
    ld          bc, 24*320
    ldir
    ld          hl, __pc6001mk2_vram+$2000+320
    ld          de, __pc6001mk2_vram+$2000
    ld          bc, 24*320
    ldir
    ld          a, (__pc6001mk2_paper)
    rrca
    sbc         a, a
    ld          hl, __pc6001mk2_vram+24*320
    ld          de, __pc6001mk2_vram+24*320+1
    ld          bc, 319
    ld          (hl), a
    ldir
    ld          a, (__pc6001mk2_paper)
    rrca
    rrca
    sbc         a, a
    ld          hl, __pc6001mk2_vram+$2000+24*320
    ld          de, __pc6001mk2_vram+$2000+24*320+1
    ld          bc, 319
    ld          (hl), a
    ldir
    pop         hl
    pop         de
    pop         bc
    ret
