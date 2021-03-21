
		SECTION		bss_clib

		PUBLIC		line_vectors
	
		PUBLIC		CLIB_LINE_VECTOR_COUNT

		defc		CLIB_LINE_VECTOR_COUNT = 8


line_vectors:	defs		(CLIB_LINE_VECTOR_COUNT + 1) * 2
