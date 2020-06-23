;
;       Clear Graphics Screen
;
;       TIKI-100 version by Stefano Bodrato, Sept 2015
;
;	$Id: clg.asm,v 1.2 2016-07-02 09:01:36 dom Exp $
;

	SECTION		code_graphics
	PUBLIC		clg
	PUBLIC		_clg
	EXTERN		generic_console_cls

	defc	clg = generic_console_cls
	defc	_clg = clg
