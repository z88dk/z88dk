
	SECTION	rodata_clib

	PUBLIC	textpixl

	EXTERN	base_graphics

;       32 16
;        8  4
;        2  1
; If pixel > 32 then  191 - value

textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


	defb 	192, 193, 194, 195

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..

	defb	196, 197, 198, 199

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..

	defb	200, 201, 202, 203

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..

	defb	204, 205, 206, 207

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.

	defb	208, 209, 210, 211

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.

	defb	212, 213, 214, 215

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.

	defb	216, 217, 218, 219

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.

	defb	220, 221, 222, 223

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X

	defb	224, 225, 226, 227

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X

	defb	228, 229, 230, 231

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X

	defb	232, 233, 234, 235

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X

	defb	236, 237, 238, 239

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX

	defb	240, 241, 242, 243

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX

	defb	244, 245, 246, 247

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX

	defb	248, 249, 250, 251

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX

	defb	252, 253, 254, 255
