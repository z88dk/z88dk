/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	uint8_t rs232_params(uint8_t param, uint8_t parity)
 *
 *	Specify the serial interface parameters
 *
 *	Later on, this should set panel values
 */


#include <rs232.h>


uint8_t rs232_params(uint8_t param, uint8_t parity) __naked
{
#asm
	INCLUDE	"target/mtx/def/mtxserial.def"

	defc	NEWRS = 1

        pop     af
        pop     bc      ;c = parity (we ignore)
        pop     de      ;e = param
        push    de
        push    bc
        push    af
        ld      a,e
        and     15

        ld      e,a
        ld      d,0
        ld      hl,baud_table
        add     hl,de
        add     hl,de
        add     hl,de
        ld      a,(hl)
        inc     hl
        or      (hl)
        inc     hl
        ld      d,(hl)  ; The settings
        ld      hl,RS_ERR_BAUD_NOT_AVAIL
        ret     z
	; We now have d as the value for baud rate
	ld	a,3		;Reset CTX channel
	out	(CTCV),a
	ld	a,$45
	out	(CTCV),a
	ld	a,d		;And the baud rate
	out	(CTCV),a

	ld	c,CTLRS
	ld	b,9
	ld	hl,baudrg
	otir
        ld      hl,RS_ERR_OK
        ret

	SECTION	rodata_clib
baud_table:
        defb    0,0,0			; 50 - not supported
        DEFB    4BH,00H,0               ; 75
        DEFB    6EH,00H,0AFH            ; 110
        defb    0,0,0			; 134.5 - not supported
        DEFB    96H,00H,80H             ; 150
        DEFB    2CH,01H,40H             ; 300
        DEFB    58H,02H,20H             ; 600
        DEFB    0B0H,04H,10H            ; 1200
        DEFB    60H,09H,8               ; 2400
        DEFB    0C0H,12H,4              ; 4800
        DEFB    80H,25H,2               ; 9600
	DEFB    00H,4BH,1               ; 19200
        defb    0,0,0			; 38400 - not supported
        defb    0,0,0			; 57600 - not supported
        defb    0,0,0			; 115200 - not supported
        defb    0,0,0			; 230400 - not supported

baudrg:
        DEFB    18H                     ; Error reset
        DEFB    1                       ; Reg 1
        DEFB    0                       ; Null code to reg 0
        DEFB    3                       ; Reg 3
DARTR3:
        DEFB    0E1H                    ; 8 bits/char received
        DEFB    4                       ; Reg 4
DARTR4:
        DEFB    4CH                     ; x16 clock 2 stop bits no parity
                                        ; Receiver enable, auto-enable
        DEFB    5                       ; Reg 5
DARTR5:
IF      NEWRS                   ; New value suggested by geoff
        DEFB    0EAH                    ; 8 bits/char out, transmitter enable, DTR=RTS=1
ELSE                            ; Old value as manual
        DEFB    068H                    ; 8 bits/char out, transmitter enable, DTR=RTS=0
ENDIF

#endasm
}

