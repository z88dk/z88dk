;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       30/1/20001 djm


;double atof(char *)     - convert string to number, leave in fa

                SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    atof

                EXTERN	stkequ2

.atof
	pop	de
	pop	hl	;the string
	push	hl
	push	de
        fpp(FP_VAL)
        jp      stkequ2



