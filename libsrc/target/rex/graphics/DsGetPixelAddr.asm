;
;	written by Waleed Hasan
;
;	$Id;$

	PUBLIC	DsGetPixelAddr
   PUBLIC   _DsGetPixelAddr
	EXTERN	pixaddr


.DsGetPixelAddr
._DsGetPixelAddr
	pop	de		;ret addr.
	pop	bc		;&bit	
	pop	hl		;y
	ld	a,l		; a=y
	pop	hl		;x
				; l=x
	push	de
	push	de
	push	de
	push	de
	
	ld	d,l		; d=x
	ld	e,a		; e=y
	
	ld	a,l
	and	$07
	
	jp	pixaddr

