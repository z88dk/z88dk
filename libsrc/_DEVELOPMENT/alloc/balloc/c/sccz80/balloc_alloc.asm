
; void *balloc_alloc(unsigned char queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_alloc

EXTERN asm_balloc_alloc

defc balloc_alloc = asm_balloc_alloc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_alloc
defc _balloc_alloc = balloc_alloc
ENDIF

