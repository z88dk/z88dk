
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn

EXTERN asm_strrcspn

strrcspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strrcspn
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrcspn
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrcspn
defc _strrcspn = strrcspn
ENDIF

