
; char *utoa(unsigned int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC utoa_callee

EXTERN asm_utoa

utoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_utoa

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _utoa_callee
defc _utoa_callee = utoa_callee
ENDIF

