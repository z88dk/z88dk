;
;	CPM Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - fixed
;
;
;	$Id: getk.asm,v 1.4 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	LD 	c,6
	ld	e,255
	call	5
	ld	h,0
	ld	l,a
	
	ret
