
; size_t b_array_size(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_size

EXTERN asm_b_array_size

defc b_array_size = asm_b_array_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_size
defc _b_array_size = b_array_size
ENDIF

