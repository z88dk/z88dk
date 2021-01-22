

	SECTION	code_clib

	PUBLIC	VDM_DISPLAY

	defc	VDM_DISPLAY = $cc00		;Default address

	; This default address can be overridden on the command line
	; with -pragma-export:VDM_DISPLAY=0xnnn
