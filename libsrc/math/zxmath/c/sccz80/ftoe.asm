;
;
;       ZX Maths Routines
;
;       12/12/02 - Stefano Bodrato
;
;       $Id: ftoe.asm,v 1.3 2016-06-22 19:59:18 dom Exp $
;
;

;	Just a dirty placeholder..   :oP

                SECTION  code_fp
		PUBLIC	ftoe
		EXTERN	ftoa
		
.ftoe
		jp	ftoa
