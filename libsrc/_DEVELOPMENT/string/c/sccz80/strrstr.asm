; char *strrstr(const char *s, const char *w)

SECTION code_clib
SECTION code_string

PUBLIC strrstr

EXTERN asm_strrstr

strrstr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_strrstr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrstr
defc _strrstr = strrstr
ENDIF
