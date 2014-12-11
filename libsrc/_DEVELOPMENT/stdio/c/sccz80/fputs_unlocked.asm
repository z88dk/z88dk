
; int fputs_unlocked(const char *s, FILE *stream)

SECTION code_stdio

PUBLIC fputs_unlocked

EXTERN asm_fputs_unlocked

fputs_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af

   jp asm_fputs_unlocked
