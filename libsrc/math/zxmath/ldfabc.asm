;
;	Z88dk Generic Floating Point Math Library
;
;	FA = bc ix de


		XLIB	ldfabc

		XREF	fa

.ldfabc LD      (fa),DE
        LD      (fa+2),IX
        LD      (fa+4),BC
        RET
