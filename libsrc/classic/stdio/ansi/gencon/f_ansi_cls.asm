;
; 	ANSI Video handling for generic console
;
; 	CLS - Clear the screen
;	

	MODULE __gencon_ansi_cls
        SECTION code_clib
	PUBLIC	__gencon_ansi_cls
	EXTERN  generic_console_cls

	defc	__gencon_ansi_cls = generic_console_cls

