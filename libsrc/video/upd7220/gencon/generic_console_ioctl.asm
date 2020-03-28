
        MODULE  upd7220_console_ioctl

        SECTION code_clib
        INCLUDE "ioctl.def"

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  __upd7220_cls
        EXTERN  __upd7220_set_pitch
        EXTERN  __upd7220_command
        PUBLIC  __upd7220_CLIB_GENCON_CAPS
        EXTERN  __console_w
 
        INCLUDE "video/upd7220/upd7220.inc"


IF UPD7220_EXPORT_DIRECT = 1
        PUBLIC  generic_console_ioctl

        defc    generic_console_ioctl = __upd7220_console_ioctl

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = __upd7220_CLIB_GENCON_CAPS
ENDIF

        defc    __upd7220_CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR

; a = ioctl
; de = arg
__upd7220_console_ioctl:
        ex      de,hl
        ld      c,(hl)        ;bc = where we point to
        inc     hl
        ld      b,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
        ld      (generic_console_font32),bc
set_font_success:
        ;call    set_font
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,check_mode
        ld      (generic_console_udg32),bc
        jr      set_font_success
check_mode:
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
        ld      a,c
        ld      l,40        ;Width
        ld      h,$12       ;BIC screeen mode
        ld      de,BS40COL
        and     a
        jr      z,set_mode
        ld      l,80
        ld      de,BS80COL
        ld      h,$10
set_mode:
        ld      a,l
        ld      (__console_w),a
        ld      a,h
        out     (A5105_SCREEN_MODE),a
        ex      de,hl
        ld      e,2
        call    write_command
        ld      hl,COMMON_INIT
        ld      e,17
        call    write_command
        ld      a,UPD7220_COMMAND_BCTRL | 1	;enable screen
        out     (UPD_7220_COMMAND_WRITE),a
        call    __upd7220_cls
        jr      success
failure:
        scf
        ret


; hl = start
;  e = number of commands
write_command:
    ld      a,(hl)      ;command
    inc     hl
    ld      b,(hl)      ;number of parameters
    inc     hl
    inc     b
    dec     b
    call    nz,__upd7220_command
    dec     e
    jr      nz,write_command
    ret


    SECTION     rodata_clib

BS80COL:
	DEFB	UPD7220_COMMAND_SYNC
	DEFB	8
	DEFB	$14
	DEFB	$4e             ;80 column mode
	DEFB	$C1
	DEFB	$13
	DEFB	$0C
	DEFB	$29
	DEFB	$fa     ; 0C8H
	DEFB	$2c     ; 0A4H
	DEFB	UPD7220_COMMAND_PITCH
	DEFB	1
	DEFB	80

; This reset sequence was lifted from the BIC ROM
BS40COL:
	DEFB	UPD7220_COMMAND_SYNC
	DEFB	8
	DEFB	$14
	DEFB	$26             ;40 column mode
	DEFB	$C1
	DEFB	$13
	DEFB	$0c
	DEFB	$29
	DEFB	$fa     ; 0C8H
	DEFB	$2c     ; 0A4H
	DEFB	UPD7220_COMMAND_PITCH
	DEFB	1
	DEFB	40

COMMON_INIT:
	DEFB	UPD7220_COMMAND_CCHAR	;1 Zeile = 8 FS-Zeilen
	DEFB	3	;Kursor stehend 1.bis 8. FS-Zeile
	DEFB	07H                     ;Disable display of cursor, 8 lines per row
	DEFB	0A0H                    ;
	DEFB	39H
	DEFB	UPD7220_COMMAND_VSYNC	;GDC in Mastermode
	DEFB	0
	DEFB	UPD7220_COMMAND_ZOOM	;ZOOM ist 0
	DEFB	1
	DEFB	0
	DEFB	UPD7220_COMMAND_PRAM	;Bildbereich 1 ab Adresse 0 , 200 FS-Zeilen
	DEFB	4
	DEFW	0
	DEFB	80H
	DEFB	0CH
	DEFB	UPD7220_COMMAND_CURS	;Kursor auf Adresse 0
	DEFB	3
	DEFW	0
	DEFB	0
	DEFB	UPD7220_COMMAND_MASK	;Maske FFFF alle Bits beschreiben
	DEFB	2
	DEFW	0FFFFH
	DEFB	UPD7220_COMMAND_FIGS	;Screibrichtung 2 Anzahl 4000H-1 (Textbereich)
	DEFB	3
	DEFB	2
	DEFW	3FFFH
	DEFB	UPD7220_COMMAND_WDAT	;Schreiben SPACE,gelb auf schwarz
	DEFB	2
	DEFB	20H
	DEFB	6
	DEFB	UPD7220_COMMAND_FIGS	;s.o. (1.Grafikbereich)
	DEFB	3
	DEFB	2
	DEFW	03FFFH
	DEFB	UPD7220_COMMAND_WDAT	;Schreiben Farbe 0 (Paper)
	DEFB	2
	DEFW	0
	DEFB	UPD7220_COMMAND_FIGS	;s.o. (2.Grafikbereich)
	DEFB	3
	DEFB	2
	DEFW	03FFFH
	DEFB	UPD7220_COMMAND_WDAT	;s.o.
	DEFB	2
	DEFW	0
	DEFB	UPD7220_COMMAND_FIGS	;s.o. (3.Grafikbereich)
	DEFB	3
	DEFB	2
	DEFW	03FFFH
	DEFB	UPD7220_COMMAND_WDAT	;s.o.
	DEFB	2
	DEFW	0
	DEFB	UPD7220_COMMAND_CURS	;Kursor auf Adresse 0
	DEFB	3
	DEFW	0
	DEFB	0
	DEFB	UPD7220_COMMAND_MASK	;s.o.
	DEFB	2
	DEFW	0FFFFH
	DEFB	UPD7220_COMMAND_START	;GDC in Anzeigemodus
	DEFB	0


