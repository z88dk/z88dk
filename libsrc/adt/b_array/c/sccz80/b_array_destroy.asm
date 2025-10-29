
; void b_array_destroy(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_destroy

EXTERN asm_b_array_destroy

defc b_array_destroy = asm_b_array_destroy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_destroy
defc _b_array_destroy = b_array_destroy
ENDIF

