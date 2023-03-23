
		SECTION		bss_clib

		PUBLIC		fast_vectors
	
		PUBLIC		CLIB_FAST_VECTOR_COUNT

		defc		CLIB_FAST_VECTOR_COUNT = 8


fast_vectors:	defs		(CLIB_FAST_VECTOR_COUNT + 1) * 2
