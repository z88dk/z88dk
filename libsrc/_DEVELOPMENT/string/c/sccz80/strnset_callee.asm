
; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnset_callee

EXTERN asm_strnset

strnset_callee:

IF __CPU_GBZ80__
   pop af
   pop bc
   pop de
   pop hl
   push af
ELSE
   pop hl
   pop bc
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_strnset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnset_callee
defc _strnset_callee = strnset_callee
ENDIF

