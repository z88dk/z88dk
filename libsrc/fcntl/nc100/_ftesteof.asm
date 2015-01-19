		PUBLIC _ftesteof

._ftesteof	pop hl
		pop de
		push de
		push hl
		call 0xB8C0
		ld hl, 0
		adc hl,hl
		ret

