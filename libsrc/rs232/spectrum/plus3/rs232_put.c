/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum plus version
 *	Reference: zfst terminal emulator by Russell Marks
 *
 *	unsigned char rs232_put(char)
 *
 *	No error checking, for now.
 *
 *      $Id: rs232_put.c,v 1.8 2015-01-21 08:27:13 stefano Exp $
 */


#include <rs232.h>


u8_t rs232_put(i8_t char)
{	/* Fastcall so implicit push */
#asm

;	EXTERN   zx_break

	PUBLIC rs232_patch2

;;	defc	BAUD  = $5B71
	EXTERN BAUD
	

	ld	a,l	;get byte

	push	af
	
	ld	c,$fd
	ld	d,$ff
	ld	e,$bf
	ld	b,d
	ld	a,14
	out	(c),a	; AY reg. to control the RS232 port.

.brkcheck
;	call  zx_break
;	jr    c,nobreak
;
;	ld	hl,RS_ERR_BREAK
;	ret
;
;.nobreak

        IN   A,(C)        ; Read status of data register.
        AND  $40          ; %01000000. Test the DTR line.
        JR   NZ,brkcheck     ; Jump back until device is ready for data.

        LD   HL,(BAUD)    ; $5B5F. HL=Baud rate timing constant.
.rs232_patch2
        LD   DE,$0002     ;
        OR   A            ;
        SBC  HL,DE        ;
        EX   DE,HL        ; DE=(BAUD)-2.

        POP  AF           ; Retrieve the byte to send.
        CPL               ; Invert the bits of the byte (RS232 logic is inverted).
        SCF               ; Carry is used to send START BIT.
        LD   B,$0B        ; B=Number of bits to send (1 start + 8 data + 2 stop).

        DI                ; Disable interrupts to ensure accurate timing.

;Transmit each bit

L08E7:  PUSH BC           ; Save the number of bits to send.
        PUSH AF           ; Save the data bits.

        LD   A,$FE        ;
        LD   H,D          ;
        LD   L,E          ; HL=(BAUD)-2.
        LD   BC,$BFFD     ; AY-3-8912 data register.

        JP   NC,L08F9     ; Branch to transmit a 1 or a 0 (initially sending a 0 for the start bit).

;Transmit a 0

        AND  $F7          ; Clear the RXD (out) line.
        OUT  (C),A        ; Send out a 0 (high level).
        JR   L08FF        ; Jump ahead to continue with next bit.

;Transmit a 1

L08F9:  OR   8            ; Set the RXD (out) line.
        OUT  (C),A        ; Send out a 1 (low level).
        JR   L08FF        ; Jump ahead to continue with next bit.

;Delay the length of a bit

L08FF:  DEC  HL           ; (6) Delay 26*BAUD cycles.
        LD   A,H          ; (4)
        OR   L            ; (4)
        JR   NZ,L08FF     ; (12) Jump back until delay is completed.

        NOP               ; (4) Fine tune the timing.
        NOP               ; (4)
        NOP               ; (4)

        POP  AF           ; Retrieve the data bits to send.
        POP  BC           ; Retrieve the number of bits left to send.
        OR   A            ; Clear carry flag.
        RRA               ; Shift the next bit to send into the carry flag.
        DJNZ L08E7        ; Jump back to send next bit until all bits sent.

        EI                ; Re-enable interrupts.
;        RET               ; Return with carry and zero flags reset.



	ld	hl,RS_ERR_OK
;	pop	bc	;remove implicit push


#endasm
}
