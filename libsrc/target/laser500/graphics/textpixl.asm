;
;
;	Support char table (pseudo graph symbols) for the ZX80
;	Sequence: blank, top-left, top-right, top-half, bottom-left, left-half, etc..
;
;	$Id: textpixl.asm,v 1.3 2016-06-23 19:53:27 dom Exp $
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
		defb	$20, $18, $14, $1c
		defb	$11, $1a, $16, $1e
		defb	$12, $19, $15, $1d
		defb	$13, $1b, $17, $1f
