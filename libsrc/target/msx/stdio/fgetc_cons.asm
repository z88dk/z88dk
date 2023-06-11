;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
        EXTERN	msxbios
        EXTERN  __CLIB_FIRMWARE_KEYBOARD_CLICK


IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
        INCLUDE "target/msx/def/msxbasic.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
        INCLUDE "target/svi/def/svibasic.def"
ENDIF


.fgetc_cons
._fgetc_cons

	push	ix
	ld	ix,CHGET
	call	msxbios
	pop	ix

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret


        SECTION code_crt_init

        ld      a,__CLIB_FIRMWARE_KEYBOARD_CLICK
        cp      -1
        jr      z,no_set_click
        ld      (CLIKSW),a
no_set_click:

        ld	a,1
        ld	(CSRSW),a		; disable cursor, it could put garbage on screen in gfx mode


