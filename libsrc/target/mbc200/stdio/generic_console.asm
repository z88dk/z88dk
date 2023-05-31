
; Sanyo <> ADM3A terminal code grabber and converter
; Stefano, May 2023


	SECTION	code_clib
	INCLUDE	"ioctl.def"

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_ioctl
	
	PUBLIC  __sanyo_attr


        EXTERN __console_x
        EXTERN __console_y
        ;EXTERN generic_console_flags

        EXTERN    mbc_sendchar
        EXTERN  __console_h

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_INVERSE | CAP_GENCON_UNDERLINE 


__sanyo_attr:
		defb 0

generic_console_cls:
		ld l,26
		jp mbc_sendchar


generic_console_set_attribute:
		; Set text attribute (underline, inverse)
		; It is fully working when in 33 rows text mode only
		ld e,a
		and 4	; underline
		rla		; deal with underline bit
		rr e
		jr nc,noinv
		add 4   ; set inverse bit
noinv:
		ld (__sanyo_attr),a
		ld l,27
		call mbc_sendchar
		ld l,'t'
		call mbc_sendchar
		ld a,(__sanyo_attr)
		ld l,a
		call mbc_sendchar
		ret

		
; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:

		ex af,af

		; force cursor position
		ld l,27
		call mbc_sendchar
		ld l,'='
		call mbc_sendchar
		ld a,(__console_y)
		add 32
		ld l,a
		call mbc_sendchar
		ld a,(__console_x)
		add 32
		ld l,a
		call mbc_sendchar

		; send actual character
		ex af,af
		ld l,a
		jp mbc_sendchar


; a = ioctl
; de = arg
generic_console_ioctl:
        ex      de,hl
        ld      c,(hl)  ;bc = where we point to
        inc     hl
        ld      b,(hl)
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure

		ld l,27
		call mbc_sendchar
		ld a,c
		ld l,'M'
		dec a
		ld a,33
		ld (__console_h),a
		jr nz,lines33
		ld l,'A'
		ld a,40
		ld (__console_h),a
lines33:
		call mbc_sendchar
		ld l,26		; CLS
		call mbc_sendchar

        and     a
        ret
failure:
        scf
        ret



generic_console_scrollup:

		; place cursor at the bottom row..
		ld l,27
		call mbc_sendchar
		ld l,'='
		call mbc_sendchar
		ld a,(__console_h)
		add 32
		ld l,a
		call mbc_sendchar
		ld l,32
		call mbc_sendchar
		; and send LF
		ld l,10
		jp mbc_sendchar
		

generic_console_set_ink:
generic_console_set_paper:
ret
