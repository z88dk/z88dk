;
; Shared variables between the VT100 and VT52 engines


		MODULE		conio_vars
		SECTION		data_clib

		PUBLIC		__sprinter_attr

.__sprinter_attr       defb    @00001111       ;bright white on black
.inverse_attr   defb    @01111000       ;grey on white
