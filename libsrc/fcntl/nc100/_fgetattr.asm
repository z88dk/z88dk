		SECTION code_clib	
		PUBLIC	__fgetattr
		PUBLIC	_fgetattr

; Fastcall 
.__fgetattr
._fgetattr	call 0xB8C9
		jr c, _fgetok
		ld hl, 0xffff
		ret
_fgetok:	ld l, a
		ld h, 0
		ret
