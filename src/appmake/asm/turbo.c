/*
 *	Turbo tape source
 *  in test / development behaviour
 * 
 *  Stefano Bodrato, 2013
 * 
 *  $Id: turbo.c,v 1.2 2013-02-13 09:08:27 stefano Exp $
 */


#include <stdio.h>


main()
{
	printf("Loading...\n");
	turbo_screen();
}

turbo_screen()
{
#asm
	ld	ix,16384
	//ld	de,6912
	//ld	de,6880
	call ldr
	ei
	ret

;------------------------ cut here ------------------------ 
ldr:
	;		LD	IX,screen loc
	;		LD	DE,screen len
	;		call $ff37

	;		LD	IX,loc
	;		LD	DE,len
	;		call $ff37
	;		ei

	;		jp  <game entry>

;...

		;    The A register holds +00 for a header and +FF for a block of data
		;    The carry flag is reset for VERIFYing and set for LOADing

;000FF37:
			;LD A,FFh
			;SCF			; probably unnecessary

			;call ff3a
			;jp entry

			;INC D			; This resets the zero flag (D cannot hold +FF)
			;EX AF,AF		; A:  0=header, $ff=data block  CF: 1=load, 0=verify
			;DEC D			; Restore D to its original value
			DI

			;LD   A,15              ; The border is made WHITE
			;OUT  (254),A
			;LD   HL,+053F           ; Pre-load the machine stack with the
			;PUSH HL                 ; return address

			IN A,(FEh)		; Make an initial read of port 254
			RRA				; Rotate the byte obtained
			AND 20h			; but keep only the EAR bit
;			OR 02h			; Signal RED border
			LD C,A			; Store the value in the C register
							; (+22 for 'off' and +02 for 'on' - the present EAR state)
LD_BREAK:
			CP A			; Set the zero flag
;			RET NZ			; Return if the BREAK key is being pressed

LD_START:
;			CALL LD_EDGE_1	; 
;			JR NC,LD_BREAK	; Return with the carry flag reset if there is no 'edge' within approx.
							; 14,000 T states. But if an 'edge' is found the border will go CYAN

; The next stage involves waiting a while and then showing that the signal is still pulsing.

;			LD HL,0415h		; The length of this waiting period will
;LD_WAIT:
;			DJNZ LD_WAIT	; be almost one second in duration.
;			DEC HL
;			LD A,H
;			OR L
;			JR NZ,LD_WAIT
;
;			CALL LD_EDGE_2	; Continue only if two edges are found
;			JR NC,LD_BREAK	; within the allowed time period


;	Now accept only a 'leader signal'.
LD_LEADER:
			LD B,9Ch		; The timing constant
			CALL LD_EDGE_2	; Continue only if two edges are found
			JR NC,LD_BREAK	; within the allowed time period

			LD A,C6h		; However the edges must have been found
			CP B			; within about 3,000 T states of each other
			JR NC,LD_START
			INC H			; Count the pair of edges in the H register 
			JR NZ,LD_LEADER		; until 256 pairs have been found


;	After the leader come the 'off' and 'on' parts of the sync pulse.
LD_SYNC:
			LD B,C9h		; The timing constant
			CALL LD_EDGE_1	; Every edge is considered until two edges
			JR NC,LD_BREAK	; are found close together - 

			LD A,B			; these will be the start and finishing edges of the
			CP D4h			; 'off' sync pulse
			JR NC,LD_SYNC

			CALL LD_EDGE_1	; The finishing edge of the 'on' pulse
			RET NC			; must exist (Return carry flag reset)

			LD A,C			; The border colours from now on will be
			XOR 03h			; BLUE & YELLOW (in ROM)
			LD C,A
			;LD H,00h		; Initialize the 'parity matching' byte to zero
			LD B,D0h		; Set the timing constant for the flag byte  (was B0 in the original ROM)
			JR LD_MARKER    ; Jump forward into the byte LOADing loop


; The byte LOADing loop is used to fetch the bytes one at a time. The flag byte is
; first. This is followed by the data bytes and the last byte is the 'parity' byte.

LD_LOOP:
			;EX AF,AF		; A:  0=header, $ff=data block  CF: 1=load, 0=verify
;			JR NZ,LD_FLAG	; Jump forward only when handling the first byte

;;;;;;;;;	JR   NC,LD_VERIFY  ; Jump forward is VERIFYing a tape

			LD (IX+00h),L
;			JR LD_NEXT


; LD_FLAG is called only once when reading the first byte of the block
;LD_FLAG:
;			RL C			; Keep the carry flag in a safe place temporarily
;			XOR L			; if the flag byte does not match the first byte on the tape...
;			RET NZ			; ...Return
;			LD A,C			; Restore the carry flag now
;			RRA
;			LD C,A
;			INC DE			; Increase the counter to compensate for
;			JR LD_DEC		; its decrease after the jump


; If a data block is being verified then 
; the freshly loaded byte is tested against the original byte.
;;
;;05BD LD-VERIFY  LD   A,(IX+00)          Fetch the original byte
;;                XOR  L                  Match it against the new byte
;;                RET  NZ                 Return if 'no match' (Carry flag reset)

LD_NEXT:
			INC IX			; dst location
LD_DEC:
			;DEC DE			; size counter
			;EX AF,AF		; Save the flags

			LD B,D1h		; Set the timing constant  ($B2 in the ROM)
LD_MARKER:
			LD L,01h		; Clear the 'object' register apart from a 'marker' bit

LD_8_BITS:					; The 'LD-8-BITS' loop is used to build up a byte in the L register.
			CALL LD_EDGE_2	; Find the length of the 'off' and 'on' pulses of the next bit
			RET NC			; Return if the time period is exceeded (Carry flag reset)

			;LD A,E8h		; ($CB in ROM): Compare the length against approx. 35 increments of b;
			;LD A,D8h		; ($CB in ROM): Compare the length against approx. 35 increments of b; 
			;CP B			; if so.. zero !
			ld	a,b
			
			;cp	$E3			; carry set if period is shorter 
			;cp	$E5			; carry set if period is shorter 
			
			;cp	$e0 (max limit)
			;cp	$DC (min limit)
			cp	$de
			JP NC,escseq

			;LD A,D5h		; new timing
			;LD A,D8h		; ($CB in ROM): Compare the length against approx. 2,400 T states (19 increments of b); 
			;CP B			; resetting the carry flag for a '0' and setting it for a '1'
			cp	$d5			; carry set if period is shorter
			ccf
			RL L			; Include the new bit in the L register
			;LD B,D0h		; Set the timing constant for the next bit ($B0)
			LD B,D0h		; Set the timing constant for the next bit ($B0)
			JP NC,LD_8_BITS	; Jump back whilst there are still bits to be fetched
							; (GB-MAX was jumping in FFB3 to POP DE/RET ???)


; The 'parity matching' byte has to be updated with each new byte.

			;LD A,H			; Fetch the 'parity matching' byte and
			;XOR L			; include the new byte
			;LD H,A			; Save it once again


; Passes round the loop are made until the 'counter' reaches zero. At that point
; the 'parity matching' byte should be holding zero.
nextbyte:
			;LD A,D			; Make a furter pass if DE
			;OR E			; does not hold zero
			;JR NZ,LD_LOOP
			;RET
			JP	LD_LOOP

;                LD   A,H                Fetch the 'parity matching' byte
;                CP   +01                Return with the carry flag set if the
;                RET                     value is zero (Carry flag reset if in error)

;escseq:
;			dec l
;			jp nextbyte

escseq:
			dec l
			;LD B,E7h		; Set the timing constant  ($B2 in the ROM)
			;LD B,D2h		; Set the timing constant  ($B2 in the ROM)
			LD B,D1h		; Set the timing constant  ($B2 in the ROM)
			CALL LD_EDGE_2	; Find the length of the 'off' and 'on' pulses of the next bit
			RET NC			; Return if the time period is exceeded (Carry flag reset)
			;LD	A,E9h
			;LD	A,EBh
			;LD	A,EAh
			;LD	A,D4h
			
			;LD	A,D5h	; min limit
			;LD	A,D7h
			;LD	A,DAh   ; max limit
			;LD	A,D9h

			LD	A,D7h
			
			;LD a,b
			
			CP B			; the 'long' bit stands for a whole byte set to 0
			
			;cp $d5			; CF if short period
			;jp nc,nextbyte	; jp if longer
			jp c,nextbyte	; jp if longer
			
			; ok, this is a longer period,  look for a byte repeated sequence

			ld l,(ix-1)		; load the last byte value

zbloop:
			;LD B,E7h		; (set up timing)
			LD B,D1h		; Set the timing constant  ($B2 in the ROM)
			CALL LD_EDGE_2	; Find the length of the 'off' and 'on' pulses of the next bit
			RET NC			; Return if the time period is exceeded (Carry flag reset)

			;LD	A,EBh
			;LD	A,EAh
			LD	A,D5h
			CP B
			jp c,nextbyte ; jp if longer

			ld (ix+0),l
			inc ix
			;dec de

			jp zbloop

			

; THE 'LD-EDGE-2' and 'LD-EDGE-1' SUBROUTINES
; These two subroutines form the most important part of the LOAD/VERIFY operation.
; The subroutines are entered with a timing constant in the B register, and the
; previous border colour and 'edge-type' in the C register.
; The subroutines return with the carry flag set if the required number of 'edges'
; have been found in the time allowed; and the change to the value in the B
; register shows just how long it took to find the 'edge(s)'.
; The carry flag will be reset if there is an error. The zero flag then signals
; 'BREAK pressed' by being reset, or 'time-up' by being set.
; The entry point LD-EDGE-2 is used when the length of a complete pulse is
; required and LD-EDGE-1 is used to find the time before the next 'edge'.


LD_EDGE_2:
			CALL LD_EDGE_1		; In effect call LD-EDGE-1 twice;
			RET NC				; returning in between in there is an error

LD_EDGE_1:
			LD A,0Dh			; (was 16 in ROM) Wait 358 T states before entering the sampling loop
LD_DELAY:
			DEC A
			JR NZ,LD_DELAY
			AND A

; The sampling loop is now entered. The value in the B register is incremented for
; each pass; 'time-up' is given when B reaches zero.

LD_SAMPLE:
			INC B				; Count each pass
			RET Z				; Return carry reset & zero set if 'time-up'.
			LD A,7Fh			; 
			IN A,(FEh)			; Read from port +7FFE
			RRA					; shift the byte
;                RET  NC                 Return carry reset & zero reset if BREAK was pressed
			XOR C				; Now test the byte against the 'last edge-type'
			AND 20h				; Jump back unless it has changed
			JR Z,LD_SAMPLE


; A new 'edge' has been found within the time period allowed for the search.
; So change the border colour and set the carry flag.

			LD A,C		; Change the 'last edge-type' 
			CPL			; and border colour

			LD C,A		; (ROM) ld a,c  ... (in ROM: RED/CYAN or BLUE/YELLOW)
			LD A,B		; (ROM) cpl
			NOP			; (ROM) ld c,a
			AND 7		; Keep only the border colour
			OR 8		; Signal 'MIC off'
			OUT (FEh),a	; Change the border colour 
			SCF			; Signal the successful search before returning
			RET


;Note: The LD-EDGE-1 subroutine takes 464 T states, plus an additional 59 T
;states for each unsuccessful pass around the sampling loop.
;For example, therefore, when awaiting the sync pulse (see LD-SYNC)
;allowance is made for ten additional passes through the sampling loop.
;The search is thereby for the next edge to be found within, roughly, 1,100 T
;states (464 + 10 * 59 overhead).
;This will prove successful for the sync 'off' pulse that comes after the long
;'leader pulses'.
;------------------------ cut here ------------------------ 

#endasm	
}

