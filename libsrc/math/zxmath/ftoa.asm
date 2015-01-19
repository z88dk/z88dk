;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ftoa.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;
;
;void ftoa(x,prec,str)   -> Convert double to string
;
;double x ;              /* number to be converted */
;int prec ;              /* # digits after decimal place */
;char *str ;             /* output string */
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    ftoa

.ftoa
		ld	hl,2
		add	hl,sp
		ld	e,(hl)		; buffer
		inc	hl
		ld	d,(hl)

		inc	hl
		ld	c,(hl)		; precision
		inc	hl
		ld	b,(hl)

if TINYMODE
		; we cut away the precision handling
ELSE
		push	hl
		push	de
		call	ZXFP_STACK_BC	; put precision on stack
		pop	de
		pop	hl
ENDIF
		
		push	de

		inc	hl
		inc	hl
		ld	b,(hl)		; float
		inc	hl
		ld	c,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	a,(hl)

		bit	7,e
		push	af	; keep sign
		res	7,e

		; load in the FP calculator stack	
		call	ZXFP_STK_STORE

if TINYMODE
		; we cut away the precision handling
ELSE
		rst	ZXFP_BEGIN_CALC	; truncating stuff...
		defb	ZXFP_EXCHANGE

		defb	ZXFP_STK_TEN
		defb	ZXFP_EXCHANGE
		defb	ZXFP_TO_POWER

		defb	ZXFP_ST_MEM_0
		
		defb	ZXFP_EXCHANGE
		defb	ZXFP_MULTIPLY	; 
		defb	ZXFP_INT	; INT (x*(10^precision))
		
		defb	ZXFP_GET_MEM_0
		defb	ZXFP_DIVISION	; total/(10^precision)
		defb	ZXFP_END_CALC
ENDIF

		pop	af	; now, if needed, negate the nuber
		jr	z,noneg
		rst	ZXFP_BEGIN_CALC
		defb	ZXFP_NEGATE
		defb	ZXFP_END_CALC
.noneg

		rst	ZXFP_BEGIN_CALC	; Do the string conversion !
		defb	ZXFP_STRS
		defb	ZXFP_END_CALC

		call	ZXFP_STK_FETCH

		ex	de,hl
		pop	de

IF FORzx
		ldir
		xor	a
		ld	(de),a
		ret
ELSE

.nloop
		ld	a,(hl)
		cp	$76
		jr	nz,fcont
		xor	a
		ld	(de),a
		ret
.fcont
		add	20
		cp	42
		jr	nz,nodash
		ld	a,'-'
.nodash
		
		cp	47
		jr	nz,nodot
		ld	a,'.'
.nodot
		ld	(de),a
		inc	hl
		inc	de
		jr	nloop
ENDIF

