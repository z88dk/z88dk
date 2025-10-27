
; int b_array_at(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_at_callee

EXTERN asm_b_array_at

b_array_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_b_array_at

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_at_callee
defc _b_array_at_callee = b_array_at_callee
ENDIF

