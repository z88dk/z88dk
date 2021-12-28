
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp_callee

EXTERN asm_strcmp

strcmp_callee:

   pop bc
   pop hl
   pop de
   push bc

IF __CLASSIC && __CPU_GBZ80__
   call asm_strcmp
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcmp_callee
defc _strcmp_callee = strcmp_callee
ENDIF

