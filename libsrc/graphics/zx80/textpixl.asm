;
;
;	Support char table (pseudo graph symbols) for the ZX80
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.3 2016-06-23 19:53:27 dom Exp $
;
;


        SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	  0,       4,       5,     131
		defb	  6,       2,       8,     135
		defb	  7,     136,     130,     134
		defb	  3,     133,     132,     128

