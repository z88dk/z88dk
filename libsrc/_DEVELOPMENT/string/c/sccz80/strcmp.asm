
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp

EXTERN asm_strcmp

strcmp:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
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
PUBLIC _strcmp
defc _strcmp = strcmp
ENDIF

