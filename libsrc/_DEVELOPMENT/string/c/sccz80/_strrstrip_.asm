
; char *_strrstrip_(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strrstrip_

EXTERN asm__strrstrip

defc _strrstrip_ = asm__strrstrip

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __strrstrip_
defc __strrstrip_ = _strrstrip_
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ____strrstrip_
defc ____strrstrip_ = _strrstrip_
ENDIF

