;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: cbrt.asm $
;


;double cbrt(double)
;Number in FA..


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
                PUBLIC    cbrt

                EXTERN	fsetup1
                EXTERN	stkequ

.cbrt
        call    fsetup1

        defb	ZXFP_DUPLICATE  ; keep a copy of the argument to preserve the sign

        defb	ZXFP_ABS        ; we will apply powers to positive values
        
        defb	ZXFP_STK_ONE	; stack one
        
        defb	ZXFP_STK_ONE	; stack 3
        defb	ZXFP_STK_ONE
        defb	ZXFP_STK_ONE
        defb	ZXFP_ADDITION
        defb	ZXFP_ADDITION
        
        defb	ZXFP_DIVISION	; 1/3
        
        defb	ZXFP_TO_POWER	; the actual cube root
        
        defb	ZXFP_EXCHANGE	; get the copy of the argument
        defb	ZXFP_GREATER_0	; check the sign (it will remove the copy)
        defb	ZXFP_JUMP_TRUE	; positive?
        defb    2
        defb	ZXFP_NEGATE		; no, invert sign
        
        defb	ZXFP_END_CALC

        jp      stkequ

