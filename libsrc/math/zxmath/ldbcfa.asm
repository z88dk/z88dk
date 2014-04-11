;
;	Z88dk Generic Floating Point Math Library
;
;	 bc ix de = FA


		XLIB	ldbcfa

		XREF	fa

.ldbcfa LD      DE,(fa)
        LD      IX,(fa+2)
        LD      BC,(fa+4)
        RET
