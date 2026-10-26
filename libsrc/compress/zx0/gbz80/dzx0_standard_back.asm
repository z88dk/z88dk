; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas
; "Standard" version - gbz80 - BACKWARDS VARIANT
; feilipu 2026
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------
; ROM-safe: the offset lives on the stack. gbz80 has no ex (sp),hl and no lddr.
; -----------------------------------------------------------------------------

dzx0_standard_back:
        ld      bc, 1                   ; preserve default offset 1
        push    bc
        ld      a, $80
dzx0sb_literals:
        call    dzx0sb_elias            ; obtain length
        call    dzx0sb_lddr             ; copy literals
        inc     c
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0sb_new_offset
        call    dzx0sb_elias            ; obtain length
dzx0sb_copy:
        push    hl                      ; preserve source
        push    af                      ; preserve bitstream
        ld      hl, sp+4                ; offset word
        ld      a, (hl+)
        ld      h, (hl)
        ld      l, a
        pop     af
        add     hl, de                  ; calculate destination + offset
        call    dzx0sb_lddr             ; copy from offset
        pop     hl                      ; restore source
        inc     c
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0sb_literals
dzx0sb_new_offset:
        inc     sp                      ; discard last offset
        inc     sp
        call    dzx0sb_elias            ; obtain offset MSB
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
        call    c, dzx0sb_elias_backtrack
        inc     bc
        jr      dzx0sb_copy
dzx0sb_elias_backtrack:
        add     a, a
        rl      c
        rl      b
dzx0sb_elias:
        add     a, a                    ; inverted interlaced Elias gamma coding
        jr      nz, dzx0sb_elias_skip
        ld      a, (hl-)                ; load another group of 8 bits
        rla
dzx0sb_elias_skip:
        jr      c, dzx0sb_elias_backtrack
        ret
dzx0sb_lddr:
        push    af
dzx0sb_lddr_loop:
        ld      a, (hl-)
        ld      (de), a
        dec     de
        dec     bc
        ld      a, b
        or      c
        jr      nz, dzx0sb_lddr_loop
        pop     af
        ret
; -----------------------------------------------------------------------------
