
; size_t strcspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcspn_callee

EXTERN asm_strcspn

strcspn_callee:

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
   
   jp asm_strcspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcspn_callee
defc _strcspn_callee = strcspn_callee
ENDIF

