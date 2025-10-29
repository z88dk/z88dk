; -----------------------------------------------------------------------------
; ZX1 decoder by Einar Saukas & introspec
; "Mega" version (406 bytes, 25% faster) - BACKWARDS VARIANT
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_mega_back:
        ld      bc, 1                   ; preserve default offset 1
        ld      (dzx1mb_last_offset+1), bc
        dec     c
        jr      dzx1mb_literals0

dzx1mb_new_offset6:
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1mb_msb_skip6
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1mb_msb_skip6:
        inc     c
        ld      (dzx1mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        add     a, a
        jp      nc, dzx1mb_length5
        add     a, a
        rl      c
        add     a, a
        jr      nc, dzx1mb_length3
dzx1mb_elias_length3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx1mb_elias_length1
dzx1mb_length1:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1) ; restore offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1mb_new_offset0
dzx1mb_literals0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a                    ; obtain length
        jr      nc, dzx1mb_literals7
dzx1mb_elias_literals7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx1mb_elias_literals5
dzx1mb_literals5:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1mb_new_offset4
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1mb_reuse3
dzx1mb_elias_reuse3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx1mb_elias_reuse1
dzx1mb_reuse1:
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1mb_literals0

dzx1mb_new_offset0:
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1mb_msb_skip0
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1mb_msb_skip0:
        inc     c
        ld      (dzx1mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx1mb_length7
        add     a, a
        rl      c
        add     a, a
        jr      nc, dzx1mb_length5
dzx1mb_elias_length5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1mb_elias_length3
dzx1mb_length3:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1) ; restore offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1mb_new_offset2
dzx1mb_literals2:
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1mb_literals1
dzx1mb_elias_literals1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jr      c, dzx1mb_elias_literals7
dzx1mb_literals7:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1mb_new_offset6
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1mb_reuse5
dzx1mb_elias_reuse5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1mb_elias_reuse3
dzx1mb_reuse3:
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1mb_literals2

dzx1mb_new_offset2:
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1mb_msb_skip2
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1mb_msb_skip2:
        inc     c
        ld      (dzx1mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        add     a, a
        jp      nc, dzx1mb_length1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jr      nc, dzx1mb_length7
dzx1mb_elias_length7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1mb_elias_length5
dzx1mb_length5:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1) ; restore offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx1mb_new_offset4
dzx1mb_literals4:
        inc     c
        add     a, a                    ; obtain length
        jr      nc, dzx1mb_literals3
dzx1mb_elias_literals3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1mb_elias_literals1
dzx1mb_literals1:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1mb_new_offset0
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a                    ; obtain length
        jr      nc, dzx1mb_reuse7
dzx1mb_elias_reuse7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1mb_elias_reuse5
dzx1mb_reuse5:
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1mb_literals4

dzx1mb_new_offset4:
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1mb_msb_skip4
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1mb_msb_skip4:
        inc     c
        ld      (dzx1mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        add     a, a
        jp      nc, dzx1mb_length3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx1mb_length1
dzx1mb_elias_length1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jr      c, dzx1mb_elias_length7
dzx1mb_length7:
        inc     bc
        push    hl                      ; preserve source
        ld      hl, (dzx1mb_last_offset+1) ; restore offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jp      c, dzx1mb_new_offset6
dzx1mb_literals6:
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx1mb_literals5
dzx1mb_elias_literals5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      c, dzx1mb_elias_literals3
dzx1mb_literals3:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx1mb_new_offset2
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx1mb_reuse1
dzx1mb_elias_reuse1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jr      c, dzx1mb_elias_reuse7
dzx1mb_reuse7:
        push    hl                      ; preserve source
dzx1mb_last_offset:
        ld      hl, 0
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1mb_literals6

        jp      dzx1mb_new_offset6
; -----------------------------------------------------------------------------
