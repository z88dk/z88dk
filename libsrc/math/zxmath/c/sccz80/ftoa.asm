;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ftoa.asm $
;
;
;void ftoa(x,prec,str)   -> Convert double to string
;
;double x ;              /* number to be converted */
;int prec ;              /* # digits after decimal place */
;char *str ;             /* output string */
;


IF FORts2068
		INCLUDE  "target/ts2068/def/ts2068fp.def"
ENDIF
IF FORzx
		INCLUDE  "target/zx/def/zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "target/zx81/def/81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "target/lambda/def/lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    ftoa

.ftoa
		ld	hl,2
		add	hl,sp
		ld	e,(hl)		; buffer
		inc	hl
		ld	d,(hl)


IF TINYMODE
		; we cut away the precision handling

IF FORzx
		ld iy,$5C3A		; Fix IY because we're in TINYMODE, STACK-BC would fix IY already
ELSE
IF FORts2068
		ld iy,$5C3A		; ditto.. STACK-BC would fix IY already
ELSE
		ld ix,$4000		; (-IXIY) ..STACK-BC would fix IY already (not on LAMBDA V2 or CAC-3/NF300)
ENDIF
ENDIF

		inc	hl
		inc	hl
ELSE
		inc	hl
		ld	c,(hl)		; precision
		inc	hl
		ld	b,(hl)
		
		push	hl
		push	de
IF FORlambda
		ld ix,$4000		; (-IXIY) On other targets IY is initialized by STACK-BC
ENDIF
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

IF TINYMODE
		; we cut away the precision handling
ELSE
		rst	ZXFP_BEGIN_CALC	; truncating stuff...
		defb	ZXFP_EXCHANGE

		defb	ZXFP_STK_TEN
		defb	ZXFP_EXCHANGE
		defb	ZXFP_TO_POWER

		defb	ZXFP_ST_MEM_1
		
		defb	ZXFP_MULTIPLY
		defb	ZXFP_INT	; INT (x*(10^precision))
		
		defb	ZXFP_GET_MEM_1
IF FORlambda
		defb	ZXFP_DIVISION + 128	; total/(10^precision)
ELSE
		defb	ZXFP_DIVISION	; total/(10^precision)
		defb	ZXFP_END_CALC
ENDIF
ENDIF


		pop	af	; now, if needed, negate the nuber
		jr	z,noneg
		rst	ZXFP_BEGIN_CALC
IF FORlambda
		defb	ZXFP_NEGATE + 128
ELSE
		defb	ZXFP_NEGATE
		defb	ZXFP_END_CALC
ENDIF
.noneg

		rst	ZXFP_BEGIN_CALC	; Do the string conversion !
IF FORlambda
		defb	ZXFP_STRS + 128
IF LAMBDAV3
		call	ZXFP_STK_FETCH
ELSE
		rst	ZXFP_STK_FETCH
ENDIF
ELSE
		defb	ZXFP_STRS
		defb	ZXFP_END_CALC
		call	ZXFP_STK_FETCH
ENDIF

		ex	de,hl
		pop	de

IF (FORzx | FORts2068)
		ldir
		xor	a
		ld	(de),a
		ret
ELSE

.nloop
		ld	a,(hl)
		cp	$40			; printable char or end of string ?
		jr	c,fcont
		xor	a
		ld	(de),a
		ret
.fcont
		add	20
		cp	42
		jr	nz,nodash
		ld	a,'-'
.nodash
IF !TINYMODE
		cp	41
		jr	nz,noplus
		ld	a,'+'
.noplus
		
		cp	62
		jr	nz,noexp
		ld	a,'e'
.noexp
ENDIF
		cp	47
		jr	nz,nodot
		ld	a,'.'
.nodot
		ld	(de),a
		inc	hl
		inc	de
		jr	nloop
ENDIF

