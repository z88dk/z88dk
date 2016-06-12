;
;	Read character from console - don't wait
;
;
;	int getk()
;
;	djm 17/4/2000

;	On an nc100 we have to test for "yellow"

;
;	$Id: getk.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

	EXTERN	cleanup		;in crt0

.getk
._getk
	call	$B9B3	;kmreadchar
	ld	hl,0
	ret	nc	;no key pressed
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



