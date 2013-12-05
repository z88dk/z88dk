;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;; void lptoff()
;
;       $Id: lptoff.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
;


XLIB lptoff

lptoff:
   jp	$1fd6
