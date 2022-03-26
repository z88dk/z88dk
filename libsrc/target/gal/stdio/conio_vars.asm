

	SECTION data_clib
	PUBLIC	__gal_mode
	EXTERN   CLIB_DEFAULT_SCREEN_MODE

__gal_mode:	   defb	   CLIB_DEFAULT_SCREEN_MODE ; 0 = text, 1 = hires
