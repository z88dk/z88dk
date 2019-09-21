
; char* strset(char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strset_callee

EXTERN asm_strset

strset_callee:

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
   
   jp asm_strset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strset_callee
defc _strset_callee = strset_callee
ENDIF

