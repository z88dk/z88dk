;
;       Small C+ Library Functions
;
;       Memory Functions
;
;       The routines in this directory are a little kludgey to say the
;       least, but at least they give you a heap from BBC BASIC
;
;       These routines were found on an MSX homepage from the net
;
;       Added to Z88dk archive 1/3/99
;
;       int getlarge()
;
;
; $Id: getlarge.asm,v 1.2 2001-04-18 14:59:40 stefano Exp $
;

                XLIB    getlarge
                LIB     getfree

;
;       Find the largest free block
;

.getlarge
        call    getfree
        ex      de,hl
        ret

