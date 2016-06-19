;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_open_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_open_channel.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC    exos_open_channel
	PUBLIC    _exos_open_channel

	EXTERN     exos_open_channel_callee

EXTERN ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

exos_open_channel:
_exos_open_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_open_channel_callee + ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

