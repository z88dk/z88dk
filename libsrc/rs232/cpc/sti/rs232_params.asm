;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_params(unsigned char param, unsigned char parity)
;
;       Specify the serial interface parameters
;
;       $Id: rs232_params.asm,v 1.4 2016-06-23 20:15:37 dom Exp $

		SECTION  code_clib
                PUBLIC   rs232_params
                PUBLIC   _rs232_params
                
rs232_params:
_rs232_params:
                pop  bc
                pop  hl
                pop  de
                push de
                push hl
                push bc

;
;Bit           7     6     5     4     3     2     1     0
;              x     x     x     x     x     x     x     0
;              ^     ^     ^     ^     ^     ^     ^     
;              |     |     |     |     |     |     1=even     
;              |     |     |     |     |     |     0=odd
;              |     |     |     |     |     1=Parity on
;              |     |     |     |     |     0=Parity off
;              |     |     |               Startbit  Stopbit  Format
;              |     |     |     0     0 =    0         0     synchron
;              |     |     |     0     1 =    1         1     asynchron
;              |     |     |     1     0 =    1       1 1/2   asynchron
;              |     |     |     1     1 =    1         2     asynchron
;              |     0     0 = 8 Bit
;              |     0     1 = 7 Bit
;              |     1     0 = 6 Bit
;              |     1     1 = 5 Bit
;              please always set to 0 
;
                
                ; handle parity
                xor  a
                cp   l
                jr   z,parityset        ; no parity ?
                ld   a,l
                cp   $20                ; parity odd
                jr   nz,noodd
                ld   a,4
                jr   parityset
.noodd          cp   $60                ; parity even
                jr   nz,noeven
                ld   a,6
                jr   parityset
.noeven         ld   hl,1               ; RS_ERR_NOT_INITIALIZED
                ret                     ; sorry, MARK/SPACE options
                                        ; not available
.parityset
                ; handle bits number
                push af
                ld   a,$60              ; mask bit numbers flags (incredibly they don't change !!)
                and  e
                ld   c,a
                pop  af
                or   c                  ; set bit number bits
                                        ; we support 8 to five bit modes !!
                
                ; handle stop bits
                bit  7,e
                jr   nz,stop1
                set  4,a
stop1:          set  3,a

                ld   bc,$f8ec
                out  (c),a
                ld   c,$e8
                ld   a,6
                out  (c),a
                ld   c,$e0
                ld   a,3
                out  (c),a
                inc  c
                ld   a,1
                out  (c),a
                
                ; baud rate
                ld   a,$0f
                and  e
                cp   12                 ; max 9600 baud
                jr   c,avail
                ld   hl,2               ; RS_ERR_BAUD_TOO_FAST
                ret
avail:                
                add  a,a
                ld   e,a
                ld   d,0
                ld   hl,tabell
                add  hl,de
                ld   a,(hl)
                ld   c,$e8
                push bc
                ld   e,1
                out  (c),e
                ld   c,$e0
                out  (c),a
                pop  bc
                push bc
                ld   e,2
                out  (c),e
                ld   c,$e0
                out  (c),a
                pop  bc
                inc  hl
                ld   a,(hl)
                ld   e,7
                out  (c),e
                ld   c,$e0
                out  (c),a
                ld   c,$ed
                ld   e,1
                out  (c),e
                inc  c
                out  (c),e
                ld   hl,0               ; RS_ERR_OK
                ret

		SECTION rodata_clib
;
tabell:         defb $27,$55    ;  50 bps
                defb $1a,$55    ;  75 bps
                defb $47,$33    ; 110 bps
                defb $3a,$33    ; 134.5 bps     ; experimental
                defb $34,$33    ; 150 bps
                defb $1a,$33    ; 300 bps
                defb $34,$11    ; 600 bps
                defb $1a,$11    ;1200 bps
                defb $0e,$11    ;2400 bps
                defb $07,$11    ;4800 bps       ; experimental
                defb $04,$11    ;9600 bps       ; experimental: 1200*26=9600*x

