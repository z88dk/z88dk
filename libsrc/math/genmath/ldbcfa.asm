;
;	Z88dk Generic Floating Point Math Library
;
;	 bc ix de = FA


		XLIB	ldbcfa

		XREF	fa

.LDBCFA LD      DE,(FA)
        LD      IX,(FA+2)
        LD      BC,(FA+4)
        RET
