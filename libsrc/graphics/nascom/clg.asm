;
;       NASCOM Graphics Functions
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - June 2003
;
;
;       $Id: clg.asm,v 1.1 2003-08-22 15:27:40 dom Exp $
;


        XLIB    clg
        LIB     ansi_cls

.clg
        jp      ansi_cls

