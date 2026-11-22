; -----------------------------------------------------------------------------
; "Smart" integrated RCS+ZX1 decoder by Einar Saukas (112 bytes)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx1_smartrcs:
        ld      bc, $ffff               ; preserve default offset 1
        push    bc
        ld      a, $80
dzx1r_literals:
        call    dzx1r_elias             ; obtain length
dzx1r_literals_loop:
        call    dzx1r_copy_byte         ; copy literals
        jp      pe, dzx1r_literals_loop
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx1r_new_offset
        call    dzx1r_elias             ; obtain length
dzx1r_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
dzx1r_copy_loop:
        push    hl                      ; copy from offset
        ex      de, hl
        call    dzx1r_convert
        ex      de, hl
        call    dzx1r_copy_byte
        pop     hl
        inc     hl
        jp      pe, dzx1r_copy_loop
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx1r_literals
dzx1r_new_offset:
        inc     sp                      ; discard last offset
        inc     sp
        dec     b
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      c                       ; single byte offset?
        jr      nc, dzx1r_msb_skip
        ld      b, (hl)                 ; obtain offset MSB
        inc     hl
        rr      b                       ; replace last LSB bit with last MSB bit
        inc     b
        ret     z                       ; check end marker
        rl      c
dzx1r_msb_skip:
        push    bc                      ; preserve new offset
        call    dzx1r_elias             ; obtain length
        inc     bc
        jr      dzx1r_copy
dzx1r_elias:
        ld      bc, 1                   ; interlaced Elias gamma coding
dzx1r_elias_loop:        
        add     a, a
        jr      nz, dzx1r_elias_skip    
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx1r_elias_skip:        
        ret     nc
        add     a, a
        rl      c
        rl      b
        jr      dzx1r_elias_loop
dzx1r_copy_byte:
        push    de                      ; preserve destination
        call    dzx1r_convert           ; convert destination
        ldi                             ; copy byte
        pop     de                      ; restore destination
        inc     de                      ; update destination
        ret
; Convert an RCS address 010RRccc ccrrrppp to screen address 010RRppp rrrccccc
dzx1r_convert:
        ex      af, af'
        ld      a, d                    ; A = 010RRccc
        cp      $58
        jr      nc, dzx1r_skip
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
dzx1r_skip:
        ex      af, af'
        ret
; -----------------------------------------------------------------------------
