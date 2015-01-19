;
;
;	Support char table (pseudo graph symbols) for the ZX80
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.2 2015-01-19 01:32:52 pauloscustodio Exp $
;
;


	PUBLIC	textpixl


.textpixl
		defb	  0,       4,       5,     131
		defb	  6,       2,       8,     135
		defb	  7,     136,     130,     134
		defb	  3,     133,     132,     128

