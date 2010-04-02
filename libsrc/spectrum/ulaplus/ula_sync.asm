;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int ula_sync();
;
;	Wait for the next video frame
;	clock
;
;	$Id: ula_sync.asm,v 1.1 2010-04-02 09:05:06 stefano Exp $
;

	XLIB	ula_sync

ula_sync:
	; Sync to avoid screen flickering
	ld	a,($5C78)
	ld	e,a
videosync:
	ld	a,($5C78)
	cp e
	ret nz
	jr	videosync
