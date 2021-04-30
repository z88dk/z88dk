; void __CALLEE__ sbrk_callee(void *addr, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC sbrk_callee
PUBLIC _sbrk_callee
PUBLIC asm_sbrk

EXTERN asm_HeapSbrk
EXTERN _heap

.sbrk_callee
._sbrk_callee

   pop hl
   pop bc
   ex (sp),hl

.asm_sbrk
   
   ; bc = size of block in bytes >- 4
   ; hl = address of block
   
   ld de,_heap
   jp asm_HeapSbrk

