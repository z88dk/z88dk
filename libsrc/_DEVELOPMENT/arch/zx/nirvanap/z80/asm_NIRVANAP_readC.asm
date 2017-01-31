; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; Retrieve a sequence of 4 attribute values from specified 8x8 block (in 211T)
;
; Params:
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
;     BC = attributes address
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_readC

EXTERN __NIRVANAP_deltas, __NIRVANAP_attribs

asm_NIRVANAP_readC:

; calculate initial routine attribute address
        ld      h, 0
        ld      l, d
        ld      d, __NIRVANAP_deltas/256
        inc     e
        ld      a, (de)
        ld      de, __NIRVANAP_attribs
        add     hl, de
        add     a, (hl)
        ld      e, a
        inc     l
        adc     a, (hl)
        sub     e
        ld      d, a
        ex      de, hl

; read attributes
        ld      de, 82

        ld      a, (hl)
        ld      (bc), a
        inc     bc
        add     hl, de

        ld      a, (hl)
        ld      (bc), a
        inc     bc
        add     hl, de

        ld      a, (hl)
        ld      (bc), a
        inc     bc
        add     hl, de

        ld      a, (hl)
        ld      (bc), a
        ret
