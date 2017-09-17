
	MODULE		asm_free
	PUBLIC		asm_free
	EXTERN		MAHeapFree
	EXTERN		_heap


   ; Realloc using the thread's default heap
   ;
   ; enter : hl = void *p (existing pointer to memory)
asm_free:
	ld 	de,_heap
	call	MAHeapFree
	ccf			; newlib c on success, classic = nc on failure
	ret	
	
