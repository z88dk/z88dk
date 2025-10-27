; -----------------------------------------------------------------------------
; "Agile" integrated RCS+ZX1 decoder by Einar Saukas (189 bytes)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_agilercs:
        ld      bc, $ffff               ; preserve default offset 1
        ld      (dzx1a_last_offset+1), bc
        inc     bc
        ld      a, $80
        jr      dzx1a_literals
dzx1a_new_offset:
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1a_msb_skip
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1a_msb_skip:
        ld      (dzx1a_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        add     a, a
        call    c, dzx1a_elias
        inc     bc
dzx1a_copy:
        push    hl                      ; preserve source
dzx1a_last_offset:
        ld      hl, 0                   ; restore offset
        add     hl, de                  ; calculate destination - offset
        ex      af, af'
dzx1a_copy_loop:
        ld      a, h                    ; copy from offset
        cp      $58
        jr      nc, dzx1a_copy_ldir
        push    hl
        ex      de, hl
        call    dzx1a_convert
        ex      de, hl
        push    de
        ld      a, d
        cp      $58
        call    c, dzx1a_convert
        ldi
        pop     de
        inc     de
        pop     hl
        inc     hl
        jp      pe, dzx1a_copy_loop
        db      $ea                     ; skip next instruction
dzx1a_copy_ldir:
        ldir
        ex      af, af'
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1a_new_offset
dzx1a_literals:
        inc     c                       ; obtain length
        add     a, a
        call    c, dzx1a_elias
        ex      af, af'
dzx1a_literals_loop:
        ld      a, d                    ; copy literals
        cp      $58
        jr      nc, dzx1a_literals_ldir
        push    de
        call    dzx1a_convert
        ldi
        pop     de
        inc     de
        jp      pe, dzx1a_literals_loop
        db      $ea                     ; skip next instruction
dzx1a_literals_ldir:
        ldir
        ex      af, af'
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx1a_new_offset
        inc     c                       ; obtain length
        add     a, a
        call    c, dzx1a_elias
        jp      dzx1a_copy
dzx1a_elias_loop:
        add     a, a
        rl      c
        add     a, a
        ret     nc
dzx1a_elias:
        jp      nz, dzx1a_elias_loop    ; inverted interlaced Elias gamma coding
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
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
dzx1a_elias_reload:
        add     a, a
        rl      c
        rl      b
        add     a, a
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
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
        jr      c, dzx1a_elias_reload
        ret
; Convert an RCS address 010RRccc ccrrrppp to screen address 010RRppp rrrccccc
dzx1a_convert:                          ; A = 010RRccc
        xor     e
        and     $f8
        xor     e                       ; A = 010RRppp
        push    af
        xor     d
        xor     e                       ; A = ccrrrccc
        rlca
        rlca                            ; A = rrrccccc
        pop     de                      ; D = 010RRppp
        ld      e, a                    ; E = rrrccccc
        ret
; -----------------------------------------------------------------------------
