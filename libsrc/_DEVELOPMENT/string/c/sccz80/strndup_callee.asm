
; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strndup_callee

EXTERN asm_strndup

strndup_callee:

IF __CPU_GBZ80__
   pop de
   pop bc
   pop hl
   push de
   call asm_strndup
   ld d,h
   ld e,l
   ret
ELSE
   pop hl
   pop bc
   ex (sp),hl
   jp asm_strndup
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strndup_callee
defc _strndup_callee = strndup_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strndup_callee
defc ___strndup_callee = strndup_callee
ENDIF

