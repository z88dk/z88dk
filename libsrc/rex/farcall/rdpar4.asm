;
;	Far Call for REX6000
;
;	ReadPar4 function to read the parameter
;	Daniel
;
;       $Id: rdpar4.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	rdpar4
		XREF	far_par4


.rdpar4
	ld	hl,(far_par4)
	ret
