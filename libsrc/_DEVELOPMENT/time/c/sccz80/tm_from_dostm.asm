; void tm_from_dostm(struct tm *,struct dos_tm *)

SECTION code_time

PUBLIC tm_from_dostm

EXTERN asm_tm_from_dostm

tm_from_dostm:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_tm_from_dostm

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tm_from_dostm
defc _tm_from_dostm = tm_from_dostm
ENDIF

