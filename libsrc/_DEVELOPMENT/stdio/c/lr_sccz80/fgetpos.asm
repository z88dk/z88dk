
; int fgetpos(FILE *stream, fpos_t *pos)

XLIB fgetpos

LIB asm_fgetpos

fgetpos:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   jp asm_fgetpos
