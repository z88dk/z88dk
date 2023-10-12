;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: amin.asm $
;


;double amin (double x,double y)  
;
;returns the smaller of x and y


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
		PUBLIC    amin
		PUBLIC    fmin

		EXTERN	fsetupf
		EXTERN	stkequ

.amin
.fmin
	call    fsetupf
	
	defb	ZXFP_ST_MEM_0
	defb	ZXFP_EXCHANGE
	defb	ZXFP_ST_MEM_1

	defb	ZXFP_SUBTRACT
	defb	ZXFP_GREATER_0
	defb	ZXFP_JUMP_TRUE
	defb	4
	defb	ZXFP_GET_MEM_0
	defb	ZXFP_JUMP
	defb	2
	defb	ZXFP_GET_MEM_1

	defb	ZXFP_END_CALC
	
	jp      stkequ
