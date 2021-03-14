
	SECTION	code_clib

	PUBLIC	pc88_wait_vblank
	PUBLIC	_pc88_wait_vblank

	INCLUDE	"target/pc88/def/pc88.def"

; Taken from PC-88 info page: http://mydocuments.g2.xrea.com/html/p8/vraminfo.html
pc88_wait_vblank:
_pc88_wait_vblank:
	in	a,(SYS_MODE_SENSE)
	and	$20		;VBLANK_SIGNAL
	jr	nz,pc88_wait_vblank

	; And wait for signal to to be off again
wait:
	in	a,(SYS_MODE_SENSE)
	and	$20
	jr	z,wait
	ret



