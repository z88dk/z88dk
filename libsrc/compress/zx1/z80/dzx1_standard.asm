; -----------------------------------------------------------------------------
; ZX1 decoder by Einar Saukas
; "Standard" version (68 bytes only)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_standard:
        ld      bc, $ffff               ; preserve default offset 1
        push    bc
        ld      a, $80
dzx1s_literals:
        call    dzx1s_elias             ; obtain length
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx1s_new_offset
        call    dzx1s_elias             ; obtain length
dzx1s_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1s_literals
dzx1s_new_offset:
        inc     sp                      ; discard last offset
        inc     sp
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1s_msb_skip
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1s_msb_skip:
        push    bc                      ; preserve new offset
        call    dzx1s_elias             ; obtain length
        inc     bc
        jr      dzx1s_copy
dzx1s_elias:
        ld      bc, 1                   ; interlaced Elias gamma coding
dzx1s_elias_loop:        
        add     a, a
        jr      nz, dzx1s_elias_skip    
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx1s_elias_skip:        
        ret     nc
        add     a, a
        rl      c
        rl      b
        jr      dzx1s_elias_loop
; -----------------------------------------------------------------------------
