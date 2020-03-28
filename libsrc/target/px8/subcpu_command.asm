;
;	PX-8 routines
;	by Stefano Bodrato, 2019
;
;	'cmdsequence' is a byte list containing 
;	the number of parameters (bytes), the function code and its parameters
;	i.e.  char cursor_noflash[]={1,0x16,5};
;
;	$Id: subcpu_command.asm $
;
;	int subcpu_command(char *cmdsequence);
;


	SECTION	code_clib
	
	PUBLIC	subcpu_command
	PUBLIC	_subcpu_command
	
	EXTERN	subcpu_call
	
subcpu_command:
_subcpu_command:

.asmentry
	ld	a,(hl)
	inc hl
	ld	(packet),hl
	inc a
	ld	(packet+2),a
		
	ld	hl,packet
	jp	subcpu_call

	

	SECTION	bss_clib
	
rcvpkt:		; foo return addr, it will be rewritten on the next call
packet:
	defw	0		; sndpkt
	defw	0		; packet sz
	defw	rcvpkt	; packet addr expected back from the slave CPU
	defw	1		; size of the expected packet being received ('bytes'+1)

