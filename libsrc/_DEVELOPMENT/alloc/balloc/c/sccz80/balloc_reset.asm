; void *balloc_reset(unsigned char queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_reset

EXTERN asm_balloc_reset

defc balloc_reset = asm_balloc_reset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_reset
defc _balloc_reset = balloc_reset
ENDIF

