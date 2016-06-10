;
;	ZX Spectrum specific routines
;
;	int zx_interface1();
;
;	The result is:
;	- 0 (false) if the ZX Interface1 is missing
;	- 1 (true) if the ZX Interface1 is connected
;
;	This function has the side of loading the Interface 1
;	system variables if they aren't already present.
;
;	Shouldn't conflict with other interfaces.
;
;	$Id: zx_interface1.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_interface1
	PUBLIC	_zx_interface1
	EXTERN	if1_installed
	
zx_interface1:
_zx_interface1:
	ld	bc,($5c3d)
	push	bc		; save original ERR_SP
	ld	bc,return
	push	bc
	ld	($5c3d),sp	; update error handling routine

	rst	$28		; load zero to floating point stack
	defb	$a0		; stk-zero
	defb	$38		; end-calc

	call	$16e5		; CLOSE	#0 (this will force IF1 to activate system variables)

	pop	bc

return:
	pop	bc
	ld	(iy+0),255	; reset ERR_NR

;	bit	0,(iy+124)	; test FLAGS3: coming from paged ROM ?
;	jr	nz,stderr
;	ld	(iy+124),0	; yes, reset FLAGS3
;stderr:

	ld	($5c3d),bc	; restore orginal ERR_SP

	jp	if1_installed
