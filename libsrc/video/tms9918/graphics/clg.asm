;
;       Clear Graphics Screen
;
;       MSX version by Stefano Bodrato, December 2007
;
;	$Id: clg.asm $
;

	SECTION	code_clib
        PUBLIC  clg
        PUBLIC  _clg
	EXTERN	__tms9918_cls

	defc	clg = __tms9918_cls
	defc	_clg = __tms9918_cls
