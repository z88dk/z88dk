
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ltoa_callee

EXTERN asm_ltoa

ltoa_callee:

   pop af
   pop bc   ;radix
   exx
   pop bc   ;buf
   exx 
   pop hl   ;num
   pop de
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
PUBLIC _ltoa_callee
defc _ltoa_callee = ltoa_callee
ENDIF

