;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_open_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_open_channel_callee.asm,v 1.3 2014-09-28 18:26:58 pauloscustodio Exp $
;


XLIB	exos_open_channel_callee
XDEF 	ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

exos_open_channel_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : de = char *device
;         l = channel number

.asmentry

	ld	a,l		; channel
	rst   30h
	defb  1
	ld	h,0
	ld	l,a
	ret


DEFC ASMDISP_EXOS_OPEN_CHANNEL_CALLEE = # asmentry - exos_open_channel_callee
 
