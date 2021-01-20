

	SECTION	code_clib

	PUBLIC	VTI_DISPLAY

	defc	VTI_DISPLAY = $F800		;Default address

	; This default address can be overridden on the command line
	; with -pragma-export:VTI_DISPLAY=0xnnn
