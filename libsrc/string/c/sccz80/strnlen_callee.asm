
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC strnlen_callee

EXTERN asm_strnlen

strnlen_callee:

IF __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   push de
   call asm_strnlen
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop bc
   ex (sp),hl
   jp asm_strnlen
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnlen_callee
defc _strnlen_callee = strnlen_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strnlen_callee
defc ___strnlen_callee = strnlen_callee
ENDIF

