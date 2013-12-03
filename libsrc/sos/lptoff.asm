;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; void lptoff()
;
;       $Id: lptoff.asm,v 1.1 2013-12-03 13:42:32 stefano Exp $
;


XLIB lptoff

lptoff:
   jp	$1fd6
