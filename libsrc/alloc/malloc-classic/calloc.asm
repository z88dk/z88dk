; CALLEE linkage for function pointers

SECTION code_clib
PUBLIC calloc
PUBLIC _calloc

EXTERN asm_HeapCalloc
EXTERN _heap

.calloc
._calloc

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   ld bc,_heap
   jp asm_HeapCalloc
