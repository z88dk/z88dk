
; void *balloc_firstfit(unsigned char queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_firstfit_callee

EXTERN asm_balloc_firstfit

balloc_firstfit_callee:

   pop hl
	pop de
	ex (sp),hl
	
	ld h,e
   jp asm_balloc_firstfit

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_firstfit_callee
defc _balloc_firstfit_callee = balloc_firstfit_callee
ENDIF

