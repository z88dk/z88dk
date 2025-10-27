; -----------------------------------------------------------------------------
; ZX1 decoder by Einar Saukas
; "Standard" version (68 bytes only) - BACKWARDS VARIANT
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_standard_back:
        ld      bc, 1                   ; preserve default offset 1
        push    bc
        ld      a, $80
dzx1sb_literals:
        call    dzx1sb_elias            ; obtain length
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx1sb_new_offset
        call    dzx1sb_elias            ; obtain length
dzx1sb_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1sb_literals
dzx1sb_new_offset:
        inc     sp                      ; discard last offset
        inc     sp
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1sb_msb_skip
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1sb_msb_skip:
        inc     c
        push    bc                      ; preserve new offset
        call    dzx1sb_elias            ; obtain length
        inc     bc
        jr      dzx1sb_copy
dzx1sb_elias:
        ld      bc, 1                   ; interlaced Elias gamma coding
dzx1sb_elias_loop:
        add     a, a
        jr      nz, dzx1sb_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
dzx1sb_elias_skip:
        ret     nc
        add     a, a
        rl      c
        rl      b
        jr      dzx1sb_elias_loop
; -----------------------------------------------------------------------------
