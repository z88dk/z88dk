
; void *w_array_front(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_front

EXTERN asm_w_array_front

defc w_array_front = asm_w_array_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_front
defc _w_array_front = w_array_front
ENDIF

