;
;	Far Call for REX6000
;
;	ReadPar3 function to read the parameter
;	Daniel
;
;       $Id: rdpar3.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	rdpar3
		XREF	far_par3


.rdpar3
	ld	hl,(far_par3)
	ret
