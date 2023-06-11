
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_load

.asm_load

    ; sccz80 float primitive
    ; Load float pointed to by HL into DEHL
    ;
    ; enter : HL = float* (sccz80_float)
    ;
    ; exit  : DEHL = float (sccz80_float)
    ;
    ; uses  : f, bc, de, hl


    ; sdcc float primitive
    ; Load float pointed to by HL into DEHL
    ;
    ; enter : HL = float* (sdcc_float)
    ;
    ; exit  : DEHL = float (sdcc_float)
    ;
    ; uses  : bc, de, hl

    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)                   ; DEBC = sccz80_float or sdcc_float

    ld hl,bc

    ret                         ; DEHL = sccz80_float or sdcc_float

