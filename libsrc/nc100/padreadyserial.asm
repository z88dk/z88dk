		PUBLIC	padreadyserial

; fastcall
.padreadyserial
		call 0xb869
		ld hl, 0
		ret nc
		inc hl
		ret
