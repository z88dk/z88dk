
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

XLIB aligned_alloc_unlocked

LIB asm_aligned_alloc_unlocked

aligned_alloc_unlocked:

   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   
   jp asm_aligned_alloc_unlocked
