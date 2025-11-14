; void __CALLEE__ *realloc_callee(void *p, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC realloc_callee
PUBLIC _realloc_callee
PUBLIC asm_realloc

EXTERN asm_HeapRealloc
EXTERN _heap

.realloc_callee
._realloc_callee

   pop hl
   pop bc
   ex (sp),hl

.asm_realloc

   ; hl = void *p
   ; bc = size
   
   ld de,_heap
   jp asm_HeapRealloc

