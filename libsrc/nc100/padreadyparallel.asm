		PUBLIC	padreadyparallel

; fastcall
.padreadyparallel
		call 0xb866
		ld hl, 0
		ret nc
		inc hl
		ret
