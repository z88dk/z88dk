;
;	written by Waleed Hasan
;
;	$Id;$

	PUBLIC	DsSetPixel
   PUBLIC   _DsSetPixel
	EXTERN	setpix


.DsSetPixel
._DsSetPixel
	pop	bc		;ret addr.
	pop	hl		;y
	ld	e,l		; e=y
	pop	hl		;x
	ld	d,l		; d=x

	push	bc
	push	bc
	push	bc
	
	jp	setpix

