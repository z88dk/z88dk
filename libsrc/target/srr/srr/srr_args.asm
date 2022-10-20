; 'arghak' takes the first 7 args on the stack
; and places them contiguously at the "args" ram area.
; This allows a library routine to make one call	to arghak
; and henceforth have all it's args available directly
; through lhld's instead of having to hack the stack as it
; grows and shrinks. Note that arghak should be called as the
; VERY FIRST THING a function does, before even pushing BC.
;

SECTION bss_clib

PUBLIC srr_args
PUBLIC srr_arg1
PUBLIC srr_arg2
PUBLIC srr_arg3
PUBLIC srr_arg4
PUBLIC srr_arg5
PUBLIC srr_arg6
PUBLIC srr_arg7

srr_args:
srr_arg1:
	defw	0
srr_arg2:
	defw	0
srr_arg3:
	defw	0
srr_arg4:
	defw	0
srr_arg5:
	defw	0
srr_arg6:
	defw	0
srr_arg7:
	defw	0
