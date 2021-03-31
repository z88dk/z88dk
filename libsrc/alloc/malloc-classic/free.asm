; void __FASTCALL__ free(void *addr)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC free
PUBLIC _free

EXTERN asm_HeapFree
EXTERN _heap

.free
._free

   ld de,_heap
   jp asm_HeapFree
