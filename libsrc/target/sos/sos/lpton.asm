;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; void lpton()
;
;       $Id: lpton.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC lpton
PUBLIC _lpton

lpton:
_lpton:
   jp	$1fd9
