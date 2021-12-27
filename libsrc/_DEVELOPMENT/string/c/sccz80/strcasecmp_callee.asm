
; int strcasecmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcasecmp_callee

EXTERN asm_strcasecmp

strcasecmp_callee:

   pop bc
   pop hl
   pop de
   push bc

IF __CLASSIC && __CPU_GBZ80__
   call asm_strcasecmp
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcasecmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcasecmp_callee
defc _strcasecmp_callee = strcasecmp_callee
ENDIF

