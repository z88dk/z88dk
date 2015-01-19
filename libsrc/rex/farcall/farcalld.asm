;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcalld.asm,v 1.3 2015-01-19 01:33:06 pauloscustodio Exp $
;

		PUBLIC	farcalld
		EXTERN	farcall
		
.farcalld
	jp	farcall
