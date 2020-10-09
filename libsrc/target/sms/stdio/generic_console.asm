;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_ioctl


		EXTERN		__tms9918_cls
		EXTERN		__tms9918_scrollup
		EXTERN		__tms9918_printc
		EXTERN		__tms9918_console_ioctl
                EXTERN          __tms9918_set_ink
                EXTERN          __tms9918_set_paper
                EXTERN          __tms9918_set_attribute


    		EXTERN		asm_load_palette_gamegear
    		EXTERN		asm_load_palette
		EXTERN		__GAMEGEAR_ENABLED

		EXTERN		generic_console_caps

		INCLUDE		"ioctl.def"

		PUBLIC          CLIB_GENCON_CAPS
		EXTERN		__tms9918_CLIB_GENCON_CAPS
       		defc            CLIB_GENCON_CAPS = __tms9918_CLIB_GENCON_CAPS


		defc generic_console_set_attribute = __tms9918_set_attribute
		defc generic_console_set_paper   = __tms9918_set_paper
		defc generic_console_set_ink     = __tms9918_set_ink
		defc generic_console_cls = __tms9918_cls
		defc generic_console_printc = __tms9918_printc
		defc generic_console_scrollup = __tms9918_scrollup


generic_console_ioctl:
        cp      IOCTL_GENCON_SET_MODE
	jp	nz,__tms9918_console_ioctl
	call	__tms9918_console_ioctl
	ret	c
	; We set a screenmode, on the gamegear we should set a palette
	; We can't tell if we are on a gamegear, so do our best...
	ld	a,__GAMEGEAR_ENABLED
	and	a
	jr	z,set_sms_palette
	ld	hl,gg_palette
	ld	b,16
	ld	c,32
	call	asm_load_palette_gamegear
return:
        and     a
        ret

; For the gamegear in SMS mode we need to set palette entries 16-31
set_sms_palette:
	ld	hl,sms_palette
	ld	c,16
	ld	b,16
	call	asm_load_palette
	jr	return


	SECTION rodata_clib

sms_palette:
	defb	0x00, 0x00, 0x08, 0x0c, 0x10, 0x30, 0x01, 0x3c, 0x02, 0x03, 0x05, 0x0f, 0x04, 0x33, 0x15, 0x3f


gg_palette:
        defw 0x0000             ;transparent
        defw 0x0000             ;00 00 00
        defw 0x00a0             ;00 aa 00
        defw 0x00f0             ;00 ff 00
        defw 0x0500             ;00 00 55
        defw 0x0f00             ;00 00 ff
        defw 0x0005             ;55 00 00
        defw 0x0ff0             ;00 ff ff
        defw 0x000a             ;aa 00 00
        defw 0x000f             ;ff 00 00
        defw 0x0055             ;00 55 55
        defw 0x00ff             ;ff ff 00
        defw 0x0050             ;00 55 00
        defw 0x0f0f             ;ff 00 ff
        defw 0x0555             ;55 55 55
        defw 0x0fff             ;ff ff ff
