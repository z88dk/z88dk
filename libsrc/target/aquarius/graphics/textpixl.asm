;
;
;	Support char table (pseudo graph symbols) for the Mattel Aquarius
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.4 2016-06-20 21:47:41 dom Exp $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	 32,      29,      27,     175
		defb	 28,     181,     182,     191
		defb	 26,      30,     234,     239
		defb	 31,     253,     254,     255

