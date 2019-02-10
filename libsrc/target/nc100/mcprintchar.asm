		
                SECTION code_clib
		PUBLIC	mcprintchar
		PUBLIC	_mcprintchar
; Fastcall

._mcprintchar
.mcprintchar	ld a, l
		call 0xb851
		ld hl, 0
		ret c
		dec hl
		ret
