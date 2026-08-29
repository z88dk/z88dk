;------------------------------------------------------------------------------
; zx81bas
; Copyright (C) Paulo Custodio, 2023-2026
; License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
;------------------------------------------------------------------------------

		include "consts.inc"

; Unplot pixel
; in:
; B = Y (0..43)
; C = X (0..63)
; out:
; carry set if coordinates out of range

		public unplot
		extern screen_addr
		
unplot:
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
        jr      nc, COLUMNS     ; Jump if an even coordinate to COLUMNS.

        ld      a, $04          ; It is an odd y coordinate, but still assume an even x coordinate.

COLUMNS:
        sra     c               ; Test whether an even or odd x coordinate by dividing C by 2.
        jr      nc, FIND_ADDR   ; Jump if an even coordinate to FIND-ADDR.

        rlca                    ; It is an odd x coordinate so multiple by 2, i.e. A holds
                                ; $02 (even y coordinate) or $08 (odd y coordinate).

; By here the A register holds either $01 (even y, even x), $02 (even y, odd x),
; $04 (odd y, even x) or $08 (odd y, odd x),
; and B holds the row position and C the column position.

FIND_ADDR:
        push    af              ; Save the generated plot code.
        call    screen_addr     ; Call routine PRINT-AT to find the location within the display file.
		jr 		c, pop_error	; coordinates out of range
		
        ld      a, (hl)         ; Fetch the current character at the display file location.
        rlca                    ; Shift such that the 'invert' flags goes into bit 0. The low
                                ; 4 bits uniquely identifies all graphic plot characters.
        cp      $10             ; Did the location hold a graphic plot character (code $00 to $0F)?
        jr      nc, TABLE_PTR   ; Jump if not to TABLE-PTR.

        rrca                    ; Shift to restore the 'invert' flag, testing it in the process.
        jr      nc, SQ_SAVED    ; Jump if the 'invert' flag is reset (i.e. a non-inverted
                                ; character) to SQ-SAVED.

        xor     $8F             ; The existing character code is inverted so un-invert it.

SQ_SAVED:
        ld      b, a            ; Store the non-inverted character code of the existing
                                ; graphic character.

; Now determine whether plotting or unplotting.

TABLE_PTR:
        pop     af              ; Fetch the plot code.
        cpl                     ; Invert it and
        and     b               ; mask out the point in the existing character code.

; Plot and unplot join here. If the new generated graphic code is above $07 then it needs to
; be represented by an inverse character code.

UNPLOT:
        cp      $08             ; If the new graphic code below $08?
        jr      c, PLOT_END     ; Jump if so to PLOT-END.

        xor     $8F             ; Invert the graphic code to form the appropriate
                                ; inverse character code.

; The character code to display has been constructed.

PLOT_END:
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
