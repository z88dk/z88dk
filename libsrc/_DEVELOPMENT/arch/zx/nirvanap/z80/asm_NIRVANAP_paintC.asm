; ----------------------------------------------------------------
; Z88DK LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; Paint specified 8x8 block with a sequence of 4 attribute values (in 211T)
;
; Params:
;     BC = attributes address
;     D = pixel line (16-192, even values only)
;     E = char column (0-31)
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_paintC

EXTERN __NIRVANAP_deltas, __NIRVANAP_attribs

asm_NIRVANAP_paintC:

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

; update attributes
        ld      de, 82

        ld      a, (bc)
        ld      (hl), a
        inc     bc
        add     hl, de

        ld      a, (bc)
        ld      (hl), a
        inc     bc
        add     hl, de

        ld      a, (bc)
        ld      (hl), a
        inc     bc
        add     hl, de
		  
        ld      a, (bc)
        ld      (hl), a
        ret
