;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_open_channel(unsigned char ch_number, char *device);
;
;
;	$Id: exos_open_channel.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;

	XLIB    exos_open_channel

	LIB     exos_open_channel_callee

XREF ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

exos_open_channel:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp exos_open_channel_callee + ASMDISP_EXOS_OPEN_CHANNEL_CALLEE

