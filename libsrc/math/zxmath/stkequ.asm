;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: stkequ.asm,v 1.6 2016-06-22 19:59:18 dom Exp $
;
; Equalise the ZX FP stack and put the calculated value into FA
; the "real" stack has been already fixed in fsetup.
;

                SECTION  code_fp
		PUBLIC	stkequ

		EXTERN	fa

IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF


.stkequ

	; These three lines are for the ZX Spectrum only:
	; if integer, then force the conversion to float.
	; HL is updated by the ROM.


	rst	ZXFP_BEGIN_CALC

IF FORzx
	defb	ZXFP_RE_STACK
ENDIF

	defb	ZXFP_END_CALC		; Now HL points to the float on the FP stack

	
	; Copy in "fa" the result

	ld	(ZXFP_STK_PTR),hl	;update the FP stack pointer (equalise)
	
	ld	de,fa+5
	ld	b,5
.bloop2
	ld	a,(hl)
	ld	(de),a
	inc	hl
	dec	de
	djnz	bloop2
	ret
