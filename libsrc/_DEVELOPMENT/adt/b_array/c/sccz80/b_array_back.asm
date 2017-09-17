
; int b_array_back(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_back

EXTERN asm_b_array_back

defc b_array_back = asm_b_array_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_back
defc _b_array_back = b_array_back
ENDIF

