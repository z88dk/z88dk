
; char *utoa(unsigned int num, char *buf, int radix)

IF !__CPU_INTEL__ && !__CPU_GBZ80__

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
   push ix 
   call asm_utoa
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _utoa
defc _utoa = utoa
ENDIF

ENDIF

