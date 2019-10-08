
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
   call asm_strchrnul
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop bc
   ex (sp),hl
   jp asm_strchrnul
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchrnul_callee
defc _strchrnul_callee = strchrnul_callee
ENDIF

