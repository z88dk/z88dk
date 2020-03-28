;
; 	ANSI Video handling for the MSX
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Sept. 2017
;
;
;	$Id: f_ansi_cls_nobios.asm $
;

	SECTION	code_clib
        PUBLIC    ansi_cls
        PUBLIC    _ansi_cls
		
        EXTERN	msx_set_mode

        EXTERN	msx_color
        EXTERN	__tms9918_attribute
        EXTERN	__tms9918_border

        EXTERN	FILVRM

        INCLUDE	"graphics/grafix.inc"


.ansi_cls
._ansi_cls

	ld    hl,2		; set graphics mode
	call  msx_set_mode

	ld a,(__tms9918_attribute)
	rra
	rra
	rra
	rra
	and $0F
        ld  l,a
        ld  h,0
	push hl	; ink

	ld a,(__tms9918_attribute)
	and $0F
	ld	l,a
	push hl		; paper

	ld a,(__tms9918_border)
        and 15
        ld l,a
        push hl	;border


	call msx_color
	pop hl
	pop hl
	pop hl
	

	ld bc,6144

	ld a,(__tms9918_attribute)

	ld hl,8192
	
	push bc
	call FILVRM
	pop bc		; clear VRAM picture area
	xor a
	ld	h,a
	ld	l,a
	jp	FILVRM

