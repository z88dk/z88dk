; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapSbrk
PUBLIC _HeapSbrk

EXTERN asm_HeapSbrk

.HeapSbrk
._HeapSbrk

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp asm_HeapSbrk
