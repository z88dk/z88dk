;
;	Far Call for REX6000
;
;	ReadPar1 function to read the parameter
;	Daniel
;
;       $Id: rdpar1.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	rdpar1
		XREF	far_par1


.rdpar1
	ld	hl,(far_par1)
	ret



