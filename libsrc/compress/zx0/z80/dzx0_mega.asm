; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas
; "Mega" version (681 bytes, 28% faster)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_mega:
        ld      bc, $ffff               ; preserve default offset 1
        ld      (dzx0m_last_offset+1), bc
        inc     bc
        jr      dzx0m_literals0

dzx0m_new_offset6:
        inc     c
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset1
dzx0m_elias_offset1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_offset7
dzx0m_new_offset7:
        ex      af, af'                 ; adjust for negative offset
        xor     a
        sub     c
        ret     z                       ; check end marker
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length7        ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length3
dzx0m_elias_length3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_length1
dzx0m_length1:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0m_new_offset0
dzx0m_literals0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals3
dzx0m_elias_literals3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_literals1
dzx0m_literals1:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0m_new_offset0
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse3
dzx0m_elias_reuse3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_reuse1
dzx0m_reuse1:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals0

dzx0m_new_offset0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset3
dzx0m_elias_offset3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_offset1
dzx0m_new_offset1:
        ex      af, af'                 ; adjust for negative offset
        xor     a
        sub     c
        ret     z                       ; check end marker
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length1        ; obtain length
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_length7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length5
dzx0m_elias_length5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_length3
dzx0m_length3:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0m_new_offset2
dzx0m_literals2:
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_literals7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals5
dzx0m_elias_literals5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_literals3
dzx0m_literals3:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0m_new_offset2
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_reuse7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse5
dzx0m_elias_reuse5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_reuse3
dzx0m_reuse3:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals2

dzx0m_new_offset2:
        inc     c
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_new_offset7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset5
dzx0m_elias_offset5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_offset3
dzx0m_new_offset3:
        ex      af, af'                 ; adjust for negative offset
        xor     a
        sub     c
        ret     z                       ; check end marker
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length3        ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_length7
dzx0m_elias_length7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_length5
dzx0m_length5:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0m_new_offset4
dzx0m_literals4:
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_literals7
dzx0m_elias_literals7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_literals5
dzx0m_literals5:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0m_new_offset4
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_reuse7
dzx0m_elias_reuse7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_reuse5
dzx0m_reuse5:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals4

dzx0m_new_offset4:
        inc     c
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_new_offset7
dzx0m_elias_offset7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_offset5
dzx0m_new_offset5:
        ex      af, af'                 ; adjust for negative offset
        xor     a
        sub     c
        ret     z                       ; check end marker
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length5        ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length1
dzx0m_elias_length1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_length7
dzx0m_length7:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jp      c, dzx0m_new_offset6
dzx0m_literals6:
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals1
dzx0m_elias_literals1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_literals7
dzx0m_literals7:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx0m_new_offset6
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse1
dzx0m_elias_reuse1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_reuse7
dzx0m_reuse7:
        push    hl                      ; preserve source
dzx0m_last_offset:
        ld      hl, 0
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals6

        jp      dzx0m_new_offset6
; -----------------------------------------------------------------------------
