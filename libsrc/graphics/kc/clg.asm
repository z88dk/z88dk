;
;       Fast CLS for the Robotron KC85/2..5
;       Stefano - Sept 2016
;
;
;	$Id: clg.asm $
;

		SECTION code_clib
                PUBLIC    clg
                PUBLIC    _clg
				
			EXTERN w_pixeladdress

;		INCLUDE  "target/kc/def/caos.def"

.clg
._clg

	ld	de,0
	ld h,d
	ld l,e
	
	call	w_pixeladdress
	ld h,d
	ld l,e
	inc	de
	
	ld	bc,10239
	ldir
	
;	ld      a,7
;	ld      (COLOR),a
;	
;    ld  a,$0c ; clear screen    
;    call PV1
;    defb FNCRT
	
    ret
