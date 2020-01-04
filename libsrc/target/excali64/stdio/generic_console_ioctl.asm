
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	copy_font
	EXTERN	__excali64_font32
	EXTERN	__excali64_udg32
	EXTERN	__excali64_mode

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR



; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
	ld	(__excali64_font32),bc
	ld	hl,$6020		;96 chars, start from 32
	ld	a,(__excali64_mode)
	cp	2
	call	nz,copy_font
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,check_mode
	ld	(__excali64_udg32),bc
	ld	hl,$8080		;128 chars, start from 128
	ld	a,(__excali64_mode)
	cp	2
	call	nz,copy_font
	jr	success

check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	ld	l,80
	ld	h,24
	ld	de,screen_80x25
	and	a
	jr	z,set_mode
	ld	l,40
	ld	h,24
	ld	de,screen_40x25
	cp	1
	jr	nz,failure
set_mode:
	ld	(__console_w),hl
	ld	c,0
	ld	b,16
vduloop:
	ld	a,c
	out	($30),a
	ld	a,(de)
	out	($31),a
	inc	de
	inc	c
	djnz	vduloop
	call	generic_console_cls
	jr	success
failure:
	scf
dummy_return:
	ret


	SECTION		rodata_clib

screen_40x25:
        defb    0x3f    ; -> FC66  ......Total No. of character intervals in horiz scan
        defb    0x28    ; -> FC67  ......No. of characters displayed in a horiz scan
        defb    0x31    ; -> FC68  ......Horiz sync position    (values between 0x31 and 0x2F were used to center the display depending on the video monitor, possibly older ROMs had different values)
        defb    0x05    ; -> FC69  ......horiz sync pulse width
        defb    0x18    ; -> FC6A  ......Total No. of character lines
        defb    0x0c    ; -> FC6B  ......Adjust for vertical sync
        defb    0x18    ; -> FC6C  ......No of lines displayed by CRTC
        defb    0x18    ; -> FC6D  ......Vertical sync position
        defb    0x00    ; -> FC6E  ......Interlace mode
        defb    0x0b    ; -> FC6F  ......crtc reg.9
        defb    0x20    ; -> FC70  ......crtc reg.10    -> Cursor blinking
        defb    0x0b    ; -> FC71  ......crtc reg 11
        defb    0x00    ; -> FC72  ......crtc reg 12
        defb    0x00    ; -> FC73  ......crtc reg 13
        defb    0x00    ; -> FC74  ......crtc reg 14    -> cursor position (high byte)
        defb    0x00    ; -> FC75  ......crtc reg 15    -> cursor position (low byte)

screen_80x25:
        defb    0x7f    ; -> FC76  ......Total No. of character intervals in horiz scan
        defb    0x50    ; -> FC77  ......No. of characters displayed in a horiz scan
        defb    0x62    ; -> FC78  ......Horiz sync position    (see above about video display centering)
        defb    0x0a    ; -> FC79  ......horiz sync pulse width
        defb    0x18    ; -> FC7A  ......Total No. of character lines
        defb    0x0c    ; -> FC7B  ......Adjust for vertical sync
        defb    0x18    ; -> FC7C  ......No of lines displayed by CRTC
        defb    0x18    ; -> FC7D  ......Vertical sync position
        defb    0x00    ; -> FC7E  ......Interlace mode
        defb    0x0b    ; -> FC7F  ......crtc reg.9
        defb    0x20    ; -> FC80  ......crtc reg.10    -> Cursor blinking
        defb    0x0b    ; -> FC81  ......crtc reg 11
        defb    0x00    ; -> FC82  ......crtc reg 12
        defb    0x00    ; -> FC83  ......crtc reg 13
        defb    0x00    ; -> FC84  ......crtc reg 14    -> cursor position (high byte)
        defb    0x00    ; -> FC85  ......crtc reg 15    -> cursor position (low byte)

