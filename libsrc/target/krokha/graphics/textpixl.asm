;
;
;	Support char table (pseudo graph symbols) for the Krokha
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
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
	defb	  0,   1,   2,   3
	defb	 16,  17,  18,   19
	defb	  4,   5,   6,   7
	defb	 20,  21,  22,  23
