		PUBLIC	mcprintchar
; Fastcall
.mcprintchar	ld a, l
		call 0xb851
		ld hl, 0
		ret c
		dec hl
		ret
