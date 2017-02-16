;
;
;	Support char table (pseudo graph symbols) for the PacMan Hardware
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id:$
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	 32,     238,     239,  219
		defb	236,     232,     209,  217
		defb	237,     208,     233,  0xD8
		defb	0xDD,     0xD7,     0xD6,  0x2A

