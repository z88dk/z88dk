;
;
;	Support char table (pseudo graph symbols) for the Mattel Aquarius
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;
;

	SECTION rodata_clib
	PUBLIC	textpixl

.textpixl
		defb	 32,     176,     177,     182
		defb	179,     180,     185,     188
		defb	178 ,    184,     181,     189
		defb	183,     187,     186,     255

