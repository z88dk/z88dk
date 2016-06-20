;
;
;	Support char table (pseudo graph symbols) for the Mattel Aquarius
;	Version for the 2x3 graphics symbols
;	Sequence: blank, top-left, top-right, top-half, medium-left, top-left + medium-left, etc..
;
;	$Id: textpixl6.asm,v 1.3 2016-06-20 21:47:41 dom Exp $
;
;


	SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
		defb	160, 161, 162 ,163, 164, 165, 166, 167
		defb	168, 169, 170, 171, 172, 173, 174, 175
		defb	176, 177, 178, 179, 180, 181, 182, 183
		defb	184, 185, 186, 187, 188, 189, 190, 191

	;	O#
	;	##	= 190
	;	#O
		
	;	##
	;	##	= 191
	;	#O	31

	;	OO
	;	OO	= 224 ?  (it is slightly thicker)
	;	O#
	
	;	#O
	;	OO	= 225
	;	O#	33
		
	;	O#
	;	OO	= 226
	;	O#
		
		defb	215, 225, 226, 227, 228, 229, 230, 231
		defb	232, 233, 234, 235, 236, 237, 238, 239
		defb	240, 241, 242, 243, 244, 245, 246, 247
		defb	248, 249, 250, 251, 252, 253, 254, 255

