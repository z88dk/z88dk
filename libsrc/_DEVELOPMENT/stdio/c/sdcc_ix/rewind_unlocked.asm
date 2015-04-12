
; void rewind_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _rewind_unlocked

EXTERN _rewind_unlocked_fastcall

_rewind_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _rewind_unlocked_fastcall
