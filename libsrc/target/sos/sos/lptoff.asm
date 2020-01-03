;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; void lptoff()
;
;       $Id: lptoff.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC lptoff
PUBLIC _lptoff

lptoff:
_lptoff:
   jp	$1fd6
