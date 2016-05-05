; int ffsll(long long i)

SECTION code_clib
SECTION code_string

PUBLIC _ffsll_callee

EXTERN asm_ffsll

_ffsll_callee:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   exx
   push af
   
   jp asm_ffsll
