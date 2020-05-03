;
;
;	Support char table (pseudo graph symbols) for the Super80-vduem
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;
;       .. X. .X XX
;       .. .. .. ..
;
;       .. X. .X XX
;       X. X. X. X.
;
;       .. X. .X XX
;       .X .X .X .X
;
;       .. X. .X XX
;       XX XX XX XX


        SECTION rodata_clib
	PUBLIC	textpixl


.textpixl
	defb	$20, $01, $02, $03
	defb	$10, $11, $12, $13
	defb	$04, $05, $06, $07
	defb	$14, $15, $16, $17
