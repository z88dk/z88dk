; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapCalloc
PUBLIC _HeapCalloc

EXTERN asm_HeapCalloc

.HeapCalloc
._HeapCalloc

   pop af
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
   push af
   
   jp asm_HeapCalloc
