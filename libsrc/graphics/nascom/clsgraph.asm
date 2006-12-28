;
;       NASCOM Graphics Functions
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - June 2003
;
;
;       $Id: clsgraph.asm,v 1.1 2006-12-28 18:08:36 stefano Exp $
;


        XLIB    cleargraphics
        LIB     ansi_cls

.cleargraphics
        jp      ansi_cls

