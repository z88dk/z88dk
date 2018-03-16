;
;
;	Support char table (pseudo graph symbols) for the Osborne 1
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	 32,     18,     20,      23
		defb	  6,      1,      2,      17
		defb	  7,     14,      4,       5
		defb	 24,     26,      3,      22
