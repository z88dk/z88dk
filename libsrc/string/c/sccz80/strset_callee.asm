
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
   call asm_strset
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop de
   ex (sp),hl
   jp asm_strset
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strset_callee
defc _strset_callee = strset_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strset_callee
defc ___strset_callee = strset_callee
ENDIF

