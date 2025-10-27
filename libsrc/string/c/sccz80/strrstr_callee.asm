; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC strrstr_callee

EXTERN asm_strrstr

strrstr_callee:

IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
   call asm_strrstr
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop de
   ex (sp),hl
   jp asm_strrstr
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrstr_callee
defc _strrstr_callee = strrstr_callee
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrstr_callee
defc ___strrstr_callee = strrstr_callee
ENDIF

