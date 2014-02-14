
; void *realloc(void *p, size_t size)

XLIB realloc

LIB asm_realloc

realloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_realloc
