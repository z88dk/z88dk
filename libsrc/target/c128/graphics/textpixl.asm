;
;
;	Support char table (pseudo graph symbols) for the Commodore 128
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.4 2016-06-20 21:47:41 dom Exp $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	 32,     126,     124,  98+128
		defb	123,      97,     255, 108+128
		defb	108,     127,  97+128, 123+128
		defb	 98, 124+128, 126+128,  32+128

