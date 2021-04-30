; -----------------------------------------------------------------------------
; ZX2 decoder by Einar Saukas
; "Nano" version (49-56 bytes)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx2_nano:

IF DEFINED_ZX2_Z_IGNORE_DEFAULT
        ld      b, $ff                  ; allocate default offset
ELSE
        ld      bc, $ffff               ; preserve default offset 1
ENDIF

        push    bc
        ld      a, $80
dzx2n_literals:
        call    dzx2n_elias             ; obtain length
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx2n_new_offset
dzx2n_reuse:
        call    dzx2n_elias             ; obtain length
dzx2n_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx2n_literals
dzx2n_new_offset:
        pop     bc                      ; discard last offset
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        inc     c
        ret     z                       ; check end marker
        push    bc                      ; preserve new offset

IF DEFINED_ZX2_X_SKIP_INCREMENT
        jr      dzx2n_reuse
ELSE
        call    dzx2n_elias             ; obtain length
        inc     bc
        jr      dzx2n_copy
ENDIF

dzx2n_elias:
        ld      bc, 1                   ; interlaced Elias gamma coding
dzx2n_elias_loop:
        add     a, a
        jr      nz, dzx2n_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx2n_elias_skip:
        ret     nc
        add     a, a
        rl      c

IF DEFINED_ZX2_Y_LIMIT_LENGTH
ELSE
        rl      b
ENDIF

        jr      dzx2n_elias_loop
; -----------------------------------------------------------------------------
