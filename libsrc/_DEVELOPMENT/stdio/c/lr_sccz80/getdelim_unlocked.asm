
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

XLIB getdelim_unlocked

LIB asm_getdelim_unlocked

getdelim_unlocked:

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push ix
   push af

   jp asm_getdelim_unlocked
