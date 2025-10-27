
; char *lltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC lltoa_callee

EXTERN asm_lltoa

lltoa_callee:

   pop af       ;ret
   pop bc       ;radix
   exx
   pop bc       ;buf
   exx
   pop hl       ;num
   pop de       ;num
   exx
   pop hl       ;num
   pop de       ;num
   exx

   
   exx
   push bc
   exx
   ex (sp),ix
   
   call asm_lltoa
   
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _lltoa_callee
defc _lltoa_callee = lltoa_callee
ENDIF
