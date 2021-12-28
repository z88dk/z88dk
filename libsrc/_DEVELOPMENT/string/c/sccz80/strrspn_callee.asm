
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
   call asm_strrspn
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop de
   ex (sp),hl
   jp asm_strrspn
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrspn_callee
defc _strrspn_callee = strrspn_callee
ENDIF

