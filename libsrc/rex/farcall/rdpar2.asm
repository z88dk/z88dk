;
;	Far Call for REX6000
;
;	ReadPar2 function to read the parameter
;	Daniel
;
;       $Id: rdpar2.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	rdpar2
		XREF	far_par2


.rdpar2
	ld	hl,(far_par2)
	ret



