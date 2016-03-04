;
;	CPM Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - fixed
;
;
;	$Id: getk.asm,v 1.5 2016-03-04 23:10:03 dom Exp $
;

	PUBLIC	getk
	PUBLIC	_getk

._getk
	LD 	c,6
	ld	e,255
	call	5
	ld	h,0
	ld	l,a
	
	ret
