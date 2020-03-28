
		SECTION		bss_clib

		PUBLIC		nmi_vectors
	
		PUBLIC		CLIB_NMI_VECTOR_COUNT

		defc		CLIB_NMI_VECTOR_COUNT = 8


nmi_vectors:	defs		(CLIB_NMI_VECTOR_COUNT + 1) * 2
