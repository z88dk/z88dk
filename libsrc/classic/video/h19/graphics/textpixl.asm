;
;
;	Support char table (pseudo graph symbols) for the H19
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm $
;
;

    SECTION rodata_clib
    PUBLIC  textpixl


textpixl:

	;       OO      #O      O#      ##
	;       OO      OO      OO      OO
	;-------------------------------------
    defb    32,     144,    145,    146

	;       OO      #O      O#      ##
	;       #O      #O      #O      #O
	;-------------------------------------
    defb    143,    147+64, 155+64, 142+64

	;       OO      #O      O#      ##
	;       O#      O#      O#      O#
	;-------------------------------------
    defb    142,    154+64, 147,    143+64

	;       OO      #O      O#      ##
	;       ##      ##      ##      ##
	;-------------------------------------
    defb    146+64, 145+64, 144+64, 32+64

