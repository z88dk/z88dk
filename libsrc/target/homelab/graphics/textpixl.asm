;
;
;	Support char table (pseudo graph symbols) for the ZX80
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.3 2016-06-23 19:53:27 dom Exp $
;
;
;       .. X. .X XX
;       .. .. .. ..
;
;       .. X. .X XX
;       X. X. X. X.
;
;       .. X. .X XX
;       .X .X .X .X
;
;       .. X. .X XX
;       XX XX XX XX


        SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	 32,  27,  28,  31
		defb	 30, 213,  25,  22
		defb	 29,  26, 234,  23
		defb	 18,  21,  24, 255
