
; int fputs_unlocked(const char *s, FILE *stream)

XLIB fputs_unlocked

LIB asm_fputs_unlocked

fputs_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af

   jp asm_fputs_unlocked
