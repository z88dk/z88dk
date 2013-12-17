
XLIB HeapAlloc_rl
LIB asm_HeapAlloc

HeapAlloc_rl:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_HeapAlloc
