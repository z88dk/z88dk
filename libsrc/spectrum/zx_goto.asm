;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
;	int zx_goto(int line);
;
;	Jumps to a BASIC program line.
;	Returns on error or if program is finished correctly.
;	The STOP statement can be used as a sort of "RETURN" command.
;	In that case, to handle errors, consider that its error code is #9.
;
;	NOTE: The Interface 1 (and probably other interfaces too) stops the
;	      program on any error trapped directly by the shadow ROM,
;	      including the infamous "program finished";
;	      to solve this you need to put a BASIC line like:
;		 9999 REM 
;		 or 
;		 9999 STOP
;
;	$Id: zx_goto.asm,v 1.2 2006-07-12 20:05:47 stefano Exp $
;

	XLIB	zx_goto
	
zx_goto:
		pop	bc
		pop	hl
		push	hl		; line #
		push	bc		; ret address

		ld	bc,($5c3d)
		push	bc		; save original ERR_SP

		ld	bc,return
		push	bc
		ld	($5c3d),sp	; update error handling routine

		ld	($5c6e),hl	; BASIC line number
		xor	a
		ld	($5c44),a	; Position within line
		
		call	$1b9e		; Enter BASIC

		pop	bc
		ld	hl,0
		jr	exitgoto
		
return:		
		ld	h,0
		ld	l,(iy+0)	; error code (hope so !)
		ld	(iy+0),255	; reset ERR_NR
		inc	hl

exitgoto:	pop	bc
		ld	($5c3d),bc	; restore orginal ERR_SP
		
		ret
