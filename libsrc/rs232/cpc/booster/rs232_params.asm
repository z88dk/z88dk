;
;       z88dk RS232 Function
;
;       Amstrad CPC (CPC Booster+) version
;
;       unsigned char rs232_params(unsigned char param, unsigned char parity)
;
;       Specify the serial interface parameters
;
;       $Id: rs232_params.asm,v 1.3 2016-06-23 20:15:37 dom Exp $

		SECTION  code_clib
                PUBLIC   rs232_params
                PUBLIC   _rs232_params

rs232_params:
_rs232_params:
                pop  bc		;Stackpointer
                pop  hl		;Parity
                pop  de		;Stopbits / Baudrate
                push de
                push hl
                push bc

; CPC Booster+ - settings
;
; Params: &FF07
; Parity: 	Bit 6,5	- bit 6 -> parity enabled
;		0	0	disabled
;		1	0	even parity
;		1	1	odd parity
;
; Stopbits:	Bit 4
;		0		1 stop bit
;		1		2 stop bits
;
; Data bit settings:	Bit 3, 2, 1
;		0	0	0	5 Bit
;		0	0	1	6 Bit
;		0	1	0	7 Bit
;		0	1	1	8 Bit
;
; Baudrate: &FF04
		;handle parity
		xor a
		or l					;no parity (0x00)?
		jr z, parityset
				
		ld a, l
		cp $20					;parity odd
		jr nz, noodd
			
		ld a, $30				;UPM1=1, UPM0=1
		jr parityset
				
.noodd		cp $60					;parity even
		jr nz, noeven
			
		ld a, $20				;UPM1=1, UPM0=0
		jr parityset
				
.noeven		ld hl, 1				;RS_ERR_NOT_INITIALIZED
		ret
				
.parityset
                ; handle bits number
                push af

                ld   a,$60              ; mask bit numbers flags (just inverted and shiftet for the Booster+)
                and  e
				
		xor  $60				;invert bytes
		rra
		rra
		rra
		rra						;and shift them
				
                ld   c,a
                pop  af
                or   c                  ; set bit number bits
                                        ; we support 8 to five bit modes !!
                
                ; handle stop bits
                bit  7,e
                jr   z,stop1
                or $08				;two stop bits, set USBS=1 (Bit 4)
stop1:          
                ld   bc,$ff07
                out  (c),a			;set USART (parity, bits number, stop bits)

                
                ; baud rate
                ld   a,$0f			;only use lower nibble
                and  e
                sub   $09			;at least 4800 baud (prepare a for table offset 0x00)
                jr   nc,avail		;>= 4800 baud
                ld   hl,3			;RS_ERR_BAUD_NOT_AVAIL
                ret
avail: 
                ld   e,a
                ld   d,0

                ld   hl,tabell		;table value = hl  (table adress) + de (baudrate setting)
                add  hl,de
                ld   a,(hl)

		ld bc, $ff04
		out (c),a

                ld   hl,0			;RS_ERR_OK
                ret

		SECTION rodata_clib
;Baudrates for CPC Booster+ (U2X=0 -> UBRR=((11059200/Baudrate)/16)-1)			
tabell:		defb 143		;  4800 bps
		defb 71			;  9600 bps
		defb 35			; 19200 bps
		defb 17			; 38400 bps
		defb 11			; 57600 bps
		defb 5			;115200 bps
		defb 2			;230400 bps
