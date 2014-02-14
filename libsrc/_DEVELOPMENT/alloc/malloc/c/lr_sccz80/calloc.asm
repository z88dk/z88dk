
; void *calloc(size_t nmemb, size_t size)

XLIB calloc

LIB asm_calloc

calloc:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_calloc
