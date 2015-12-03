
; char *_strrstrip_(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strrstrip_

EXTERN asm__strrstrip

defc _strrstrip_ = asm__strrstrip
