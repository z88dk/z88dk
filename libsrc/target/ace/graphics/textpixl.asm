;
;
;	Support char table (pseudo graph symbols) for the Jupiter Ace
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	32,      18,      17,      19
		defb	23+128,  21+128,  22+128,  20+128
		defb	20,      22,      21,      23
		defb	19+128,  17+128,  18+128,  32+128

