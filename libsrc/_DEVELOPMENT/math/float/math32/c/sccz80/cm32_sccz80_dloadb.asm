
SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_dloadb

cm32_sccz80_dloadb:

    ; sccz80 float primitive
    ; Load float given pointer in HL pointing to last byte into DEHL'.
    ;
    ; enter : HL = double * (sccz80 format) + 3 bytes
    ;
    ; exit  : DEHL'= double (math32 format)
    ;         (exx set is swapped)
    ;
    ; uses  : bc, de, hl, bc', de', hl'

    ld d,(hl-)
    ld e,(hl-)
    ld b,(hl-)
    ld l,(hl)
    ld h,b

    exx
    ret
