
; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strpbrk_callee

EXTERN asm_strpbrk

strpbrk_callee:

IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
   call asm_strpbrk
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop de
   ex (sp),hl
   jp asm_strpbrk
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strpbrk_callee
defc _strpbrk_callee = strpbrk_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strpbrk_callee
defc ___strpbrk_callee = strpbrk_callee
ENDIF

