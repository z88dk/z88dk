
		MODULE		conio_vars

		SECTION		bss_clib

		PUBLIC		__pc6001_mode

__pc6001_mode:	defb		0

		SECTION		data_clib
		PUBLIC		__MODE2_attr
__MODE2_attr:     defb    @11000000,@00000000
