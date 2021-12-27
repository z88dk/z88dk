
; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcoll

EXTERN asm_strcoll

strcoll:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
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
PUBLIC _strcoll
defc _strcoll = strcoll
ENDIF

