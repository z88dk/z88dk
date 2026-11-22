
; int w_vector_reserve(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_reserve_callee

EXTERN asm_w_vector_reserve

w_vector_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_w_vector_reserve

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _w_vector_reserve_callee
defc _w_vector_reserve_callee = w_vector_reserve_callee
ENDIF

