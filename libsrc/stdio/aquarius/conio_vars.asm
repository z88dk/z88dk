;
; Shared variables between the VT100 and VT52 engines


		MODULE		conio_vars
		SECTION		data_clib

		PUBLIC		__aquarius_attr
		PUBLIC		__aquarius_inverse

.__aquarius_attr       defb $70	; White on Black
.__aquarius_inverse       defb 7
