;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;

		XLIB	farcalld
		LIB	farcall
		
.farcalld
	jp	farcall