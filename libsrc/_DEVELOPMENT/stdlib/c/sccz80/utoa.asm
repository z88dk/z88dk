
; char *utoa(unsigned int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC utoa

EXTERN asm_utoa

utoa:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_utoa

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _utoa
defc _utoa = utoa
ENDIF

