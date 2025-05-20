
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ultoa_callee

EXTERN asm_ultoa

ultoa_callee:

   pop af
   pop bc
   exx
   pop  bc      ;buf
   exx
   pop hl
   pop de
   push af
   exx
   push bc
   exx   
   ex (sp),ix
   call asm_ultoa
   pop ix
   ret
   
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ultoa_callee
defc _ultoa_callee = ultoa_callee
ENDIF

