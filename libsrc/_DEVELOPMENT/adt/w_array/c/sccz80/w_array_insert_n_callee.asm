
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_insert_n_callee

EXTERN asm_w_array_insert_n

w_array_insert_n_callee:

   pop hl
   pop af
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_w_array_insert_n

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_array_insert_n_callee
defc _w_array_insert_n_callee = w_array_insert_n_callee
ENDIF

