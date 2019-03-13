;
;	PX-8 routines
;	by Stefano Bodrato, 2019
;
;
;	$Id: subcpu_function.asm $
;
;	int subcpu_function(char *sndpkt, int sndpkt_sz, char *rcvpkt, int rcvpkt_sz);
;
;  Example to read font definition of a given character, *this macro requires literal static values for char*
;  e.g. LCD_GETFONT("A", myfont)
;  #define LCD_GETFONT(c, buf) subcpu_function( 8, buf, 2, "\033" c)
;


	SECTION	code_clib
	
	PUBLIC	subcpu_function
	PUBLIC	_subcpu_function
	
	EXTERN	subcpu_call
	
subcpu_function:
_subcpu_function:

.asmentry
	ld	hl,2
	add	hl,sp
	jp	subcpu_call
