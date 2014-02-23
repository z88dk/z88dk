
; int fsetpos(FILE *stream, const fpos_t *pos)

XLIB fsetpos

LIB asm_fsetpos

fsetpos:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   jp asm_fsetpos

