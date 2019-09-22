
; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strrchr_callee

EXTERN asm_strrchr

strrchr_callee:
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
   
   jp asm_strrchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrchr_callee
defc _strrchr_callee = strrchr_callee
ENDIF

