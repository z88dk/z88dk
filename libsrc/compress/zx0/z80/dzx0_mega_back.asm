; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas & introspec
; "Mega" version (677 bytes, 28% faster) - BACKWARDS VARIANT
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_mega_back:
        ld      bc, 1                   ; preserve default offset 1
        ld      (dzx0mb_last_offset+1), bc
        dec     c
        jr      dzx0mb_literals0

dzx0mb_new_offset6:
        inc     c
        add     a, a                    ; obtain offset MSB
        jp      nc, dzx0mb_new_offset5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_new_offset3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_new_offset1
dzx0mb_elias_offset1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      c, dzx0mb_elias_offset7
dzx0mb_new_offset7:
        dec     b
        ret     z                       ; check end marker
        dec     c                       ; adjust for positive offset
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     b                       ; last offset bit becomes first length bit
        rr      c
        inc     bc
        ld      (dzx0mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      nc, dzx0mb_length7      ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_length5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_length3
dzx0mb_elias_length3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_length1
dzx0mb_length1:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        inc     c
        ldd                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0mb_new_offset0
dzx0mb_literals0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_literals7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_literals5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_literals3
dzx0mb_elias_literals3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_literals1
dzx0mb_literals1:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0mb_new_offset0
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_reuse7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_reuse5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_reuse3
dzx0mb_elias_reuse3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_reuse1
dzx0mb_reuse1:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0mb_literals0

dzx0mb_new_offset0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a                    ; obtain offset MSB
        jp      nc, dzx0mb_new_offset7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_new_offset5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_new_offset3
dzx0mb_elias_offset3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_offset1
dzx0mb_new_offset1:
        dec     b
        ret     z                       ; check end marker
        dec     c                       ; adjust for positive offset
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     b                       ; last offset bit becomes first length bit
        rr      c
        inc     bc
        ld      (dzx0mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      nc, dzx0mb_length1      ; obtain length
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_length7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_length5
dzx0mb_elias_length5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_length3
dzx0mb_length3:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        inc     c
        ldd                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0mb_new_offset2
dzx0mb_literals2:
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_literals1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_literals7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_literals5
dzx0mb_elias_literals5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_literals3
dzx0mb_literals3:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0mb_new_offset2
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_reuse1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_reuse7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_reuse5
dzx0mb_elias_reuse5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_reuse3
dzx0mb_reuse3:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0mb_literals2

dzx0mb_new_offset2:
        inc     c
        add     a, a                    ; obtain offset MSB
        jp      nc, dzx0mb_new_offset1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_new_offset7
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_new_offset5
dzx0mb_elias_offset5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_offset3
dzx0mb_new_offset3:
        dec     b
        ret     z                       ; check end marker
        dec     c                       ; adjust for positive offset
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     b                       ; last offset bit becomes first length bit
        rr      c
        inc     bc
        ld      (dzx0mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      nc, dzx0mb_length3      ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_length1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_length7
dzx0mb_elias_length7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_length5
dzx0mb_length5:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        inc     c
        ldd                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0mb_new_offset4
dzx0mb_literals4:
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_literals3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_literals1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_literals7
dzx0mb_elias_literals7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_literals5
dzx0mb_literals5:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0mb_new_offset4
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_reuse3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_reuse1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_reuse7
dzx0mb_elias_reuse7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_reuse5
dzx0mb_reuse5:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0mb_literals4

dzx0mb_new_offset4:
        inc     c
        add     a, a                    ; obtain offset MSB
        jp      nc, dzx0mb_new_offset3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_new_offset1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      nc, dzx0mb_new_offset7
dzx0mb_elias_offset7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      c, dzx0mb_elias_offset5
dzx0mb_new_offset5:
        dec     b
        ret     z                       ; check end marker
        dec     c                       ; adjust for positive offset
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     b                       ; last offset bit becomes first length bit
        rr      c
        inc     bc
        ld      (dzx0mb_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      nc, dzx0mb_length5      ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_length3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_length1
dzx0mb_elias_length1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      c, dzx0mb_elias_length7
dzx0mb_length7:
        push    hl                      ; preserve source
        ld      hl, (dzx0mb_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        inc     c
        ldd                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jp      c, dzx0mb_new_offset6
dzx0mb_literals6:
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_literals5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_literals3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_literals1
dzx0mb_elias_literals1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      c, dzx0mb_elias_literals7
dzx0mb_literals7:
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx0mb_new_offset6
        inc     c
        add     a, a                    ; obtain length
        jp      nc, dzx0mb_reuse5
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_reuse3
        add     a, a
        rl      c
        add     a, a
        jp      nc, dzx0mb_reuse1
dzx0mb_elias_reuse1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        add     a, a
        jp      c, dzx0mb_elias_reuse7
dzx0mb_reuse7:
        push    hl                      ; preserve source
dzx0mb_last_offset:
        ld      hl, 0
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0mb_literals6

        jp      dzx0mb_new_offset6
; -----------------------------------------------------------------------------
