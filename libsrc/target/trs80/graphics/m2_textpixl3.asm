;
;
;	Support char table (pseudo graph symbols) for the TRS 80 Model II
;	Version for the 1x3 graphics symbols
;	Sequence: blank, top, half, top+half, bottom, etc..
;
;	NOTE: there's no point really to use a table on the TRS80,
;	      it is only a very quick way to get the result.
;
;	$Id: m2_textpixl3.asm $
;
;


	PUBLIC	textpixl


.textpixl
		defb	32
		defb	0x1b+128, 0x16, 0x19+128
		defb	0x18, 0x16+128, 0x1a
		defb	32+128

