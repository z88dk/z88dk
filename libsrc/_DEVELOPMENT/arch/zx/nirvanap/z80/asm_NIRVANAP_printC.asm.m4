include(`z88dk.m4')

; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; Print a 8x8 character at specified position, afterwards paint it with a
; provided sequence of 4 attribute values (in 617T+10 for positions matching
; standard character rows, in 646T+10 otherwise)
;
; Params:
;     A = character code (0-255)
;     BC = attributes address
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_printC

EXTERN asm_NIRVANAP_paintC
EXTERN __NIRVANAP_bitmaps, __NIRVANAP_CHAR_TABLE

asm_NIRVANAP_printC:

; preserve paintC parameters
        push    de
        push    bc

; calculate initial screen bitmap address
        ld      h, __NIRVANAP_bitmaps/256
        ld      l, d
        ld      d, (hl)
        inc     l
        ld      h, (hl)
        ld      l, d
        ld      d, 0
        add     hl, de
        ex      de, hl

; calculate initial character address
        ld      l, a
        add     hl, hl
        add     hl, hl
        add     hl, hl
        ld      bc, __NIRVANAP_CHAR_TABLE
        add     hl, bc

; draw bitmap lines

z88dk_for(`LOOP', `1', `3', 
`
        ld      a, (hl)
        ld      (de), a
        inc     hl
        inc     d

        ld      a, (hl)
        ld      (de), a
        inc     hl
        inc     d

        ld      a, d
        and     7
        jr      nz, ASMPC+11
        ld      a, e
        sub     -32
        ld      e, a
        sbc     a, a
        and     -8
        add     a, d
        ld      d, a
')

        ld      a, (hl)
        ld      (de), a
        inc     hl
        inc     d
        ld      a, (hl)
        ld      (de), a

; restore paintC parameters
        pop     bc
        pop     de
		  
		  jp asm_NIRVANAP_paintC
