; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas & introspec
; "Turbo" version (128 bytes, 21% faster) - BACKWARDS VARIANT
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_turbo_back:
        ld      bc, 1                   ; preserve default offset 1
        ld      (dzx0tb_last_offset+1), bc
        dec     c
        ld      a, $80
        jr      dzx0tb_literals
dzx0tb_new_offset:
        inc     c                       ; obtain offset MSB
        add     a, a
        call    c, dzx0tb_elias
        dec     b
        ret     z                       ; check end marker
        dec     c                       ; adjust for positive offset
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     b                       ; last offset bit becomes first length bit
        rr      c
        inc     bc
        ld      (dzx0tb_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    c, dzx0tb_elias_loop
        inc     bc
dzx0tb_copy:
        push    hl                      ; preserve source
dzx0tb_last_offset:
        ld      hl, 0                   ; restore offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0tb_new_offset
dzx0tb_literals:
        inc     c                       ; obtain length
        add     a, a
        call    c, dzx0tb_elias
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0tb_new_offset
        inc     c                       ; obtain length
        add     a, a
        call    c, dzx0tb_elias
        jp      dzx0tb_copy
dzx0tb_elias_loop:
        add     a, a
        rl      c
        add     a, a
        ret     nc
dzx0tb_elias:
        jp      nz, dzx0tb_elias_loop   ; inverted interlaced Elias gamma coding
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
dzx0tb_elias_reload:
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
        jr      c, dzx0tb_elias_reload
        ret
; -----------------------------------------------------------------------------
