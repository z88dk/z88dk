
; char *_strrstrip__fastcall(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC __strrstrip__fastcall

EXTERN asm__strrstrip

defc __strrstrip__fastcall = asm__strrstrip
