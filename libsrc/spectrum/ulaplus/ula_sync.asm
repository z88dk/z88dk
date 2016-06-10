;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, MAR 2010
;
;	int ula_sync();
;
;	Wait for the next video frame
;	clock
;
;	$Id: ula_sync.asm,v 1.3 2016-06-10 21:14:23 dom Exp $
;

	SECTION code_clib
	PUBLIC	ula_sync
	PUBLIC	_ula_sync

ula_sync:
_ula_sync:
	; Sync to avoid screen flickering
	ld	a,($5C78)
	ld	e,a
videosync:
	ld	a,($5C78)
	cp e
	ret nz
	jr	videosync
