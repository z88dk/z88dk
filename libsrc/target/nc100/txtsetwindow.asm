
                SECTION code_clib
		PUBLIC	txtsetwindow
		PUBLIC	_txtsetwindow

.txtsetwindow	
._txtsetwindow	
		pop bc
		pop hl
		pop de
		push de
		push hl
		push bc
		jp 0xb839
