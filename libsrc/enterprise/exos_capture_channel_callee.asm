;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_capture_channel(unsigned char main_channel, unsigned char secondary_channel);
;
;
;	$Id: exos_capture_channel_callee.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
PUBLIC	exos_capture_channel_callee
PUBLIC	_exos_capture_channel_callee
PUBLIC 	ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

exos_capture_channel_callee:
_exos_capture_channel_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : l = main channel number
;         e = secondary channel number

.asmentry

	ld	a,l		; main channel
	ld	c,e		; sec. ch
	rst   30h
	defb  17
	ld	h,0
	ld	l,a
	ret


DEFC ASMDISP_EXOS_OPEN_CHANNEL_CALLEE = # asmentry - exos_capture_channel_callee
