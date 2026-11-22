; void tm_from_dostm(struct tm *,struct dos_tm *)

SECTION code_time

PUBLIC _tm_from_dostm

EXTERN asm_tm_from_dostm

_tm_from_dostm:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_tm_from_dostm
