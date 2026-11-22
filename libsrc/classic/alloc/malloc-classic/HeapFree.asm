; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapFree
PUBLIC _HeapFree

EXTERN asm_HeapFree

.HeapFree
._HeapFree

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_HeapFree
