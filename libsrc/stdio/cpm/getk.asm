;
;	CPM Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - fixed
;
;
;	$Id: getk.asm,v 1.3 2004-03-20 11:16:24 stefano Exp $
;

	XLIB	getk

.getk
	LD 	c,6
	ld	e,255
	call	5
	ld	h,0
	ld	l,a
	
	ret
