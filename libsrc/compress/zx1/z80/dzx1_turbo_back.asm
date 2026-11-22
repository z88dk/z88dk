; -----------------------------------------------------------------------------
; ZX1 decoder by Einar Saukas & introspec
; "Turbo" version (128 bytes, 20% faster) - BACKWARDS VARIANT
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_turbo_back:
        ld      bc, 1                   ; preserve default offset 1
        ld      (dzx1tb_last_offset+1), bc
        dec     c
        ld      a, $80
        jr      dzx1tb_literals
dzx1tb_new_offset:
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1tb_msb_skip
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1tb_msb_skip:
        inc     c
        ld      (dzx1tb_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        add     a, a
        call    c, dzx1tb_elias
        inc     bc
dzx1tb_copy:
        push    hl                      ; preserve source
dzx1tb_last_offset:
        ld      hl, 0                   ; restore offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1tb_new_offset
dzx1tb_literals:
        inc     c                       ; obtain length
        add     a, a
        call    c, dzx1tb_elias
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx1tb_new_offset
        inc     c                       ; obtain length
        add     a, a
        call    c, dzx1tb_elias
        jp      dzx1tb_copy
dzx1tb_elias_loop:
        add     a, a
        rl      c
        add     a, a
        ret     nc
dzx1tb_elias:
        jp      nz, dzx1tb_elias_loop   ; inverted interlaced Elias gamma coding
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        ret     nc
        add     a, a
        rl      c
        add     a, a
        ret     nc
        add     a, a
        rl      c
        add     a, a
        ret     nc
        add     a, a
        rl      c
        add     a, a
        ret     nc
dzx1tb_elias_reload:
        add     a, a
        rl      c
        rl      b
        add     a, a
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        ret     nc
        add     a, a
        rl      c
        rl      b
        add     a, a
        ret     nc
        add     a, a
        rl      c
        rl      b
        add     a, a
        ret     nc
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1tb_elias_reload
        ret
; -----------------------------------------------------------------------------
