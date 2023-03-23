
	SECTION	code_video_vdp

	PUBLIC	l_tms9918_disable_interrupts
	PUBLIC	l_tms9918_enable_interrupts	
	PUBLIC	__vdp_enable_status

	INCLUDE	"video/tms9918/vdp.inc"


l_tms9918_disable_interrupts:
	ld	a,128
	ld	(__vdp_enable_status),a
	ret

l_tms9918_enable_interrupts:
	xor	a
	ld	(__vdp_enable_status),a
IF VDP_STATUS < 0
	ld	a,(-VDP_STATUS)
ELSE
	ld	a, VDP_STATUS / 256
	in	a,(VDP_STATUS % 256)
ENDIF
	ret


	SECTION	bss_video_vdp

__vdp_enable_status:
	defb	0
