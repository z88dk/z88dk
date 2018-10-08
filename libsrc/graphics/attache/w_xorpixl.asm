;
;       Otrona Attachè graphics routines
;		direct video HW access
;
;       Stefano Bodrato 2018
;
;
;       XOR pixel at (x,y) coordinate.
;
;
;	$Id: w_xorpixl.asm $
;


			INCLUDE	"graphics/grafix.inc"

			SECTION smc_clib
			PUBLIC	w_xorpixel

			EXTERN     l_cmp
			EXTERN	plot_setup

.w_xorpixel
                        push    hl
                        ld      hl,maxy
                        call    l_cmp
                        pop     hl
                        ret     nc               ; Return if Y overflows
						
                        push    de
                        ld      de,maxx
                        call    l_cmp
                        pop     de
                        ret     c               ; Return if X overflows
						
						call plot_setup
						
						AND	0E7H    ; mask for SMC code
						OR	B
						XOR	18H					; @11000: mask for the the 2 changed bits
						
						LD	(GRFBIT+1),A	; RES
						OR 40h
						LD	(GRFBIT1+1),A	; SET
						and 7Fh
						LD	(GRFBIT0+1),A	; BIT
						
						;CALL	XDDR			; SET X ADDRESS
						LD 	A,L					; X COORDINATE IN [HL]
						AND	0FCH				; @11111100, mask out the 2 rightmost bits
						OR	H
						RRCA
						RRCA

						LD 	B,A
						LD 	C,0FEH				; DISPLAY DATA
						IN	A,(C)
GRFBIT0:				BIT	0,A					; MODIFIED BIT TEST
GRFBIT:					RES	0,A					; MODIFIED BIT RESET
						JP  nz,is_reset
GRFBIT1:				SET	0,A					; MODIFIED BIT SET
is_reset:
						OUT	(C),A
						
						EI
						RET

