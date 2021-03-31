; void __FASTCALL__ *malloc(unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC malloc
PUBLIC _malloc

EXTERN asm_HeapAlloc
EXTERN _heap

.malloc
._malloc

   ld c,l
   ld b,h
   ld hl,_heap

   jp asm_HeapAlloc
