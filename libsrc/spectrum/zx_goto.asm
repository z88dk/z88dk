;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
;	int zx_goto(int line);
;
;	Jumps to a BASIC program line.
;	Returns on error or if program is finished correctly.
;
;	NOTE: errors occurred in shadow memory (microdrive, etc.) 
;	      normally stop the program execution.
;	      The STOP statement returns error code #9: it can be
;	      used as a sort of "RETURN" command.
;	      This command dirties the "current line" BASIC variables,
;	      so it is strongly suggested to end the subrutines
;	      forcing a STOP or generating other sort of errors.
;
;	$Id: zx_goto.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_goto
	
zx_goto:
		pop	bc
		pop	hl
		push	hl		; line #
		push	bc		; address

		ld	bc,($5c3d)
		push	bc		; save original ERR_SP
		ld	bc,return
		push	bc
		ld	($5c3d),sp	; update error handling routine

		ld	d,0		; first statement in line
		call	$1e73		; set up "goto line" parameters
		call	$1bf4		; enter BASIC  .. (gulp !)
		pop	bc
		pop	bc
		ld	($5c3d),bc	; restore orginal ERR_SP
		ld	hl,0
		ret			; gets here if no error
		
return:		pop	bc
		ld	($5c3d),bc	; restore orginal ERR_SP
		ld	h,0
		ld	l,(iy+0)	; error code (hope so !)
		ld	(iy+0),255	; reset ERR_NR
		inc	hl
		
		ret
