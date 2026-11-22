
; size_t balloc_blockcount(unsigned char queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_blockcount

EXTERN asm_balloc_blockcount

defc balloc_blockcount = asm_balloc_blockcount

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_blockcount
defc _balloc_blockcount = balloc_blockcount
ENDIF

