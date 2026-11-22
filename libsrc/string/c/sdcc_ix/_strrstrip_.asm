
; char *_strrstrip_(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC __strrstrip_

EXTERN asm__strrstrip

__strrstrip_:

   pop af
   pop hl
   
   push hl
   push af

   jp asm__strrstrip
