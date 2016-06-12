;
;	Read character from console
;
;
;	int fgetc_cons()
;
;	djm 17/4/2000

;	On an nc100 we have to test for "yellow"

;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

	EXTERN	cleanup		;in crt0

.fgetc_cons
._fgetc_cons
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



