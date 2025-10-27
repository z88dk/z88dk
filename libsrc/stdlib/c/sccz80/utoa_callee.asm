
; char *utoa(unsigned int num, char *buf, int radix)

IF !__CPU_INTEL__ && !__CPU_GBZ80__

SECTION code_clib
SECTION code_stdlib

PUBLIC utoa_callee

EXTERN asm_utoa

utoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   push ix   
   call asm_utoa
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _utoa_callee
defc _utoa_callee = utoa_callee
ENDIF

ENDIF
