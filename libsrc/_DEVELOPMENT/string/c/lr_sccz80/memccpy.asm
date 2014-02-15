
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

XLIB memccpy

LIB asm_memccpy

memccpy:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   
   push de
   push hl
   push ix
   push bc
   push af
   
   ld a,ixl
   jp asm_memccpy
