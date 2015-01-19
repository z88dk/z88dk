		PUBLIC	kmcharreturn

.kmcharreturn
		pop ix
		pop bc
		call 0xB803
		push bc
		jp (ix)

