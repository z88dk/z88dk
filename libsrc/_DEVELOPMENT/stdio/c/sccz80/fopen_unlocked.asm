
; FILE *fopen_unlocked(const char *filename, const char *mode)

PUBLIC fopen_unlocked

EXTERN asm_fopen_unlocked

fopen_unlocked:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fopen_unlocked
