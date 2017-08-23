;
;       z88dk RS232 Function
;
;       OSCA version
;
;       unsigned char rs232_params(unsigned char param, unsigned char parity)
;
;       Specify the serial interface parameters
;
;       $Id: rs232_params.asm,v 1.3 2016-06-23 20:15:37 dom Exp $

		SECTION  code_clib
		PUBLIC   rs232_params
		PUBLIC   _rs232_params

		INCLUDE "osca.def"

rs232_params:
_rs232_params:

                pop  bc
                pop  hl
                pop  de
                push de
                push hl
                push bc

;                
                ; handle parity
                xor  a
                cp   l
                jr   nz,parityset        ; no parity ?
		ld   hl,1               ; RS_ERR_NOT_INITIALIZED
                ret                     ; sorry, MARK/SPACE options
                                        ; not available
parityset:
                ; handle bits number
                ld   a,$f0              ; mask bit related flags
                and  l
		jr   z,noextra
		ld   hl,1            ; RS_ERR_NOT_INITIALIZED
		ret
noextra:
                
                ; baud rate
                ld   a,$0f
                and  e

		cp	 $0d
		jr	 z,avail
		cp	 $0e
		jr	 z,avail

                ld   hl,3               ; RS_ERR_BAUD_NOT_AVAIL
                ret

avail: 
		sub $0d		; 0=57600; 1=115200
		out (sys_baud_rate),a
                ld   hl,0               ; RS_ERR_OK
                ret
