;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_create_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_create_channel_callee.asm,v 1.5 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
PUBLIC	exos_create_channel_callee
PUBLIC	_exos_create_channel_callee
PUBLIC 	asm_exos_create_channel

exos_create_channel_callee:
_exos_create_channel_callee:

	pop hl
	pop de
	ex (sp),hl

; enter : de = char *device
;         l = channel number

.asm_exos_create_channel

	ld	a,l		; channel
	rst   30h
	defb  2
	ld	h,0
	ld	l,a
	ret


 
