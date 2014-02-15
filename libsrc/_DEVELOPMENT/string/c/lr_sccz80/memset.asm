
; void *memset(void *s, int c, size_t n)

XLIB memset

LIB asm_memset

memset:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_memset
