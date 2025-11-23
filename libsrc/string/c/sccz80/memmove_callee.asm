
; void *memmove(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memmove_callee

EXTERN asm_memmove

memmove_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_memmove

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memmove_callee
defc _memmove_callee = memmove_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___memmove_callee
defc ___memmove_callee = memmove_callee
ENDIF

