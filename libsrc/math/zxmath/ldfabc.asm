;
;	Z88dk Generic Floating Point Math Library
;
;	FA = bc ix de


		XLIB	ldfabc

		XREF	fa

.LDFABC LD      (FA),DE
        LD      (FA+2),IX
        LD      (FA+4),BC
        RET
