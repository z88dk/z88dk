
	SECTION code_clib

	PUBLIC	clg
	PUBLIC	_clg

	EXTERN    mbc_sendchar


;
;	$Id: clg.asm $
;

; ******************************************************************
;
;	Clear graphics area, 
;

.clg
._clg
		ld l,26
		jp mbc_sendchar

