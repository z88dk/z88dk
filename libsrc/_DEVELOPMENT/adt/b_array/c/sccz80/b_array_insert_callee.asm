
; size_t b_array_insert(b_array_t *a, size_t idx, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_insert_callee

EXTERN asm_b_array_insert

b_array_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_array_insert

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_insert_callee
defc _b_array_insert_callee = b_array_insert_callee
ENDIF

