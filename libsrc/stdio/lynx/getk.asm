;
;       Camputers Lynx C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2014
;
;
;	$Id: getk.asm,v 1.1 2014-07-21 12:39:53 stefano Exp $
;


		XLIB	getk

.getk
        call    $9bd
        ld      l,a
        ld      h,0
        ret
