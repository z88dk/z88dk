
; char *itoa(int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC itoa_callee

EXTERN asm_itoa

itoa_callee:
IF __CPU_GBZ80__
   pop af	;return
   pop bc	;radix
   pop de	;buf
   pop hl	;num
   push af
ELSE
   pop hl
   pop bc
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_itoa

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _itoa_callee
defc _itoa_callee = itoa_callee
ENDIF

