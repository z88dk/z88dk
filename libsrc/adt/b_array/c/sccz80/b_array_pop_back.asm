
; int b_array_pop_back(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_pop_back

EXTERN asm_b_array_pop_back

defc b_array_pop_back = asm_b_array_pop_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_pop_back
defc _b_array_pop_back = b_array_pop_back
ENDIF

