;
;       Fast CLS for the M100
;       Stefano - 2020
;
;
;	$Id: clg.asm $
;

		SECTION code_clib
                PUBLIC    clg
                PUBLIC    _clg
				
			EXTERN w_pixeladdress
	INCLUDE "target/m100/def/romcalls.def"
;		INCLUDE  "target/kc/def/caos.def"

.clg
._clg
	ROMCALL
	defw	CLS
	ret
