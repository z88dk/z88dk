

	SECTION bss_clib
	PUBLIC _in_KeyDebounce, _in_KeyStartRepeat, _in_KeyRepeatPeriod
	PUBLIC _in_KbdState

_in_KeyDebounce:	defb	0
_in_KeyStartRepeat:	defb	0
_in_KeyRepeatPeriod:	defb	0
_in_KbdState:		defw	0
