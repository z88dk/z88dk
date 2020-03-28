		SECTION code_clib
		PUBLIC _ftesteof
      PUBLIC __ftesteof

._ftesteof
.__ftesteof
      pop hl
		pop de
		push de
		push hl
		call 0xB8C0
		ld hl, 0
		adc hl,hl
		ret

