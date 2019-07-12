; 	Z88 Specific Maths Library
;
;	Convert double to string
;
;void ftoa(x,prec,str)
;double x ;              /* number to be converted */
;int prec ;              /* # digits after decimal place */
;char *str ;             /* output string */

                SECTION  code_fp
		PUBLIC	ftoa

IF FORz88
		INCLUDE	"target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

.ftoa
	ld	ix,0
	add	ix,sp

	exx
IF FORz88
	ld	d,2		;Fixed format
	ld	e,(ix+4)	;digits of d.p. may work who knows?
ELSE
	ld	e,2		;fixed format
	ld	d,1		;use format
	push	de
	ld	e,(ix+4)	;digits of d.p., map to zone width
	ld	d,e		;number of digits
	push	de
ENDIF
	ld	l,(ix+6+1)
	ld	h,(ix+6+2)
	exx
	ld	l,(ix+6+3)
	ld	h,(ix+6+4)
	ld	c,(ix+6+5)	;number
	ld	e,(ix+2)	;buffer
	ld	d,(ix+3)
IF FORz88
	fpp(FP_STR)
ELSE
	ld	ix,0
	add	ix,sp
	ld	a,+(FP_STR)
	call	FPP
	xor	a
	ld	(de),a
	pop	af	;discard stack
	pop	af
ENDIF
	ret

	

	

