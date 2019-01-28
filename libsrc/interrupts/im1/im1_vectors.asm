
		SECTION		bss_clib

		PUBLIC		im1_vectors
	
		PUBLIC		CLIB_IM1_VECTOR_COUNT

		defc		CLIB_IM1_VECTOR_COUNT = 8


im1_vectors:	defs		(CLIB_IM1_VECTOR_COUNT + 1) * 2
