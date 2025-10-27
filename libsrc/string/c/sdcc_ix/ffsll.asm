; int ffsll(long long i)

SECTION code_clib
SECTION code_string

PUBLIC _ffsll

EXTERN asm_ffsll

_ffsll:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push de
   push hl
   push af
   
   jp asm_ffsll
