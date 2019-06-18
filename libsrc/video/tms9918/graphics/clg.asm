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
	EXTERN	__tms9918_screen_mode
	EXTERN	msx_set_mode

clg:
_clg:
	ld    a,(__tms9918_screen_mode)
	and   a
	jr    nz,notext
	
	; Enter in GFX mode 2 by default if in text mode
	ld    hl,2
	call  msx_set_mode
	
notext:
	jp    __tms9918_cls
