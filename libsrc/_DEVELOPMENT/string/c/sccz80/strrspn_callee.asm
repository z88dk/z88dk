
; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrspn_callee

EXTERN asm_strrspn

strrspn_callee:

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
   
   jp asm_strrspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrspn_callee
defc _strrspn_callee = strrspn_callee
ENDIF

