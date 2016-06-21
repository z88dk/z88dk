;
;	Z88dk Generic Floating Point Math Library
;
;	 bc ix de = FA

        SECTION code_fp
	PUBLIC	ldbcfa

	EXTERN	fa

.ldbcfa LD      DE,(fa)
        LD      IX,(fa+2)
        LD      BC,(fa+4)
        RET
