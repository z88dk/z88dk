
; void *memalign_unlocked(size_t alignment, size_t size)

XLIB memalign_unlocked

LIB asm_memalign_unlocked

memalign_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_memalign_unlocked
