/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum plus version
 *	Reference: zfst terminal emulator by Russell Marks
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 *
 *      $Id: rs232_get.c,v 1.14 2015-01-21 08:27:13 stefano Exp $
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_get(i8_t *char)
{	/* fastcall so implicit push */
#asm

	;defc	SERFL = $5b61
	;defc	BAUD  = $5B71

	PUBLIC rs232_patch1

	EXTERN SERFL
	EXTERN BAUD
	
;	EXTERN   zx_break

;	push hl 
	call doread
	pop	de
;	pop	bc	; implicit push
	ld	hl,RS_ERR_NO_DATA
	ret	nc

	ld	(de),a
	ld	hl,RS_ERR_OK
	ret

	
.doread
	ld	hl,SERFL
	ld	a,(hl)	; Is the second-character received flag set?
	and a
	jr	z,readbyte
	ld	(hl),0
	inc hl
	ld	a,(hl)	; pick the 2nd character we already got in the past loop
	scf			; success
	ret
	

.readbyte

;	call  zx_break
;	jr    c,nobreak
;
;	ld	hl,RS_ERR_BREAK
;	ret
;
;.nobreak

        DI                ; Ensure interrupts are disabled to achieve accurate timing.

        EXX               ;
        LD   HL,(BAUD)    ; Fetch the baud rate timing constant.
		ld		d,h			; HL=DE=BAUD
		ld		e,l
        SRL  H            ;
        RR   L            ; HL=BAUD/2. So that will sync to half way point in each bit.
        OR   A            ; [Redundant byte]
        LD   B,$FA        ; Waiting time for start bit.
        EXX               ; Save B.

        LD   C,$FD        ;
        LD   D,$FF        ;
        LD   E,$BF        ;
        LD   B,D          ;
        LD   A,$0E        ;
        OUT  (C),A        ; Selects register 14, port I/O of AY-3-8912.

        IN   A,(C)        ; Read the current state of the I/O lines.
        OR   $F0          ; %11110000. Default all input lines to 1.
        AND  $FB          ; %11111011. Force CTS line to 0.
        LD   B,E          ; B=$BF.
        OUT  (C),A        ; Make CTS (Clear To Send) low to indicate ready to receive.

        LD   H,A          ; Store status of other I/O lines.

;Look for the start bit

L072D:  LD   B,D          ;
        IN   A,(C)        ; Read the input line.
        AND  $80          ; %10000000. Test TXD (input) line.
        JR   Z,L073D      ; Jump if START BIT found.

L0734:  EXX               ; Fetch timeout counter
        DEC  B            ; and decrement it.
        EXX               ; Store it.
        JR   NZ,L072D     ; Continue to wait for start bit if not timed out.

        XOR  A            ; Reset carry flag to indicate no byte read.
        PUSH AF           ; Save the failure flag.
        JR   L0776        ; Timed out waiting for START BIT.

L073D:  IN   A,(C)        ; Second test of START BIT - it should still be 0.
        AND  $80          ; Test TXD (input) line.
        JR   NZ,L0734     ; Jump back if it is no longer 0.

        IN   A,(C)        ; Third test of START BIT - it should still be 0.
        AND  $80          ; Test TXD (input) line.
        JR   NZ,L0734     ; Jump back if it is no longer 0.

;A start bit has been found, so the 8 data bits are now read in.
;As each bit is read in, it is shifted into the msb of A. Bit 7 of A is preloaded with a 1
;to represent the start bit and when this is shifted into the carry flag it signifies that 8
;data bits have been read in.

        EXX               ;
        LD   BC,$FFFD     ;
        LD   A,$80        ; Preload A with the START BIT. It forms a shift counter used to count
        EX   AF,AF        ; the number of bits to read in.

L0750:  ADD  HL,DE        ; HL=1.5*(BAUD).

        NOP               ; (4) Fine tune the following delay.
        NOP               ;
        NOP               ;
        NOP               ;

;BD-DELAY
L0755:  DEC  HL           ; (6) Delay for 26*BAUD.
        LD   A,H          ; (4)
        OR   L            ; (4)
        JR   NZ,L0755     ; (12) Jump back to until delay completed.

        IN   A,(C)        ; Read a bit.
        AND  $80          ; Test TXD (input) line.
        JP   Z,L076A      ; Jump if a 0 received.

;Received one 1

        EX   AF,AF        ; Fetch the bit counter.
        SCF               ; Set carry flag to indicate received a 1.
        RRA               ; Shift received bit into the byte (C->76543210->C).
        JR   C,L0773      ; Jump if START BIT has been shifted out indicating all data bits have been received.

        EX   AF,AF        ; Save the bit counter.
        JP   L0750        ; Jump back to read the next bit.

;Received one 0

L076A:  EX   AF,AF        ; Fetch the bit counter.
        OR   A            ; Clear carry flag to indicate received a 0.
        RRA               ; Shift received bit into the byte (C->76543210->C).
        JR   C,L0773      ; Jump if START BIT has been shifted out indicating all data bits have been received.

        EX   AF,AF        ; Save the bit counter.
        JP   L0750        ; Jump back to read next bit.

;After looping 8 times to read the 8 data bits, the start bit in the bit counter will be shifted out
;and hence A will contain a received byte.

L0773:  SCF               ; Signal success.
        PUSH AF           ; Push success flag.
        EXX

;The success and failure paths converge here

L0776:  LD   A,H          ;
        OR   $04          ; A=%1111x1xx. Force CTS line to 1.

        LD   B,E          ; B=$BF.
        OUT  (C),A        ; Make CTS (Clear To Send) high to indicate not ready to receive.
        EXX

        LD   H,D          ;
        LD   L,E          ; HL=(BAUD).
.rs232_patch1
        LD   BC,$0007     ;
        OR   A            ;
        SBC  HL,BC        ; HL=(BAUD)-7.

L0785:  DEC  HL           ; Delay for the stop bit.
        LD   A,H          ;
        OR   L            ;
        JR   NZ,L0785     ; Jump back until delay completed.

        LD   BC,$FFFD     ; HL will be $0000.
        ADD  HL,DE        ; DE=(BAUD).
        ADD  HL,DE        ;
        ADD  HL,DE        ; HL=3*(BAUD). This is how long to wait for the next start bit.

;The device at the other end of the cable may send a second byte even though
;CTS is low. So repeat the procedure to read another byte.

L0790:  IN   A,(C)        ; Read the input line.
        AND  $80          ; %10000000. Test TXD (input) line.
        JR   Z,L079E      ; Jump if START BIT found.

        DEC  HL           ; Decrement timeout counter.
        LD   A,H          ;
        OR   L            ;
        JR   NZ,L0790     ; Jump back looping for a start bit until a timeout occurs.

;No second byte incoming so return status of the first byte read attempt

        POP  AF           ; Return status of first byte read attempt - carry flag reset for no byte received or
        EI                ; carry flag set and A holds the received byte.
		RET


L079E:  IN   A,(C)        ; Second test of START BIT - it should still be 0.
        AND  $80          ; Test TXD (input) line.
        JR   NZ,L0790     ; Jump back if it is no longer 0.

        IN   A,(C)        ; Third test of START BIT - it should still be 0.
        AND  $80          ; Test TXD (input) line.
        JR   NZ,L0790     ; Jump back if it is no longer 0.

;A second byte is on its way and is received exactly as before

        LD   H,D          ;
        LD   L,E          ; HL=(BAUD).
        LD   BC,$0002     ;
        SRL  H            ;
        RR   L            ; HL=(BAUD)/2.
        OR   A            ;
        SBC  HL,BC        ; HL=(BAUD)/2 - 2.

        LD   BC,$FFFD     ;
        LD   A,$80        ; Preload A with the START BIT. It forms a shift counter used to count
        EX   AF,AF        ; the number of bits to read in.

L07BC:  NOP               ; Fine tune the following delay.
        NOP               ;
        NOP               ;
        NOP               ;

        ADD  HL,DE        ; HL=1.5*(BAUD).

L07C1:  DEC  HL           ; Delay for 26*(BAUD).
        LD   A,H          ;
        OR   L            ;
        JR   NZ,L07C1     ; Jump back to until delay completed.

        IN   A,(C)        ; Read a bit.
        AND  $80          ; Test TXD (input) line.
        JP   Z,L07D6      ; Jump if a 0 received.

;Received one 1

        EX   AF,AF        ; Fetch the bit counter.
        SCF               ; Set carry flag to indicate received a 1.
        RRA               ; Shift received bit into the byte (C->76543210->C).
        JR   C,L07DF      ; Jump if START BIT has been shifted out indicating all data bits have been received.

        EX   AF,AF        ; Save the bit counter.
        JP   L07BC        ; Jump back to read the next bit.

;Received one 0

L07D6:  EX   AF,AF        ; Fetch the bit counter.
        OR   A            ; Clear carry flag to indicate received a 0.
        RRA               ; Shift received bit into the byte (C->76543210->C).
        JR   C,L07DF      ; Jump if START BIT has been shifted out indicating all data bits have been received.

        EX   AF,AF        ; Save the bit counter.
        JP   L07BC        ; Jump back to read next bit.

;Exit with the byte that was read in

L07DF:  LD   HL,SERFL     ; $5B61.
        LD   (HL),1     ; Set the flag indicating a second byte is in the buffer.
        INC  HL           ;
        LD   (HL),A       ; Store the second byte read in the buffer.
        POP  AF           ; Return the first byte.

        EI                ; Re-enable interrupts.
        RET

#endasm
}



