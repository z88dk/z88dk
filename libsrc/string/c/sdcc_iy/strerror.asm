
; char *strerror(int errnum)

SECTION code_clib
SECTION code_string

PUBLIC _strerror

EXTERN asm_strerror

_strerror:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_strerror
