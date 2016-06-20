
                SECTION code_clib
		PUBLIC	txtsetcursor
		PUBLIC	_txtsetcursor

; fastcall so in HL!
.txtsetcursor
._txtsetcursor
		jp 0xB836
