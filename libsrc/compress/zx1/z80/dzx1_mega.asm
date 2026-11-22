; -----------------------------------------------------------------------------
; ZX1 decoder by Einar Saukas & introspec
; "Mega" version (406 bytes, 25% faster)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_mega:
        ld      bc, $ffff               ; preserve default offset 1
        ld      (dzx1m_last_offset+1), bc
        inc     bc
        jr      dzx1m_literals0

dzx1m_new_offset6:
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1m_msb_skip6
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1m_msb_skip6:
        ld      (dzx1m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        add     a, a                    ; obtain length
        jp      nc, dzx1m_length5
        add     a, a
        rl      c
        add     a, a
        jr      nc, dzx1m_length3
dzx1m_elias_length3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx1m_elias_length1
dzx1m_length1:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1m_new_offset0
dzx1m_literals0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jr      nc, dzx1m_literals7
dzx1m_elias_literals7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx1m_elias_literals5
dzx1m_literals5:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1m_new_offset4
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1m_reuse3
dzx1m_elias_reuse3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx1m_elias_reuse1
dzx1m_reuse1:
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1m_literals0

dzx1m_new_offset0:
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1m_msb_skip0
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1m_msb_skip0:
        ld      (dzx1m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jp      nc, dzx1m_length7
        add     a, a
        rl      c
        add     a, a
        jr      nc, dzx1m_length5
dzx1m_elias_length5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1m_elias_length3
dzx1m_length3:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1m_new_offset2
dzx1m_literals2:
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1m_literals1
dzx1m_elias_literals1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jr      c, dzx1m_elias_literals7
dzx1m_literals7:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1m_new_offset6
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1m_reuse5
dzx1m_elias_reuse5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1m_elias_reuse3
dzx1m_reuse3:
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1m_literals2

dzx1m_new_offset2:
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1m_msb_skip2
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1m_msb_skip2:
        ld      (dzx1m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        add     a, a                    ; obtain length
        jp      nc, dzx1m_length1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jr      nc, dzx1m_length7
dzx1m_elias_length7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1m_elias_length5
dzx1m_length5:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1m_new_offset4
dzx1m_literals4:
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1m_literals3
dzx1m_elias_literals3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1m_elias_literals1
dzx1m_literals1:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1m_new_offset0
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jr      nc, dzx1m_reuse7
dzx1m_elias_reuse7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1m_elias_reuse5
dzx1m_reuse5:
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1m_literals4

dzx1m_new_offset4:
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1m_msb_skip4
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1m_msb_skip4:
        ld      (dzx1m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        add     a, a                    ; obtain length
        jp      nc, dzx1m_length3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx1m_length1
dzx1m_elias_length1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jr      c, dzx1m_elias_length7
dzx1m_length7:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jp      c, dzx1m_new_offset6
dzx1m_literals6:
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx1m_literals5
dzx1m_elias_literals5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1m_elias_literals3
dzx1m_literals3:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1m_new_offset2
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx1m_reuse1
dzx1m_elias_reuse1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jr      c, dzx1m_elias_reuse7
dzx1m_reuse7:
        push    hl                      ; preserve source
dzx1m_last_offset:
        ld      hl, 0
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1m_literals6

        jp      dzx1m_new_offset6
; -----------------------------------------------------------------------------
