;
;       Small C+ Runtime Library
;
;       Random number generator for seed
;	generic version, 
;
;       void randomize() - randomize the seed for rand()
;
; -----
; $Id: randomize.asm,v 1.7 2016-05-17 21:43:06 dom Exp $

SECTION code_clib
PUBLIC randomize
PUBLIC _randomize
EXTERN __stdseed
EXTERN cleanup

; you must declare an integer named "__stdseed" in your
; main.c file to hold the seed.
;
; int __stdseed;

.randomize
._randomize

   ld	hl,0
   add	hl,sp
   call	agarble
   ld	e,a
   
   ld	hl,cleanup	; we fall into the CRT0 stub
   ld	bc,1024
   sbc	hl,bc
   call	agarble
   
   ld	h,a

IF FORrcmx000
   ld	a,eir
ELSE
   ld	a,r
ENDIF

   xor	e
   ld	l,a
   
   ld (__stdseed),hl
   ret


.agarble
   ld	bc,$FF04
.sloop
   add	(hl)
   inc	hl
   djnz sloop
   dec	c
   jr	nz,sloop
   ret
