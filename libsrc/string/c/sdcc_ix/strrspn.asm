
; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC _strrspn

EXTERN asm_strrspn

_strrspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strrspn
