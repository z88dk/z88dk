
	SECTION code_clib

	PUBLIC	clg
	PUBLIC	_clg

	EXTERN    v1050_sendchar


;
;	$Id: clg.asm $
;

; ******************************************************************
;
;	Clear graphics area, 
;

.clg
._clg
		; Set terminal to transparent mode for debugging purposes
;		ld l,27
;		call v1050_sendchar
;		ld l,';'
;		call v1050_sendchar
;		ld l,'T'
;		call v1050_sendchar

		ld l,12
		jp v1050_sendchar
