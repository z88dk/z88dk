
; int posix_memalign(void **memptr, size_t alignment, size_t size)

XLIB posix_memalign

LIB asm_posix_memalign

posix_memalign:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_posix_memalign
