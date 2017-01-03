;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcalld.asm,v 1.4 2017-01-03 00:11:31 aralbrec Exp $
;

		PUBLIC	farcalld
      PUBLIC   _farcalld
		EXTERN	farcall
		
.farcalld
._farcalld
	jp	farcall
