
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ultoa

EXTERN asm_ultoa

ultoa:

   pop af
   pop bc   ;radix
   exx
   pop bc   ;buf
   exx
   pop hl
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
   call asm_ultoa
   pop ix
   ret
   
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ultoa
defc _ultoa = ultoa
ENDIF

