;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
; 	This routine tries to query the Opus ROM to fetch its version
;	It gives a float containg the version, otherwise a float containing zero.. 
;
;	$Id: opus_version.asm,v 1.6 2017-01-03 01:40:06 aralbrec Exp $
;

		SECTION code_clib
		PUBLIC	opus_version
      PUBLIC   _opus_version
		EXTERN	zx_opus
		EXTERN	fa

		INCLUDE  "zxfp.def"

.opus_version
._opus_version
		ld	hl,fa
		ld	b,6
.zeroloop	
		ld	(hl),0		; put zero in float result
		inc	hl
		djnz	zeroloop

		call	zx_opus
		ret	z		; It is much more sable, now !!

		ld	bc,($5c3d)
		push	hl			; save the existing ERR_SP
		ld	hl,opus_error
		push	hl			; stack error-handler return address

		rst	8
		defb	$fd			; Hook code for "OPUS Version"
		;;pop	hl			; if we get here, some other hardware is present
						; it should never happen, so we save one byte

.opus_error				; we should always get here !
		ld	(iy+0),255		; reset ERR_NR

		pop	hl
		ld	($5c3d),hl	; restore orginal ERR_SP

		rst	ZXFP_BEGIN_CALC
		;;defb	ZXFP_RE_STACK
		defb	ZXFP_END_CALC

	; Copy in "fa" the result

		ld	(ZXFP_STK_PTR),hl	;update the FP stack pointer (equalise)
		
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

		ret
