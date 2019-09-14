; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC strrstr_callee

EXTERN asm_strrstr

strrstr_callee:

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
   
   jp asm_strrstr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrstr_callee
defc _strrstr_callee = strrstr_callee
ENDIF
