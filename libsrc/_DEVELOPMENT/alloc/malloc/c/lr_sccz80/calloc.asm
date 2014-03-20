
; void *calloc(size_t nmemb, size_t size)

XLIB calloc

LIB asm_calloc

calloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_calloc
