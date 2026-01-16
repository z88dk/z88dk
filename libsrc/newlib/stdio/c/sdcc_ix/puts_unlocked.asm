
; int puts_unlocked(const char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _puts_unlocked

EXTERN _puts_unlocked_fastcall

_puts_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _puts_unlocked_fastcall
