;
;       ZX Maths Routines
;
;       Borrowed from the Generic Floating Point Math Library
;
;       Exchange FA with top of stack (under ret address)
;
;	$Id: dswap.asm $

                SECTION  code_fp
				
		PUBLIC	dswap
		
		EXTERN	fsetup
		EXTERN	stkequ
		
		EXTERN dpush2
		
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


.dswap
        call    fsetup			; (SP) -> (FP); (FA) -> (FP)
		defb	ZXFP_END_CALC

		call	stkequ			; (FP) -> (FA)
		call	dpush2
		
		rst		ZXFP_BEGIN_CALC
		defb	ZXFP_END_CALC
		jp stkequ

