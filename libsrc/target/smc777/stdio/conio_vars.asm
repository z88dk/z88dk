
		MODULE		console_vars

		PUBLIC		__smc777_mode
		PUBLIC		__smc777_attr
		PUBLIC		__smc777_paper16
		PUBLIC		__smc777_ink16

		SECTION		data_clib

__smc777_mode:	defb	0

__smc777_attr:	defb	7
__smc777_ink16:		defb	$7		;white
__smc777_paper16:	defb	$c		;light cyan

