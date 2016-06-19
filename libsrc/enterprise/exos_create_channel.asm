;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_create_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_create_channel.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC    exos_create_channel
	PUBLIC    _exos_create_channel

	EXTERN     exos_create_channel_callee

EXTERN ASMDISP_EXOS_CREATE_CHANNEL_CALLEE

exos_create_channel:
_exos_create_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_create_channel_callee + ASMDISP_EXOS_CREATE_CHANNEL_CALLEE

