; Small C startup module for Running Compiled C from BBC BASIC
; ZCC for z88 converted by Dominic Morris <djm@jb.man.ac.uk>
; Written August 1998
; Updated for small C+ continuously through September
; Changes by DG implemented 28/9/98
; GFX Stuff added 30/9/98
; 19/10/98 Atexit stuff added
; 27/11/98 Atexit stuff rejigged to allow 32 levels of atexit
;
; 29/2/99  Added the include for zcc_opt so we now if float package
;          required or not..
;
; 14/3/99  Renamed the printf vars to smc_pf*
;
; 1/4/99   Changing to allow application startup
;
; - - - - - - - -
;
; $Id: z88_crt0.asm,v 1.17 2016-07-15 19:35:07 dom Exp $
;
; - - - - - - - -


    MODULE  z88_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main		;main() is always external to crt0 code


    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 8
    defc	TAR__no_ansifont = 1
    IFNDEF ansicolumns
        defc DEFINED_ansicolumns = 1
        defc ansicolumns = CONSOLE_COLUMNS
    ENDIF

    defc	__CPU_CLOCK = 3276800

;-------
; Select which particular startup we want
;-------

    IF (startup=1)
        INCLUDE "target/z88/classic/z88b_crt0.asm"
    ENDIF
    IF (startup=2)
        INCLUDE "target/z88/classic/z88a_crt0.asm"
    ENDIF
    IF (startup=4)
        INCLUDE "target/z88/classic/z88d_crt0.asm"
    ENDIF
    IF (startup=5)
        INCLUDE "target/z88/classic/z88s_crt0.asm"
    ENDIF
    IF (startup=6)
        INCLUDE "target/z88/classic/z88s5_crt0.asm"
    ENDIF
