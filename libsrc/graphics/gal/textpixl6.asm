;
;
;	Support char table (pseudo graph symbols) for the Galaksija
;	Version for the 2x3 graphics symbols
;	Sequence: blank, top-left, top-right, top-half, medium-left, top-left + medium-left, etc..
;
;	NOTE: we shouldn't use a table on the Galaksija,
;	      it is only a very quick way to get the result.
;
;	$Id: textpixl6.asm,v 1.3 2016-06-20 21:47:41 dom Exp $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	128, 129, 130 ,131, 132, 133, 134, 135
		defb	136, 137, 138, 139, 140, 141, 142, 143
		defb	144, 145, 146, 147, 148, 149, 150, 151
		defb	152, 153, 154, 155, 156, 157, 158, 159

		defb	160, 161, 162, 163, 164, 165, 166, 167
		defb	168, 169, 170, 171, 172, 173, 174, 175
		defb	176, 177, 178, 179, 180, 181, 182, 183
		defb	184, 185, 186, 187, 188, 189, 190, 191

