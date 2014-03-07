
; FILE *open_memstream(char **bufp, size_t *sizep)

XLIB open_memstream

LIB asm_open_memstream

open_memstream:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_open_memstream
