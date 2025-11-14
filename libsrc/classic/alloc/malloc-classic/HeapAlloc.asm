; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapAlloc
PUBLIC _HeapAlloc

EXTERN HeapAlloc_callee
EXTERN asm_HeapAlloc


.HeapAlloc
._HeapAlloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp asm_HeapAlloc

