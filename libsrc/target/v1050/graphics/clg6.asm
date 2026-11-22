
    SECTION code_clib

    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  fputc_cons
    EXTERN  loadudg6
    EXTERN  v1050_sendchar

    EXTERN  generic_console_cls

;
;	$Id: clg6.asm $
;

; ******************************************************************
;
;	Clear graphics area,
;

clg:
_clg:
    call    loadudg6
    call    generic_console_cls
	
	; Disable auto-linefeed
	ld      l,27
	call    v1050_sendchar
	ld      l,';'
	call    v1050_sendchar
	ld      l,'D'
	jp      v1050_sendchar
