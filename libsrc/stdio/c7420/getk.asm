;
;	Keyboard routines for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;
;	getk() Read key status
;
;
;	$Id:
;

		PUBLIC	getk

.getk
	call $a22
	ld h,0
	ld l,a
	ret
