;
;
;       Z88 Maths Routines
;
;       C Interface for Small C+ Compiler
;
;       7/12/98 djm


;double acos(double)
;Number in FA..

		SECTION  code_fp
                INCLUDE  "fpp.def"

                PUBLIC    acos

                EXTERN	fsetup
                EXTERN	stkequ2

.acos
        call    fsetup
        fpp(FP_ACS)
        jp      stkequ2



