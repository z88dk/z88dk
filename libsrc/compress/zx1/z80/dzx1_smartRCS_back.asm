; -----------------------------------------------------------------------------
; "Smart" integrated RCS+ZX1 decoder by Einar Saukas (112 bytes) - BACKWARDS
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_smartrcs_back:
        ld      bc, 1                   ; preserve default offset 1
        push    bc
        ld      a, $80
dzx1rb_literals:
        call    dzx1rb_elias            ; obtain length
dzx1rb_literals_loop:
        call    dzx1rb_copy_byte        ; copy literals
        jp      pe, dzx1rb_literals_loop
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx1rb_new_offset
        call    dzx1rb_elias            ; obtain length
dzx1rb_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
dzx1rb_copy_loop:
        push    hl                      ; copy from offset
        ex      de, hl
        call    dzx1rb_convert
        ex      de, hl
        call    dzx1rb_copy_byte
        pop     hl
        dec     hl
        jp      pe, dzx1rb_copy_loop
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1rb_literals
dzx1rb_new_offset:
        inc     sp                      ; discard last offset
        inc     sp
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     c                       ; single byte offset?
        jr      nc, dzx1rb_msb_skip
        ld      b, (hl)                 ; obtain offset MSB
        dec     hl
        srl     b                       ; replace last LSB bit with last MSB bit
        ret     z                       ; check end marker
        dec     b
        rl      c
dzx1rb_msb_skip:
        inc     c
        push    bc                      ; preserve new offset
        call    dzx1rb_elias            ; obtain length
        inc     bc
        jr      dzx1rb_copy
dzx1rb_elias:
        ld      bc, 1                   ; interlaced Elias gamma coding
dzx1rb_elias_loop:
        add     a, a
        jr      nz, dzx1rb_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
dzx1rb_elias_skip:
        ret     nc
        add     a, a
        rl      c
        rl      b
        jr      dzx1rb_elias_loop
dzx1rb_copy_byte:
        push    de                      ; preserve destination
        call    dzx1rb_convert          ; convert destination
        ldd                             ; copy byte
        pop     de                      ; restore destination
        dec     de                      ; update destination
        ret
; Convert an RCS address 010RRccc ccrrrppp to screen address 010RRppp rrrccccc
dzx1rb_convert:
        ex      af, af'
        ld      a, d                    ; A = 010RRccc
        cp      $58
        jr      nc, dzx1rb_skip
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
dzx1rb_skip:
        ex      af, af'
        ret
; -----------------------------------------------------------------------------
