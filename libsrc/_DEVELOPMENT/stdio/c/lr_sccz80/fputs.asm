
; int fputs(const char *s, FILE *stream)

XLIB fputs

LIB asm_fputs

fputs:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   jp asm_fputs
