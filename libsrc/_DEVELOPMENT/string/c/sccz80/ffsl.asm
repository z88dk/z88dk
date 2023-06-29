
; int ffsl(long i)

SECTION code_clib
SECTION code_string

PUBLIC ffsl

EXTERN asm_ffsl

defc ffsl = asm_ffsl

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ffsl
defc _ffsl = ffsl
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___ffsl
defc ___ffsl = ffsl
ENDIF

