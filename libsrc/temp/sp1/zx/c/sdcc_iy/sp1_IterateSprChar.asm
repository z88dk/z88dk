; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateSprChar

EXTERN asm_sp1_IterateSprChar

_sp1_IterateSprChar:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af

   jp asm_sp1_IterateSprChar
