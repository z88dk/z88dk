;
;	Far Call for REX6000
;
;	ReadPar2 function to read the parameter
;	Daniel
;
;	$Id: rdpar2.asm,v 1.1 2001-09-03 16:13:20 dom Exp $

		XLIB	rdpar2
		XREF	far_par2


.rdpar2
	ld	hl,(far_par2)
	ret



