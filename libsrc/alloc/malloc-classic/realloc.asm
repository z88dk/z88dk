; CALLER linkage for function pointers

SECTION code_clib
PUBLIC realloc
PUBLIC _realloc

EXTERN asm_realloc

.realloc
._realloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp asm_realloc
