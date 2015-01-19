;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_open_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_open_channel.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC    exos_open_channel

	EXTERN     exos_open_channel_callee

EXTERN ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

exos_open_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_open_channel_callee + ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

