
; char *strchrnul(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchrnul_callee

EXTERN asm_strchrnul

strchrnul_callee:

IF __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   push de
ELSE
   pop hl
   pop bc
   ex (sp),hl
ENDIF
   
   jp asm_strchrnul

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchrnul_callee
defc _strchrnul_callee = strchrnul_callee
ENDIF

