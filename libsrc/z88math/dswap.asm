;
;       Z88dk Z88 Maths Library
;
;
;       $Id: dswap.asm,v 1.1 2002-01-21 20:36:07 dom Exp $


		XLIB	dswap

		LIB	fsetup
		LIB	stkequ2

; Swaps FA for that on top of stack

.dswap
	call	fsetup	;deDEB = FA hlHLC = stacked (caps = this set)
	call	stkequ2	;place hlHLC in FA, return with alternate set
	ld	ix,2
	add	ix,sp
;	ld	(ix+0),0	;probably unnecessary
	ld	(ix+1),e
	ld	(ix+2),d
	exx		;go to main set
	ld	(ix+3),e
	ld	(ix+4),d
	ld	(ix+5),b
	ret

