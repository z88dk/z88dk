;
;       Otrona Attachè graphics routines
;		direct video HW access
;
;		Internal use code to prepare SMC instructions
;
;       Stefano Bodrato 2018
;
;
;
;	$Id: plot_setup.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION smc_clib
			PUBLIC	plot_setup

			EXTERN	__gfx_coords

.plot_setup		
                        ld      (__gfx_coords),hl     ; store X
                        ld      (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider

						DI		;STOP VALET
		
						;LD	A,(GRFBIT+1)		; SMC, initially $C7 (SET 0,A), changed to $87 (RES 0,A) to unplot
						;LD	(PIXBIT),A
						
						;CALL	LINDSP			; INVERT Y
						
						;LD	A,(GRY)
						push hl
						ld a,e
						
						
						
						;ADD	A,16	;FIND OUT WHICH NIBBLE
						;CPL		
						;LD	HL,PIXBIT
						LD	HL,PIXBIT+1		; wow... here we do SMC on the SMC code !
						RES	5,(HL)
						BIT	0,A
						JR	NZ,LNDSP1
						SET	5,(HL)
LNDSP1:					SRL	A
						LD 	B,-1	;AND WHICH LINE
LNDSP2:					INC	B
						ADD	A,-5
						JR	C,LNDSP2
						ADD	A,5
						RRCA
						RRCA
						RRCA
						
						; When accessing graphics, the display status register uses 
						; the three high order bits to select one of the five gfx scan pairs (segments)
						; and the five low order bits to select one of the 24 lines.
						
						LD 	C,A
						;LD	A,(LINOFS)		; $DAA4 on earlier BIOSES, but address changes  :( ...
						;PUSH	AF	;SAVE LINOFS
						;ADD	A,B
						ld a,b		; .. so we assume line offset to be zero
						
						CP	24		;LINES
						JR	C,LNDSP3
						ADD	A,-24	;-LINES
LNDSP3:
						OR	C
						;POP	BC	;IN B FOR EXTERNAL USE
	
						OUT	(0EEH),A			; DISPLAY COMMAND/STATUS
						;LD	HL,(GRX)
						pop hl
						
						;CALL	SETBIT			; GET X
						LD 	A,L					; FIND OUT WHICH BIT..
						RLCA
						RLCA					; ..IN THE NIBBLE
						RLCA
						AND	18H					; @11000: mask for the the 2 changed bits
						LD 	B,A
						;LD	A,(PIXBIT)
PIXBIT:
						LD	A,$87				; SMC: $C7 for "SET n,A" or $87 for "RES n,A"..
						
						RET

