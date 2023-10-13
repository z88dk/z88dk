;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: fprand.asm $
;


;double fprand()
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
                PUBLIC    fprand
                PUBLIC    fpseed

                EXTERN	stkequ

.fpseed
	pop bc
	pop de
	pop hl
	push hl
	add hl,de ; shuffle 4/5 of the FP value into an integer value
	push de
	push bc
	ld (fprand+1),hl
	ret
	
	

.fprand

	LD      BC,1111      ; SEED 
	CALL    ZXFP_STACK_BC 

	rst	ZXFP_BEGIN_CALC

	defb	ZXFP_STK_ONE
	defb	ZXFP_ADDITION
	defb	ZXFP_STK_DATA
        DEFB    $37             ;;Exponent: $87, Bytes: 1 
        DEFB    $16             ;;(+00,+00,+00) 
	defb	ZXFP_MULTIPLY
	defb	ZXFP_STK_DATA
        DEFB    $80             ;;Bytes: 3 
        DEFB    $41             ;;Exponent $91 
        DEFB    $00,$00,$80     ;;(+00) 
	defb	ZXFP_N_MOD_M
	defb	ZXFP_DELETE
	defb	ZXFP_STK_ONE
	defb	ZXFP_SUBTRACT
IF FORlambda
	defb	ZXFP_DUPLICATE + 128
ELSE
	defb	ZXFP_DUPLICATE
	defb	ZXFP_END_CALC
ENDIF

	CALL    ZXFP_FP_TO_BC
	LD      (fprand+1),BC      ; SEED ..Self Modifying Code, why not?
	
	ld a,(hl)                   ; pick up the exponent
	sub 16                      ; reduce it by 16 (=divide number by 65536)
	ld   (hl),a

	jp      stkequ
