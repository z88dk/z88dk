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

;-------
; Include zcc_opt.def to find out information about us
;-------

	defc	crt0 = 1
	INCLUDE "zcc_opt.def"


;-------
; Some general scope declarations
;-------

	EXTERN    _main		;main() is always external to crt0 code
	PUBLIC    cleanup		;jp'd to by exit()
	PUBLIC    l_dcal		;jp(hl)


	PUBLIC    processcmd	;Processing <> commands


	PUBLIC	_cpfar2near	;Conversion of far to near data



;-------
; Select which particular startup we want
;-------

; User specified startup type, so do as they wish then drop out otherwise
; Use -startup=1 for basic      } (For sake of completeness only - don't
;     -startup=2 for app        } use them!)
;     -startup=3 for code snippets
        IF (startup=1)
                INCLUDE "z88b_crt0.asm"
        ENDIF
        IF (startup=2)
                INCLUDE "z88a_crt0.asm"
        ENDIF
	IF (startup=4)
		INCLUDE "z88d_crt0.asm"
	ENDIF
	IF (startup=5)
		INCLUDE "z88s_crt0.asm"
	ENDIF

