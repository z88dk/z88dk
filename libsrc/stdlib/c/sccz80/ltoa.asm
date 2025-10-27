
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ltoa

EXTERN asm_ltoa

ltoa:

   pop af
   pop bc   ;radix
   exx
   pop bc   ;buf
   exx
   pop hl   ;num
   pop de
   
   push de
   push hl
   push hl
   push bc
   push af

   exx
   push bc
   exx
   ex (sp),ix
   call asm_ltoa
   pop ix
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ltoa
defc _ltoa = ltoa
ENDIF

