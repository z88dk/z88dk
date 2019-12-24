
	SECTION	rodata_clib

	PUBLIC	textpixl


;        1  2
;        4  8
;       16 32
; If pixel > 32 then  191 - value

textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


	defb	32, 129, 130, 131

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..
	defb	132, 133, 134, 135

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..
	defb	136, 137, 138, 139

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..
	defb	140, 141, 142, 143

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.

	defb	144, 145, 146, 147

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.

	defb	148, 149, 150, 151

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.

	defb	152, 153, 154, 155

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.

	defb	156, 157, 158, 159

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X

	defb	160, 161, 162, 163

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X

	defb	164, 165, 166, 167

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X

	defb	168, 169, 170, 171

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X

	defb	172, 173, 174, 175

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX

	defb	176, 177, 178, 179

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX

	defb	180, 181, 182, 183

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX

	defb	184, 185, 186, 187

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	188, 189, 190, 191
