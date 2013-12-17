
XLIB HeapAlloc_lr_callee
LIB asm_HeapAlloc

HeapAlloc_lr_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_HeapAlloc
