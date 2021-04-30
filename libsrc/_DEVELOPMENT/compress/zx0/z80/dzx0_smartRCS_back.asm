; -----------------------------------------------------------------------------
; "Smart" integrated RCS+ZX0 decoder by Einar Saukas (113 bytes) - BACKWARDS
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_smartrcs_back:
        ld      bc, 1                   ; preserve default offset 1
        push    bc
        dec     c
        ld      a, $80
dzx0rb_literals:
        call    dzx0rb_elias            ; obtain length
dzx0rb_literals_loop:
        call    dzx0rb_copy_byte        ; copy literals
        jp      pe, dzx0rb_literals_loop
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0rb_new_offset
        call    dzx0rb_elias            ; obtain length
dzx0rb_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
dzx0rb_copy_loop:
        push    hl                      ; copy from offset
        ex      de, hl
        call    dzx0rb_convert
        ex      de, hl
        call    dzx0rb_copy_byte
        pop     hl
        dec     hl
        jp      pe, dzx0rb_copy_loop
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0rb_literals
dzx0rb_new_offset:
        inc     sp                      ; discard last offset
        inc     sp
        call    dzx0rb_elias            ; obtain offset MSB
        dec     b
        ret     z                       ; check end marker
        dec     c                       ; adjust for positive offset
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        srl     b                       ; last offset bit becomes first length bit
        rr      c
        inc     bc
        push    bc                      ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    c, dzx0rb_elias_backtrack
        inc     bc
        jr      dzx0rb_copy
dzx0rb_elias:
        inc     c                       ; inverted interlaced Elias gamma coding
dzx0rb_elias_loop:
        add     a, a
        jr      nz, dzx0rb_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
dzx0rb_elias_skip:
        ret     nc
dzx0rb_elias_backtrack:
        add     a, a
        rl      c
        rl      b
        jr      dzx0rb_elias_loop
dzx0rb_copy_byte:
        push    de                      ; preserve destination
        call    dzx0rb_convert          ; convert destination
        ldd                             ; copy byte
        pop     de                      ; restore destination
        dec     de                      ; update destination
        ret
; Convert an RCS address 010RRccc ccrrrppp to screen address 010RRppp rrrccccc
dzx0rb_convert:
        ex      af, af'
        ld      a, d                    ; A = 010RRccc
        cp      $58
        jr      nc, dzx0rb_skip
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
dzx0rb_skip:
        ex      af, af'
        ret
; -----------------------------------------------------------------------------
