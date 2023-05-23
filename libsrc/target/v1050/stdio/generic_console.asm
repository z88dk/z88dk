
; V1050 <> ADM3A terminal code grabber and converter
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

    EXTERN  asm_load_charset

    EXTERN __console_x
    EXTERN __console_y
    ;EXTERN generic_console_flags

    EXTERN  v1050_sendchar

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_UDGS | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_INVERSE | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE 

generic_console_cls:
		ld l,0x0C
		jp v1050_sendchar

generic_console_set_attribute:
		; Set text attribute (underline, inverse, bold)

		;rla		; deal with underline bit
		rra
		jr nc,noinv

		ld l,0x9B		; CSI = "ESC["
		call v1050_sendchar
		ld l,'7'
		call v1050_sendchar
		ld l,'m'
		call v1050_sendchar
		ret
noinv:
		ld l,0x9B		; CSI = "ESC["
		call v1050_sendchar
		ld l,'0'
		call v1050_sendchar
		ld l,'m'
		call v1050_sendchar
		ret

		
; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:

		push af

		; force cursor position
		ld l,27
		call v1050_sendchar
		ld l,'='
		call v1050_sendchar
		ld a,(__console_y)
		add 32
		ld l,a
		call v1050_sendchar
		ld a,(__console_x)
		add 32
		ld l,a
		call v1050_sendchar

		; send actual character
		pop af
		
		cp 128
		jr c,noudg
		
		add 32

;		push af
;		ld l,27
;		call v1050_sendchar
;		ld l,'('
;		call v1050_sendchar
;		ld l,'1'	; Select alternate font
;		call v1050_sendchar
;		pop af
		
noudg:

;		push af
;		ld l,27
;		call v1050_sendchar
;		ld l,'('
;		call v1050_sendchar
;		ld l,'0'	; Select standard font
;		call v1050_sendchar
;		pop af
		
		ld l,a
		jp v1050_sendchar


; a = ioctl
; de = arg
generic_console_ioctl:

        ex      de,hl
        ld      c,(hl)  ;bc = where we point to
        inc     hl
        ld      b,(hl)

        cp	IOCTL_GENCON_SET_FONT32
        jr	nz,check_set_udg

        ;ld      (generic_console_font32),bc
        ld      l,c
        ld      h,b
        ld      b,96
        ld      c,0
        call    asm_load_charset
success:
        and     a
        ret

check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,failure

		ld l,27
		call v1050_sendchar
		ld l,')'
		call v1050_sendchar
		ld l,'1'	; Select G1 for the extended font
		call v1050_sendchar

        ;ld      (generic_console_udg32),bc
        ld      l,c
        ld      h,b
        ld      b,96
        ld      c,96
        call    asm_load_charset
		
        jr      success

failure:
        scf
        ret



generic_console_scrollup:

		; place cursor at the bottom row..
		ld l,27
		call v1050_sendchar
		ld l,'='
		call v1050_sendchar
		ld l,32+24
		call v1050_sendchar
		ld l,32
		call v1050_sendchar
		; and send LF
		ld l,10
		jp v1050_sendchar
		

generic_console_set_ink:
generic_console_set_paper:
ret



    SECTION code_crt_init

    EXTERN  CRT_FONT
    EXTERN  asm_load_charset

    ld      hl,CRT_FONT
    ld      a,h
    or      l
    jr      z,no_custom_font
    ld      b,96
    ld      c,0
    call    asm_load_charset
no_custom_font:


