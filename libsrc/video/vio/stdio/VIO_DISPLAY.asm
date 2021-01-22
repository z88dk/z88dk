

	SECTION	code_clib

	PUBLIC	VIO_DISPLAY

	defc	VIO_DISPLAY = $F000		;Default address

	; This default address can be overridden on the command line
	; with -pragma-export:VIO_DISPLAY=0xnnn
