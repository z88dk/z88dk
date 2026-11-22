
; void *balloc_firstfit(unsigned char queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_firstfit

EXTERN l0_balloc_firstfit_callee

balloc_firstfit:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   jp l0_balloc_firstfit_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _balloc_firstfit
defc _balloc_firstfit = balloc_firstfit
ENDIF

