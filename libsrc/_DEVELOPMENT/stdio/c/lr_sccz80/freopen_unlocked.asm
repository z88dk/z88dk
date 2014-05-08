
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

PUBLIC freopen_unlocked

EXTERN asm_freopen_unlocked

freopen_unlocked:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push ix
   push af
   
   jp asm_freopen_unlocked
