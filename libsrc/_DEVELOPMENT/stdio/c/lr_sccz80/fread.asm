
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)

XLIB fread

LIB asm_fread

fread:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push ix
   push af
   
   jp asm_fread
