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
; $Id: z88_crt0.asm,v 1.4 2001-10-15 22:42:40 dom Exp $
;
; - - - - - - - -


	MODULE  z88_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

	INCLUDE "zcc_opt.def"


;-------
; Some general scope declarations
;-------

	XREF    _main		;main() is always external to crt0 code
	XDEF    cleanup		;jp'd to by exit()
	XDEF    l_dcal		;jp(hl)

	XDEF    coords		;Current graphics xy coords
	XDEF    base_graphics	;Address of graphics map
	XDEF    gfx_bank	;Bank for this

	XDEF    int_seed	;Integer rand() seed


	XDEF    exitsp		;Pointer to atexit() stack
	XDEF    exitcount	;Number of atexit() functions registered

	XDEF    __sgoioblk	;std* control block

	XDEF    processcmd	;Processing <> commands

	XDEF	heaplast	;Near malloc heap variables
	XDEF	heapblocks	;

	XDEF	_cpfar2near	;Conversion of far to near data

	XDEF	_vfprintf	;jp to printf() core routine

	XDEF	snd_asave	;sound
	XDEF	snd_tick	;sound

;-------
; Select which particular startup we want
;-------
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
