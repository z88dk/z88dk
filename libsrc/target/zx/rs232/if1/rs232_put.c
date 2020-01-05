/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (interface 1) version
 *
 *      unsigned char rs232_put(char)
 *
 *      No error checking, for now.
 *
 *      $Id: rs232_put.c,v 1.2 2008-06-05 14:31:24 stefano Exp $
 */


#include <rs232.h>


uint8_t __FASTCALL__ rs232_put(uint8_t char)
{       
#asm
        ld      a,l     		;get byte
;        rst     8
;        defb    $1E			;  Calls the Hook Code

;https://www.z88dk.org/wiki/doku.php?id=library:serial
;
; --------------------------------
; THE '"B" CHANNEL OUTPUT' ROUTINE
; --------------------------------
; (Hook Code: $1E)
;   The bits of a byte are sent inverted. They are fixed in length and heralded
;   by a start bit and followed by two stop bits.

;; BCHAN-OUT
L0D07:  LD      B,$0B           ; Set bit count to eleven - 1 + 8 + 2.

        CPL                     ; Invert the bits of the character.
        LD      C,A             ; Copy the character to C.

        LD      A,($5CC6)       ; Load A from System Variable IOBORD
;        OUT     ($FE),A         ; Change the border colour.  -  No Thanks Jetset Willy change the borders in program if wanted

        LD      A,$EF           ; Set to %11101111
        OUT     ($EF),A         ; Make CTS (Clear to Send) low.

        CPL                     ; reset bit 0 (other bits of no importance)
        OUT     ($F7),A         ; Make RXdata low. %00010000

        LD      HL,($5CC3)      ; Fetch value from BAUD System Variable.
        LD      D,H             ; Copy BAUD value to DE for count.
        LD      E,L             ;

;; BD-DEL-1
L0D1C:  DEC     DE              ; ( 6) Wait 26 * BAUD cycles
        LD      A,D             ; ( 4) 
        OR      E               ; ( 4)
        JR      NZ,L0D1C        ; (12) back to BD-DEL-1

;; TEST-DTR
;; L0D21:  CALL    L163E           ; routine TEST-BRK allows user to stop. - Thanks Jetset Willy
L0D21:  IN      A,($EF)         ; Read the communication port.
        AND     $08             ; isolate DTR (Data Terminal Ready) bit.
        JR      Z,L0D21         ; back, until DTR found high, to TEST-DTR

        SCF                     ; Set carry flag as the start bit.
        DI                      ; Disable Interrupts.

;; SER-OUT-L
L0D2C:  ADC     A,$00           ; Set bit 0            76543210 <- C  
        OUT     ($F7),A         ; Send RXdata the start bit.

        LD      D,H             ; Transfer the BAUD value to DE for count.
        LD      E,L             ;

;; BD-DEL-2
L0D32:  DEC     DE              ; ( 6) Wait for 26 * BAUD
        LD      A,D             ; ( 4)
        OR      E               ; ( 4)
        JR      NZ,L0D32        ; (12) back to BD-DEL-2

        DEC     DE              ; ( 6) 
        XOR     A               ; ( 4) clear rxdata bit
        SRL     C               ;      shift a bit of output byte to carry.
        DJNZ    L0D2C           ; back for 11 bits to SER-OUT-L

;   Note the last two bits will have been sent reset as C is exhausted.

        EI                      ; Enable Interrupts.

        LD      A,$01           ; Set RXdata

        LD      C,$EF           ; prepare port address.
        LD      B,$EE           ; prepare value %11101110
        OUT     ($F7),A         ; Send RXdata high.
        OUT     (C),B           ; Send CTS and comms data low - switch off RS232

;; BD-DEL-3
L0D48:  DEC     HL              ; ( 6) The final 26 * BAUD delay
        LD      A,L             ; ( 4) 
        OR      H               ; ( 4) 
        JR      NZ,L0D48        ; (12) back to BD-DEL-3
;; NO RET????




;  Think we run in to the border reset routine then return..  So lets clean that up, I dont want to play with borders in the routine.


;  This looks like the expected return commands.

;        POP     AF              ; Restore accumulator and flags.

;        RET                     ; Return.



; -----------------------------------
; THE 'BORDER COLOUR RESTORE' ROUTINE
; -----------------------------------
;

;; BORD-REST
; L0D4D:  PUSH    AF              ; Preserve the accumulator value throughout.
;
;        LD      A,($5C48)       ; Fetch System Variable BORDCR
;        AND     $38             ; Mask off the paper bits.
;        RRCA                    ; Rotate to the range 0 - 7
;        RRCA                    ;
;        RRCA                    ;
;        OUT     ($FE),A         ; Change the border colour.
;
;        POP     AF              ; Restore accumulator and flags.
;
;        RET                     ; Return.
	
        ld      hl,RS_ERR_OK
        
        ;;pop	bc; fastcall so implicit push
        
        

#endasm
}
