
	MODULE		asm_realloc
	PUBLIC		asm_realloc
	EXTERN		MAHeapRealloc
	EXTERN		_heap


   ; Realloc using the thread's default heap
   ;
   ; enter : hl = void *p (existing pointer to memory)
   ;         bc = uint size (realloc size)
   ; exit  : success
   ;
   ;            hl = void *p_new
   ;            carry reset
asm_realloc:
	ld 	de,_heap
	call	MAHeapRealloc
	ccf			; newlib c on success, classic = nc on failure
	ret	
	
