;
;	Read character from console
;
;
;	int fgetc_cons()
;
;	djm 17/4/2000

;	On an nc100 we have to test for "yellow"

;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	fgetc_cons

		EXTERN	cleanup		;in crt0

.fgetc_cons
	call	$B9B3	;kmreadchar
	jr	nc,fgetc_cons	;no key available...try again
	ld	l,c
	ld	h,b
	ld	a,b
	and	a
	ret	z		;no token
	sub	2
	ret	nz		;not b=2
	ld	a,c
	cp	$FC
	ret	nz		
; We've got here so we have just received escape so check yellow
	push	hl		;keep this in case 
	call	$B8d2	;kmgetyellow
	pop	hl		;get it back
	ret	nc		;no yellow
	jp	cleanup		;was yellow so outta here



