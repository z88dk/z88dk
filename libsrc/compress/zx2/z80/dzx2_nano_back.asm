; -----------------------------------------------------------------------------
; ZX2 decoder by Einar Saukas
; "Nano" version (48-55 bytes) - BACKWARDS VARIANT
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------

dzx2_nano_back:

IF DEFINED_ZX2_Z_IGNORE_DEFAULT
        ld      b, 0                    ; allocate default offset
ELSE
        ld      bc, 1                   ; preserve default offset 1
ENDIF

        push    bc
        ld      a, $80
dzx2nb_literals:
        call    dzx2nb_elias            ; obtain length
        lddr                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx2nb_new_offset
dzx2nb_reuse:
        call    dzx2nb_elias            ; obtain length
dzx2nb_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
        lddr                            ; copy from offset
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx2nb_literals
dzx2nb_new_offset:
        pop     bc                      ; discard last offset
        ld      c, (hl)                 ; obtain offset LSB
        dec     hl
        inc     c
        ret     z                       ; check end marker
        push    bc                      ; preserve new offset

IF DEFINED_ZX2_X_SKIP_INCREMENT
        jr      dzx2nb_reuse
ELSE
        call    dzx2nb_elias            ; obtain length
        inc     bc
        jr      dzx2nb_copy
ENDIF

dzx2nb_elias:
        ld      c, 1                    ; interlaced Elias gamma coding
dzx2nb_elias_loop:
        add     a, a
        jr      nz, dzx2nb_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
dzx2nb_elias_skip:
        ret     nc
        add     a, a
        rl      c

IF DEFINED_ZX2_Y_LIMIT_LENGTH
ELSE
        rl      b
ENDIF

        jr      dzx2nb_elias_loop
; -----------------------------------------------------------------------------
