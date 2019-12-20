; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC strrstr

EXTERN asm_strrstr

strrstr:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strrstr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrstr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrstr
defc _strrstr = strrstr
ENDIF
