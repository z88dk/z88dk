;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
; 	This routine tries to query the Opus ROM to fetch its version
;	It gives a float containg the version, otherwise a float containing zero.. 
;
;	With many of the other existing disk interfaces this test crashes.
;
;	$Id: opus_version.asm,v 1.1 2007-10-04 12:18:57 stefano Exp $
;

		XLIB	opus_version

		XREF	fa

		INCLUDE  "#zxfp.def"
	
.opus_version
		ld	bc,($5c3d)
		push	bc		; save original ERR_SP

		ld	bc,return
		push	bc
		ld	($5c3d),sp	; update error handling routine


		ld	bc,8
		call	ZXFP_STACK_BC
		
		rst	ZXFP_BEGIN_CALC	; Do the string conversion !
		defb	ZXFP_USR_NO
		defb	$FD		; Hook code for "OPUS Version"
		defb	ZXFP_DELETE
		defb	ZXFP_RE_STACK
		defb	ZXFP_END_CALC
		
		; Copy in "fa" the result

		ld	a,(hl)		;exponent
		ld	de,fa+5
		ld	(de),a
		inc	hl
		dec	de
		
		ld	b,4
.bloop2
		ld	a,(hl)
		ld	(de),a
		inc	hl
		dec	de
		djnz	bloop2
		
		pop	bc
		jr	exitgoto
		
.return		
		ld	(iy+0),255	; reset ERR_NR

.exitgoto	pop	bc
		ld	($5c3d),bc	; restore orginal ERR_SP

		ret

