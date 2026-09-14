
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_dconst_1

   ; set DEHL = 1.0 (IEEE single, consumed by asm_dadd)
   ;
   ; uses : af, de, hl

.asm_dconst_1
    ld de,$3f80
    ld hl,$0000
    ret
