

	SECTION data_clib
	PUBLIC _in_KeyDebounce, _in_KeyStartRepeat, _in_KeyRepeatPeriod
	PUBLIC _in_KbdState

_in_KeyDebounce:	defb	1
_in_KeyStartRepeat:	defb	1
_in_KeyRepeatPeriod:	defb	1

	SECTION	bss_clib
_in_KbdState:		defb	1
			defb	0
