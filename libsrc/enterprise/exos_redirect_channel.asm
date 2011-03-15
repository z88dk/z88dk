;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_redirect_channel(unsigned char main_channel, unsigned char secondary_channel);
;
;
;	$Id: exos_redirect_channel.asm,v 1.1 2011-03-15 14:34:08 stefano Exp $
;

	XLIB    exos_redirect_channel

	LIB     exos_redirect_channel_callee

XREF ASMDISP_EXOS_REDIRECT_CHANNEL_CALLEE

exos_redirect_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_redirect_channel_callee + ASMDISP_EXOS_REDIRECT_CHANNEL_CALLEE

