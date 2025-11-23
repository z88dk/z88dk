; void __FASTCALL__ *malloc(unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC malloc
PUBLIC _malloc
PUBLIC ___malloc
PUBLIC malloc_fastcall
PUBLIC _malloc_fastcall

EXTERN asm_HeapAlloc
EXTERN _heap

.malloc
._malloc
.___malloc
   pop bc
   pop hl
   push hl
   push bc

.malloc_fastcall
._malloc_fastcall

   ld c,l
   ld b,h
   ld hl,_heap

   jp asm_HeapAlloc
