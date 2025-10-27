
; BSD
; int bcmp (const void *b1, const void *b2, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC bcmp_callee

EXTERN memcmp_callee

defc bcmp_callee = memcmp_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bcmp_callee
defc _bcmp_callee = bcmp_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___bcmp_callee
defc ___bcmp_callee = bcmp_callee
ENDIF

