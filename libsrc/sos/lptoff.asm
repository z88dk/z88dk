;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; void lptoff()
;
;       $Id: lptoff.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC lptoff

lptoff:
   jp	$1fd6
