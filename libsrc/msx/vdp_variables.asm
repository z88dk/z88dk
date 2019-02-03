
	SECTION		bss_clib

	PUBLIC		__tms9918_screen_mode
	PUBLIC		__tms9918_attribute

__tms9918_screen_mode:	defb	0

	SECTION		data_clib

__tms9918_attribute:	defb	$f1	;white on black
