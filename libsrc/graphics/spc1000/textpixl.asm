;
;
;	Support char table (pseudo graph symbols) for the SPC-1000
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
	defb	224, 232, 228, 236
	defb    226, 234, 230, 238
	defb	225, 233, 229, 237
        defb	227, 235, 231, 239

