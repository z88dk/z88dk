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
	defb	 32, 231, 235, 227
	defb    237, 229, 233, 225
	defb	238, 230, 232, 226
        defb	236, 228, 232, 224

