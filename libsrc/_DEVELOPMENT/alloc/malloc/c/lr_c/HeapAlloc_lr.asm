
XLIB HeapAlloc_lr
LIB asm_HeapAlloc

HeapAlloc_lr:

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_HeapAlloc
