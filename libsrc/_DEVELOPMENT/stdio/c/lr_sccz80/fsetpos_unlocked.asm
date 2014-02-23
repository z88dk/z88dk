
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

XLIB fsetpos_unlocked

LIB asm_fsetpos_unlocked

fsetpos_unlocked:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   jp asm_fsetpos_unlocked
