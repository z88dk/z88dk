
; FILE *fopen_unlocked(const char *filename, const char *mode)

XLIB fopen_unlocked

LIB asm_fopen_unlocked

fopen_unlocked:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fopen_unlocked
