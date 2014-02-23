
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

XLIB fgetpos_unlocked

LIB asm_fgetpos_unlocked

fgetpos_unlocked:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   jp asm_fgetpos_unlocked
