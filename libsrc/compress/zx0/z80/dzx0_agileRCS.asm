; -----------------------------------------------------------------------------
; "Agile" integrated RCS+ZX0 decoder by Einar Saukas (189 bytes)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_agilercs:
        ld      bc, $ffff               ; preserve default offset 1
        ld      (dzx0a_last_offset+1), bc
        inc     bc
        ld      a, $80
        jr      dzx0a_literals
dzx0a_new_offset:
        inc     c                       ; obtain offset MSB
        add     a, a
        jp      nz, dzx0a_new_offset_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0a_new_offset_skip:
        call    nc, dzx0a_elias
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
        ld      (dzx0a_last_offset+1), bc ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    nc, dzx0a_elias
        inc     bc
dzx0a_copy:
        push    hl                      ; preserve source
dzx0a_last_offset:
        ld      hl, 0                   ; restore offset
        add     hl, de                  ; calculate destination - offset
        ex      af, af'
dzx0a_copy_loop:
        ld      a, h                    ; copy from offset
        cp      $58
        jr      nc, dzx0a_copy_ldir
        push    hl
        ex      de, hl
        call    dzx0a_convert
        ex      de, hl
        push    de
        ld      a, d
        cp      $58
        call    c, dzx0a_convert
        ldi
        pop     de
        inc     de
        pop     hl
        inc     hl
        jp      pe, dzx0a_copy_loop
        db      $ea                     ; skip next instruction
dzx0a_copy_ldir:
        ldir
        ex      af, af'
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0a_new_offset
dzx0a_literals:
        inc     c                       ; obtain length
        add     a, a
        jp      nz, dzx0a_literals_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0a_literals_skip:
        call    nc, dzx0a_elias
        ex      af, af'
dzx0a_literals_loop:
        ld      a, d                    ; copy literals
        cp      $58
        jr      nc, dzx0a_literals_ldir
        push    de
        call    dzx0a_convert
        ldi
        pop     de
        inc     de
        jp      pe, dzx0a_literals_loop
        db      $ea                     ; skip next instruction
dzx0a_literals_ldir:
        ldir
        ex      af, af'
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0a_new_offset
        inc     c                       ; obtain length
        add     a, a
        jp      nz, dzx0a_last_offset_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0a_last_offset_skip:
        call    nc, dzx0a_elias
        jp      dzx0a_copy
dzx0a_elias:
        add     a, a                    ; interlaced Elias gamma coding
        rl      c
        add     a, a
        jr      nc, dzx0a_elias
        ret     nz
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ret     c
        add     a, a
        rl      c
        add     a, a
        ret     c
        add     a, a
        rl      c
        add     a, a
        ret     c
        add     a, a
        rl      c
        add     a, a
        ret     c
dzx0a_elias_loop:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      nc, dzx0a_elias_loop
        ret     nz
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        jr      nc, dzx0a_elias_loop
        ret
; Convert an RCS address 010RRccc ccrrrppp to screen address 010RRppp rrrccccc
dzx0a_convert:                          ; A = 010RRccc
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
        ret
; -----------------------------------------------------------------------------
