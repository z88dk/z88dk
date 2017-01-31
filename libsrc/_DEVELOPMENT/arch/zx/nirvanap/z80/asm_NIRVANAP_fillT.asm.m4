include(`z88dk.m4')

; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; Fill specified tile position with attribute value (in 502T)
;
; Params:
;     A = attribute value (0-255)
;     D = pixel line (0-200, even values only)
;     E = char column (0-30)
;
; WARNING: Computer will crash if an interrupt occurs during execution!
; ----------------------------------------------------------------

SECTION smc_clib
SECTION smc_nirvanap

PUBLIC asm_NIRVANAP_fillT

EXTERN __NIRVANAP_attribs, __NIRVANAP_deltas

asm_NIRVANAP_fillT:

; preserve stack pointer
        ld      (exit_fill+1), sp

; calculate first routine attribute address
        ld      hl, __NIRVANAP_attribs
        ld      b, 0
        ld      c, d                    ; pixel line
        add     hl, bc
        ld      sp, hl

        ld      h, __NIRVANAP_deltas/256
        ld      l, e                    ; char column
        inc     l
        ld      c, (hl)                 ; BC = 1st delta (column offset)
        inc     l
        ld      l, (hl)                 ; HL = 2nd delta (column offset)
        ld      h, b
        sbc     hl, bc
        ex      de, hl                  ; DE = difference between column offsets

; update attribute addresses to specified value
z88dk_for(`LOOP', `1', `8', 
`
        pop     hl
        add     hl, bc
        ld      (hl), a
        add     hl, de
        ld      (hl), a
')

exit_fill:
; restore stack pointer
        ld      sp, 0
        ret
