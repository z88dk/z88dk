
; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strpbrk_callee

EXTERN asm_strpbrk

strpbrk_callee:

IF __CPU_GBZ80__
   pop af
   pop de
   pop hl
   push af
ELSE
   pop hl
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_strpbrk

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strpbrk_callee
defc _strpbrk_callee = strpbrk_callee
ENDIF

