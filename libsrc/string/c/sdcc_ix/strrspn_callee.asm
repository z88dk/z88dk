
; size_t strrspn_callee(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC _strrspn_callee

EXTERN asm_strrspn

_strrspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strrspn
