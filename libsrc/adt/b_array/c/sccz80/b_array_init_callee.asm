
; b_array_t *b_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_init_callee

EXTERN asm_b_array_init

b_array_init_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_b_array_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _b_array_init_callee
defc _b_array_init_callee = b_array_init_callee
ENDIF

