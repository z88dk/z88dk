/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum (interface 1) version
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 *
 *      Added patched IF1 ROM routine which doesn't trigger on BREAK.
 *      Thanks to Owen Reynolds.
 *
 *      $Id: rs232_get.c,v 1.3 2014-11-11 15:23:42 stefano Exp $
 */


#include <rs232.h>


uint8_t rs232_get(uint8_t *char) __naked __z88dk_fastcall
{
#asm
        push	hl
;	rst	8
;	defb	$1d  		; Calls the Hook Code here

	call L0B88 			; BCHAN-IN

	pop	de
	ld	hl,RS_ERR_NO_DATA
	ret	nc
	ld	(de),a
	ld	hl,RS_ERR_OK
	ret
	
;https://www.z88dk.org/wiki/doku.php?id=library:serial
;
; ---------------------------------------
; THE "B" CHANNEL INPUT SERVICE ROUTINE
; ---------------------------------------
; (Hook Code: $1D)

;; BCHAN-IN
L0B88:  LD      HL,$5CC7        ; sv SER_FL
        LD      A,(HL)          ; Is the second-character received flag set?
        AND     A               ;
        JR      Z,L0B95         ; forward to REC-BYTE (if Z set)

        LD      (HL),$00        ;	

        INC     HL              ;
        LD      A,(HL)          ;  pick the 2nd character we already got in the past loop
        SCF                     ;  success

        RET                     ; Return.
        

; ---

;; REC-BYTE
;; L0B95:  CALL    L163E          ; routine TEST-BRK  - Thanks Jetset Willy really dont need this!

L0B95:	DI                      ; Disable Interrupts

        LD      A,($5CC6)       ; sv IOBORD
;        OUT     ($FE),A		; Change the border colour.  -  No Thanks Jetset Willy change the borders in program if wanted

        LD      DE,($5CC3)      ; sv BAUD
        LD      HL,$0320        ; 800d.
        LD      B,D             ;
        LD      C,E             ;
        SRL     B               ;
        RR      C               ;
        LD      A,$FE           ;
        OUT     ($EF),A         ;

;; READ-RS
L0BAF:  IN      A,($F7)         ; bit 7 is input serial data (txdata)
        RLCA                    ;
        JR      NC,L0BC3        ; forward to TST-AGAIN

        IN      A,($F7)         ;
        RLCA                    ;
        JR      NC,L0BC3        ; forward to TST-AGAIN

        IN      A,($F7)         ;
        RLCA                    ;
        JR      NC,L0BC3        ; forward to TST-AGAIN

        IN      A,($F7)         ;
        RLCA                    ;
        JR      C,L0BCF         ; forward to START-BIT


;; TST-AGAIN
L0BC3:  DEC     HL              ;
        LD      A,H             ;
        OR      L               ;
        JR      NZ,L0BAF        ; back to READ-RS

        PUSH    AF              ;
        LD      A,$EE           ;
        OUT     ($EF),A         ;
        JR      L0BEE           ; forward to WAIT-1

; ---

;; START-BIT
L0BCF:  LD      H,B             ; Load HL with halved BAUD value.
        LD      L,C             ;

        LD      B,$80           ; Load B with the start bit.

        DEC     HL              ; Reduce the counter by the time for the four
        DEC     HL              ; tests.
        DEC     HL              ;

;; SERIAL-IN
L0BD6:  ADD     HL,DE           ; Add the BAUD value.
        NOP                     ; (4) a timing value.

;; BD-DELAY
L0BD8:  DEC     HL              ; (6) Delay for 26 * BAUD
        LD      A,H             ; (4)
        OR      L               ; (4)
        JR      NZ,L0BD8        ; (12) back to BD-DELAY

        ADD     A,$00           ; (7) wait
        IN      A,($F7)         ; Read a bit.
        RLCA                    ; Rotate bit 7 to carry.
        RR      B               ; pick up carry in B
        JR      NC,L0BD6        ; back , if no start bit, to SERIAL-IN

        LD      A,$EE           ; Send CTS line low  (comms data 0 also)
        OUT     ($EF),A         ; send to serial port

        LD      A,B             ; Transfer the received byte to A.
        CPL                     ; Complement.
        SCF                     ; Set Carry to signal success.
        PUSH    AF              ; (*) push the success flag.

;   The success and failure (time out) paths converge here with the HL register
;   holding zero.

;; WAIT-1
L0BEE:  ADD     HL,DE           ; (11) transfer DE (BAUD) to HL.

;; WAIT-2
L0BEF:  DEC     HL              ; ( 6) delay for stop bit.
        LD      A,L             ; ( 4)
        OR      H               ; ( 4)
        JR      NZ,L0BEF        ; (12/7) back to WAIT-2

;   Register HL is now zero again.

        ADD     HL,DE           ; HL = 0 + BAUD
        ADD     HL,DE           ; HL = 2 * BAUD
        ADD     HL,DE           ; HL = 3 * BAUD

;   The device at the other end of the cable (not a Spectrum) may send a 
;   second byte even though CTS (Clear To Send) is low.

;; T-FURTHER
L0BF7:  DEC     HL              ; Decrement counter.
        LD      A,L             ; Test for
        OR      H               ; zero.
        JR      Z,L0C34         ; forward, if no second byte, to END-RS-IN

        IN      A,($F7)         ; Read TXdata.
        RLCA                    ; test the bit read.
        JR      NC,L0BF7        ; back, if none,  to T-FURTHER

;   As with first byte, TXdata must be high four four tests.

        IN      A,($F7)         ;
        RLCA                    ;
        JR      NC,L0BF7        ; back to T-FURTHER

        IN      A,($F7)         ;
        RLCA                    ;
        JR      NC,L0BF7        ; back to T-FURTHER

        IN      A,($F7)         ;
        RLCA                    ;
        JR      NC,L0BF7        ; back to T-FURTHER


;   A second byte is on its way and is received exactly as before.

        LD      H,D             ;
        LD      L,E             ;
        SRL     H               ;
        RR      L               ;
        LD      B,$80           ;
        DEC     HL              ;
        DEC     HL              ;
        DEC     HL              ;

;; SER-IN-2
L0C1B:  ADD     HL,DE           ;
        NOP                     ; timing.

;; BD-DELAY2
L0C1D:  DEC     HL              ;
        LD      A,H             ;
        OR      L               ;
        JR      NZ,L0C1D        ; back to BD-DELAY2

        ADD     A,$00           ;
        IN      A,($F7)         ;
        RLCA                    ;
        RR      B               ;
        JR      NC,L0C1B        ; back to SER-IN-2

;  The start bit has been pushed out and B contains the second received byte.

        LD      HL,$5CC7        ; Address the SER_FL System Variable.

        LD      (HL),$01        ; Signal there is a byte in the next location.
        INC     HL              ; Address that location.
        LD      A,B             ; Transfer the byte to A.
        CPL                     ; Complement
        LD      (HL),A          ; and insert in the second byte of serial flag.

;; END-RS-IN
; L0C34:  CALL    L0D4D           ; routine BORD-REST - Dont need this thanks Jetset Willy

L0C34:  POP     AF              ; ( either 0 and NC or the first received byte
                                ;   and the carry flag set ) 

        EI                      ; Enable Interrupts

        RET                     ; Return.
	
#endasm
}
