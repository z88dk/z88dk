;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm
;*	Fixed by Keith Rickard 17/5/1999
;*
;*	If y<>0 then atan2(x/y)=atn(x/y)-PI*(y<0) (true=-1) else atan2(x/y)=PI/2*signum(x)


;double atan2(double x,double y)  atan(x/y)
;y is in the FA
;x is on the stack +8 (+2=y) 

                SECTION  code_fp
IF FORz88
                INCLUDE  "target/z88/def/fpp.def"
ELSE
		INCLUDE "fpp.def"
ENDIF

                PUBLIC    atan2

                EXTERN	fsetup
                EXTERN	stkequ2
                EXTERN    fa


.atan2
        ld      ix,8
        add     ix,sp
        ld      l,(ix+1)
        ld      h,(ix+2)
        ld      de,(fa+1)
        exx                     ;main set
        ld      c,(ix+5)
        ld      l,(ix+3)
        ld      h,(ix+4)
        ld      de,(fa+3)
        ld      a,(fa+5)
        ld      b,a
	ld	a,h		;*Put sign of x in A
	bit	7,d		;*Test the sign of y (0=+ve,1=-ve)
	push	af		;*Put sign info onto stack
IF FORz88
        fpp(FP_DIV)
ELSE
	ld	a,+(FP_DIV)
	call	FPP
ENDIF
	jr	nc,atan2_1	;*Skip if no error
	
IF FORz88
	fpp(FP_PI)		;*An RC.DVZ error means ATN(X/0)=PI/2
ELSE
	ld	a,+(FP_PI)
	call	FPP
ENDIF
	dec	c		;*CHLhl = PI/2
	pop	af		;*Make the result the same sign as x
	rla			;*CF=0 means +ve, CF=1 means -ve
	jr	nc,atan2_2	;*Finished if +ve
	set	7,H		;*Make -ve
	jr	atan2_2		;*Jump to finish

.atan2_1			;*
IF FORz88
        fpp(FP_ATN)
ELSE
	ld	a,+(FP_ATN)
	call	FPP
ENDIF
	pop	af		;*What was the sign of y?
	jr	z,atan2_2	;*Finished if +ve

	exx			;*Stack the result atn(x/y)
	push	hl		;*Stack the LSBs
	exx			;*
	push	hl		;*Next the MSBs
	push	bc		;*And finally the Exp
IF FORz88
	fpp(FP_PI)		;*Get PI into CHLhl
ELSE
	ld	a,+(FP_PI)
	call	FPP
ENDIF
	ld	a,c		;*Keep PI in CHLhl and put atn(x/y) into BDEde
	pop	bc		;*Keep Exp of PI in C and put Exp of atn(x/y) in B
	ld	b,c		;*
	ld	c,a		;*
	pop	de		;*MSBs of atn(x/y) into DE
	exx			;*
	pop	de		;*LSBs of atn(x/y) into de
	exx			;*
IF FORz88
	fpp(FP_ADD)		;*CHLhl will now hold atn(x/y)+PI
ELSE
	ld	a,+(FP_ADD)
	call	FPP
ENDIF

.atan2_2			;*
        jp      stkequ2		;Finished! CHLhl holds atan2(x/y)

