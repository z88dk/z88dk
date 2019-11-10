;
; Shared variables between the VT100 and VT52 engines


		MODULE		conio_vars
		SECTION		data_clib

		PUBLIC		__x1_attr
		PUBLIC		__x1_mode

.__x1_attr       defb $7	; White on Black

.__x1_mode	defb	0
