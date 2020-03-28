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
	defb	128, 130, 129, 131
	defb	136, 138, 137, 139
	defb	132, 134, 133, 135
	defb	140, 142, 141, 143
