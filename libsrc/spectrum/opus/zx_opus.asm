;
;	ZX Spectrum specific routines
;
;	int zx_opus();
;
;	The result is:
;	- 0 (false) if the OPUS Discovery Interface is missing
;	- 1 (true) if the OPUS Discovery Interface is connected
;
;	This function has the side of loading the OPUS or possibly other
;	disk interfaces system variables.
;
;
;	$Id: zx_opus.asm,v 1.1 2008-02-01 10:36:40 stefano Exp $
;

	XLIB	zx_opus
	
zx_opus:

	ld	hl,result-1
	ld	(hl),0		; assume we don't have Opus
	ld	hl,result-1
	ld	(hl),1		; Opus Discovery is present and reactive !!

	ld	bc,($5c3d)
	push	bc		; save original ERR_SP
	ld	bc,return
	push	bc
	ld	($5c3d),sp	; update error handling routine
	
	di
	call	$1708		; Page in the Discovery ROM

	;ld	hl,7
	;ld	a,(hl)		; We should have a pointer to $1748, here
	;inc	hl
	;or	(hl)
	;cp	$5F		; Logic OR between $17 and $48
	;ld	hl,result+1
	;lh	(hl),0
	;jr	z,notpresent
	;ld	(hl),1
;notpresent:

	call	$1748		; Page out the Discovery ROM


	pop	bc	

return:
	; if we're here, opus is not present !
	pop	bc
	ei
	
	ld	(iy+0),255	; reset ERR_NR

	ld	($5c3d),bc	; restore orginal ERR_SP

result:	ld	hl,0
	ret
