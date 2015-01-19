;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_redirect_channel(unsigned char main_channel, unsigned char secondary_channel);
;
;
;	$Id: exos_redirect_channel.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC    exos_redirect_channel

	EXTERN     exos_redirect_channel_callee

EXTERN ASMDISP_EXOS_REDIRECT_CHANNEL_CALLEE

exos_redirect_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_redirect_channel_callee + ASMDISP_EXOS_REDIRECT_CHANNEL_CALLEE

