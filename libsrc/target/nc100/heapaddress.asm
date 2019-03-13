		
                SECTION code_clib
		PUBLIC	heapaddress
		PUBLIC	_heapaddress

; fastcall
.heapaddress
._heapaddress
		ex de, hl
		jp 0xb87e

