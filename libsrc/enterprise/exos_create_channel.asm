;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_create_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_create_channel.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC    exos_create_channel

	EXTERN     exos_create_channel_callee

EXTERN ASMDISP_EXOS_CREATE_CHANNEL_CALLEE

exos_create_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_create_channel_callee + ASMDISP_EXOS_CREATE_CHANNEL_CALLEE

