;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_create_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_create_channel.asm,v 1.1 2011-03-14 11:36:48 stefano Exp $
;

	XLIB    exos_create_channel

	LIB     exos_create_channel_callee

XREF ASMDISP_EXOS_CREATE_CHANNEL_CALLEE

exos_create_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_create_channel_callee + ASMDISP_EXOS_CREATE_CHANNEL_CALLEE

