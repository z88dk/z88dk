
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn_callee

EXTERN asm_strrcspn

strrcspn_callee:

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
   
   jp asm_strrcspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrcspn_callee
defc _strrcspn_callee = strrcspn_callee
ENDIF

