; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas & Urusergi
; "Standard" version - gbz80
; feilipu 2026
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------
; ROM-safe: the offset lives on the stack. gbz80 has no ex (sp),hl and no ldir.
; -----------------------------------------------------------------------------

dzx0_standard:
        ld      bc, $ffff               ; preserve default offset 1
        push    bc
        inc     bc
        ld      a, $80
dzx0s_literals:
        call    dzx0s_elias             ; obtain length
        call    dzx0s_ldir              ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0s_new_offset
        call    dzx0s_elias             ; obtain length
dzx0s_copy:
        push    hl                      ; preserve source
        push    af                      ; preserve bitstream
        ld      hl, sp+4                ; offset word
        ld      a, (hl+)
        ld      h, (hl)
        ld      l, a
        pop     af
        add     hl, de                  ; calculate destination - offset
        call    dzx0s_ldir              ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0s_literals
dzx0s_new_offset:
        pop     bc                      ; discard last offset
        ld      c, $fe                  ; prepare negative offset
        call    dzx0s_elias_loop        ; obtain offset MSB
        inc     c
        ret     z                       ; check end marker
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        push    bc                      ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    nc, dzx0s_elias_backtrack
        inc     bc
        jr      dzx0s_copy
dzx0s_elias:
        inc     c                       ; interlaced Elias gamma coding
dzx0s_elias_loop:
        add     a, a
        jr      nz, dzx0s_elias_skip
        ld      a, (hl+)                ; load another group of 8 bits
        rla
dzx0s_elias_skip:
        ret     c
dzx0s_elias_backtrack:
        add     a, a
        rl      c
        rl      b
        jr      dzx0s_elias_loop
dzx0s_ldir:
        push    af
dzx0s_ldir_loop:
        ld      a, (hl+)
        ld      (de), a
        inc     de
        dec     bc
        ld      a, b
        or      c
        jr      nz, dzx0s_ldir_loop
        pop     af
        ret
; -----------------------------------------------------------------------------
