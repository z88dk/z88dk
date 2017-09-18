
; void *b_array_data(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_data

EXTERN asm_b_array_data

defc b_array_data = asm_b_array_data

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_data
defc _b_array_data = b_array_data
ENDIF

