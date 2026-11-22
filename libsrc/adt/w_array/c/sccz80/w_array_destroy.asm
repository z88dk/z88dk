
; void w_array_destroy(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_destroy

EXTERN asm_w_array_destroy

defc w_array_destroy = asm_w_array_destroy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_destroy
defc _w_array_destroy = w_array_destroy
ENDIF

