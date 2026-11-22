
; void *w_array_data(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_data

EXTERN asm_w_array_data

defc w_array_data = asm_w_array_data

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_data
defc _w_array_data = w_array_data
ENDIF

