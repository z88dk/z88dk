
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn_callee

EXTERN asm_strrcspn

strrcspn_callee:

IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
   call asm_strrcspn
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop de
   ex (sp),hl
   jp asm_strrcspn
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrcspn_callee
defc _strrcspn_callee = strrcspn_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrcspn_callee
defc ___strrcspn_callee = strrcspn_callee
ENDIF

