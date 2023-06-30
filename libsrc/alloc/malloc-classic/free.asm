; void __FASTCALL__ free(void *addr)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC free
PUBLIC _free
PUBLIC ___free
PUBLIC free_fastcall
PUBLIC _free_fastcall

EXTERN asm_HeapFree
EXTERN _heap

.free
._free
.___free
   pop de
   pop hl
   push hl
   push de

.free_fastcall
._free_fastcall

   ld de,_heap
   jp asm_HeapFree
