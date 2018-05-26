;
; Shared variables between the VT100 and VT52 engines


		MODULE		conio_vars
		SECTION		data_clib

		PUBLIC		msx_attr

.msx_attr       defb $F1        ; White on Black
