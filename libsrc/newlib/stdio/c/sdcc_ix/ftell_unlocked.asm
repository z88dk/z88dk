
; unsigned long ftell_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftell_unlocked

EXTERN _ftell_unlocked_fastcall

_ftell_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _ftell_unlocked_fastcall
