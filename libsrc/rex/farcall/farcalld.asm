;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcalld.asm,v 1.2 2002-04-10 20:16:25 dom Exp $
;

		XLIB	farcalld
		LIB	farcall
		
.farcalld
	jp	farcall
