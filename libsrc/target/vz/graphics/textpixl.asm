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
		defb	 128,     136,    132,   140 
		defb	 130,     138,    134,   142
		defb	 129,     137,    133,   141
		defb	 131,     139,    135,   143

