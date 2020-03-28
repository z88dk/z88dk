;
;	MC-1000 graphics library
;
;	$Id: clg.asm $
;

;-----------  GFX init  -------------

	SECTION	  code_clib

	PUBLIC	clg
	PUBLIC	_clg

	PUBLIC	ansi_cls
	PUBLIC	_ansi_cls

	EXTERN	generic_console_ioctl
	INCLUDE	"ioctl.def"
	

.clg
._clg
.ansi_cls
._ansi_cls
        ld      hl,1
        push    hl
        ld      hl,0
        add     hl,sp
        ex      de,hl
        ld      a,IOCTL_GENCON_SET_MODE
        call    generic_console_ioctl
        pop     hl
        ret

