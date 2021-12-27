
; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcoll_callee

EXTERN asm_strcoll

strcoll_callee:

   pop bc
   pop hl
   pop de
   push bc

IF __CLASSIC && __CPU_GBZ80__
   call asm_strcoll
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcoll
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcoll_callee
defc _strcoll_callee = strcoll_callee
ENDIF

