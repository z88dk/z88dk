
; int stricmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC stricmp

EXTERN strcasecmp

defc stricmp = strcasecmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stricmp
defc _stricmp = stricmp
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO2(stricmp, s1, s2) -> ___stricmp(s2, s1): HL=s2, DE=s1.
; asm_stricmp = asm_strcasecmp; enter: HL=s2, DE=s1 -- already correct.
IF __CLASSIC
PUBLIC ___stricmp
EXTERN asm_strcasecmp
___stricmp:
   call asm_strcasecmp      ; enter HL=s2, DE=s1; exit A=diff
   ex de,hl                 ; DE = result (C return value, sign-extends in A)
   ret
ENDIF

