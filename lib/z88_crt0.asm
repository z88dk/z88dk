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

                MODULE  z88_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

                XREF    _main

;
; Some variables which are needed for both app and basic startup
;

        XDEF    cleanup
        XDEF    l_dcal

;Graphic function XDEFS..

        XDEF    coords
        XDEF    base_graphics
        XDEF    gfx_bank

        XDEF    int_seed

;Exit variables

        XDEF    exitsp
        XDEF    exitcount

;For stdin, stdout, stder

        XDEF    __sgoioblk

; For topics etc
        
        XDEF    processcmd

; Near heap stuff
	XDEF	heaplast
	XDEF	heapblocks

; Conversion of far to near
	XDEF	_cpfar2near

; Printf core
	XDEF	_vfprintf

; Now, getting to the real stuff now!

IF DEFINED_startup
; User specified startup type, so do as they wish then drop out otherwise
; Use -startup=1 for basic      } (For sake of completeness only - don't
;     -startup=2 for app        } use them!)
;     -startup=3 for code snippets
        IF (startup=1)
                INCLUDE "#bas_crt0.asm"
        ENDIF
        IF (startup=2)
                INCLUDE "#app_crt0.asm"
        ENDIF
        IF (startup=3)
                INCLUDE "#rel_crt0.asm"
        ENDIF
	IF (startup=4)
		INCLUDE "#dev_crt0.asm"
	ENDIF

ELSE 


        IF NEED_appstartup
                INCLUDE "#app_crt0.asm"
        ELSE

                INCLUDE "#bas_crt0.asm"
        ENDIF
ENDIF



