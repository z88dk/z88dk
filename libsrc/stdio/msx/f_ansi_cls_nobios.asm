;
; 	ANSI Video handling for the MSX
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Oct. 2017
;
;
;	$Id: f_ansi_cls_nobios.asm $
;

	SECTION	code_clib
        PUBLIC    ansi_cls
        PUBLIC    _ansi_cls
		
        EXTERN	msx_set_mode
        EXTERN	msx_color
        EXTERN	msx_attr
        EXTERN	FILVRM

        INCLUDE	"graphics/grafix.inc"


.ansi_cls
._ansi_cls

	ld    hl,2		; set graphics mode
	call  msx_set_mode

	ld a,(msx_attr)
	and $0F
	ld	h,0
	ld	l,a
	
	push hl		; border
	push hl		; paper
	ld a,(msx_attr)
	rra
	rra
	rra
	rra
	and $0F
	push hl	; ink
	call msx_color
	pop hl
	pop hl
	pop hl
	

	ld bc,6144

	ld a,(msx_attr)

	ld hl,8192
	
	push bc
	call FILVRM
	pop bc		; clear VRAM picture area
	xor a
	ld	h,a
	ld	l,a
	jp	FILVRM

