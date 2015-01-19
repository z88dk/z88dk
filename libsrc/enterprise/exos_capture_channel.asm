;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_capture_channel(unsigned char main_channel, unsigned char secondary_channel);
;
;
;	$Id: exos_capture_channel.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC    exos_capture_channel

	EXTERN     exos_capture_channel_callee

EXTERN ASMDISP_EXOS_CAPTURE_CHANNEL_CALLEE

exos_capture_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_capture_channel_callee + ASMDISP_EXOS_CAPTURE_CHANNEL_CALLEE

