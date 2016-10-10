;
;       Fast CLS for the Robotron KC85/2..5
;       Stefano - Sept 2016
;
;
;	$Id: clg.asm,v 1.1 2016-10-10 07:09:14 stefano Exp $
;

		SECTION code_clib
                PUBLIC    clg

		INCLUDE  "caos.def"

.clg
._clg

;	ld      a,7			; Fore color
;	ld      (FARB),a
	ld      a,7
	ld      (COLOR),a
;	ld      l,a
	
;    call PV1
;    defb FNCOLORUP
		
    ld  a,$0c ; clear screen    
    call PV1
    defb FNCRT
	
    ret
