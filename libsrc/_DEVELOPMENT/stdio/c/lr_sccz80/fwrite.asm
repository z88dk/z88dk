
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

XLIB fwrite

LIB asm_fwrite

fwrite:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push ix
   push af
   
   jp asm_fwrite
