
; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strspn_callee

EXTERN asm_strspn

strspn_callee:
IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
ELSE
   pop hl
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_strspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strspn_callee
defc _strspn_callee = strspn_callee
ENDIF

