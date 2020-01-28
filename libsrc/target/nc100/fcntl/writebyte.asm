		SECTION code_clib	
		PUBLIC writebyte
		PUBLIC _writebyte

._writebyte
.writebyte	pop bc
		pop de
		ld hl, 0
		add hl, sp
		push de
		push bc
		ld bc, 1
		call 0xB8AB
		ld h, b
		ld l, c
		ret


