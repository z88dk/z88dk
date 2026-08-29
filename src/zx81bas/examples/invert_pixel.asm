;------------------------------------------------------------------------------
; zx81bas
; Copyright (C) Paulo Custodio, 2023-2026
; License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
;------------------------------------------------------------------------------

		include "consts.inc"

; Invert Pixel
; in:
; B = Y (0..43)
; C = X (0..63)
; out:
; carry set if coordinates out of range
; A = 0 (white)
; A = 1 (black)

		public invert_pixel
		extern screen_addr
		
invert_pixel:
        ld      a, 43           ; Is the specified y coordinate out of range, i.e. greater than 43?
        sub     b               ;
        jr      c, coord_error  ; return with carry set on error

		push 	bc
		push 	de
		push 	hl
		
; The y coordinate is within range and has been negated.

        ld      b, a            ; Store 43-y in B.

        ld      a, $01          ; Assume it is a point with even x and y coordinates.
        sra     b               ; Test whether an even or odd y coordinate by dividing B by 2.
		jr 		nc, IP_COL     ; Jump if an even coordinate to COLUMNS.

        ld      a, $04          ; It is an odd y coordinate, but still assume an even x coordinate.

IP_COL:
        sra     c               ; Test whether an even or odd x coordinate by dividing C by 2.
		jr 		nc, IP_ADDR   	; Jump if an even coordinate to IP_ADDR.

        rlca                    ; It is an odd x coordinate so multiple by 2, i.e. A holds
                                ; $02 (even y coordinate) or $08 (odd y coordinate).

; By here the A register holds either $01 (even y, even x), $02 (even y, odd x),
; $04 (odd y, even x) or $08 (odd y, odd x),
; and B holds the row position and C the column position.

IP_ADDR:
        push    af              ; Save the generated plot code.
        call    screen_addr     ; Call routine PRINT-AT to find the location within the display file.
		jr 		c, pop_error	; coordinates out of range
		
        ld      a, (hl)         ; Fetch the current character at the display file location.
        rlca                    ; Shift such that the 'invert' flags goes into bit 0. The low
                                ; 4 bits uniquely identifies all graphic plot characters.
        cp      $10             ; Did the location hold a graphic plot character (code $00 to $0F)?
		jr 		nc, IP_EMPTY   	; Jump if not to IP_EMPTY.

        rrca                    ; Shift to restore the 'invert' flag, testing it in the process.
		jr 		nc, IP_GOT    	; Jump if the 'invert' flag is reset (i.e. a non-inverted
                                ; character) to SQ-SAVED.

        xor     $8F             ; The existing character code is inverted so un-invert it.

IP_GOT:
		ld 		b, a 			; current 4-bit pattern
		jr 		IP_XOR
IP_EMPTY:
		ld 		b, 0 			; treat non-graphics as empty
IP_XOR:
        pop     af              ; Fetch the plot code and
		
		xor 	b 				; toggle pixel

; Plot and unplot join here. If the new generated graphic code is above $07 then it needs to
; be represented by an inverse character code.

UNPLOT:
        cp      $08             ; If the new graphic code below $08?
		jr 		c, IP_STORE     ; Jump if so to IP_STORE.

        xor     $8F             ; Invert the graphic code to form the appropriate
                                ; inverse character code.

; The character code to display has been constructed.

IP_STORE:
        ld		(hl), a         ; Call PRINT-A to update the display file location with
                                ; the new character code.

		pop		hl
		pop 	de
		pop 	bc
		
		and 	a				; signal OK
		
        ret

pop_error:
		pop		hl
		pop 	de
		pop 	bc

coord_error:
		scf						; signal error
		ret
