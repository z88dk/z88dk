
; char *strchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchr

EXTERN asm_strchr

strchr:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de

IF __CLASSIC && __CPU_GBZ80__
   call asm_strchr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strchr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchr
defc _strchr = strchr
ENDIF

