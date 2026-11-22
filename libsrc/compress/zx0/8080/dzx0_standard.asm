; -----------------------------------------------------------------------------
; ZX0 8080 decoder by Ivan Gorodetsky
; Based on ZX0 z80 decoder by Einar Saukas
; v1 (2021-02-15) - 103 bytes forward / 100 bytes backward
; v2 (2021-02-17) - 101 bytes forward / 100 bytes backward
; v3 (2021-02-22) - 99 bytes forward / 98 bytes backward
; v4 (2021-02-23) - 98 bytes forward / 97 bytes backward
; v5 (2026-10-15) - forward decoder reads the ZX0 v2 offset MSB
; feilipu 2026 - Zilog mnemonics, split loop ldir / lddr
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_standard:
        ld      bc, de                  ; destination
        ld      de, $ffff               ; preserve default offset 1
        push    de
        inc     de
        ld      a, $80
dzx0s_literals:
        call    dzx0s_elias             ; obtain length
        call    dzx0s_ldir              ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx0s_new_offset
        call    dzx0s_elias             ; obtain length
dzx0s_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, bc                  ; calculate destination - offset
        call    dzx0s_ldir              ; copy from offset
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jp      nc, dzx0s_literals

dzx0s_new_offset:
        pop     de                      ; discard last offset
        ld      e, $fe                  ; prepare negative offset
        call    dzx0s_elias_loop        ; obtain offset MSB
        inc     e
        ret     z                       ; check end marker
        ld      d, e
        push    bc                      ; preserve destination
        ld      b, a                    ; preserve bitstream
        ld      a, d
        rra                             ; last offset bit becomes first length bit
        ld      d, a
        ld      a, (hl)
        rra
        ld      e, a
        ld      a, b                    ; restore bitstream
        pop     bc                      ; restore destination
        inc     hl
        push    de                      ; preserve new offset
        ld      de, 1                   ; obtain length
        call    nc, dzx0s_elias_backtrack
        inc     de
        jp      dzx0s_copy

dzx0s_elias:
        inc     e                       ; interlaced Elias gamma coding
dzx0s_elias_loop:
        add     a, a
        jp      nz, dzx0s_elias_skip
        ld      a, (hl+)                ; load another group of 8 bits
        rla
dzx0s_elias_skip:
        ret     c

dzx0s_elias_backtrack:
        ex      de, hl                  ; length
        add     hl, hl
        ex      de, hl
        add     a, a
        jp      nc, dzx0s_elias_loop
        inc     e
        jp      dzx0s_elias_loop

dzx0s_ldir:
        push    af
        dec     de                      ; split loop wins from 4 bytes
        inc     d
        inc     e
dzx0s_ldir_loop:
        ld      a, (hl+)
        ld      (bc), a
        inc     bc
        dec     e
        jp      nz, dzx0s_ldir_loop
        dec     d
        jp      nz, dzx0s_ldir_loop
        pop     af
        ret

; -----------------------------------------------------------------------------
