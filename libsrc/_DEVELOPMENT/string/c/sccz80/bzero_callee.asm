
; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC bzero_callee

EXTERN asm_bzero

bzero_callee:

IF __CPU_GBZ80__
   pop de	;ret
   pop bc
   pop hl
   push de

ELSE
   pop hl
   pop bc
   ex (sp),hl
ENDIF

   jp asm_bzero

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bzero_callee
defc _bzero_callee = bzero_callee
ENDIF

