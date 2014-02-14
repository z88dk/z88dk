
; void *memalign(size_t alignment, size_t size)

XLIB memalign

LIB asm_memalign

memalign:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_memalign
