; The address of a console cell (a module of its own: the boot disc's crt has a
; copy of it in the free space below the interrupt vector table, allrammk2.asm,
; so this is linked only for a cartridge).

    SECTION     code_driver
    PUBLIC      __pc6001mk2_xypos
    EXTERN      __pc6001mk2_vram

; Entry: b = row, c = column.  Exit: hl = the address of the cell's first line
; in plane 0.  Uses a.
__pc6001mk2_xypos:
    ld          l, b
    ld          h, 0
    ld          d, h
    ld          e, l
    add         hl, hl
    add         hl, hl
    add         hl, de                  ; y * 5
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, hl                  ; y * 320
    ld          a, h
    add         a, +(__pc6001mk2_vram/256)
    ld          h, a
    ld          a, l
    add         a, c
    ld          l, a
    ret         nc
    inc         h
    ret
