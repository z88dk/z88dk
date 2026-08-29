;------------------------------------------------------------------------------
; zx81bas
; Copyright (C) Paulo Custodio, 2023-2026
; License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
;------------------------------------------------------------------------------

		include "consts.inc"

; lower the ramtop and exit to BASIC
; caller must put the requested ramtop value in RAMTOP

		public lower_ramtop

; image of the stack inside a USR routine
;	$8000	RAMTOP
; 	$7FFE				$3E00
;	$7FFC	ERR_SP		$0676	- inside NEXT_LINE, the BASIC interpreter
; 	...
;	$7FEE	SP

lower_ramtop:
		out		($FD), a		; turn off interrupts
		
        ld      hl, (RAMTOP)    ; fetch system variable RAMTOP.
        dec     hl              ; point to last system byte.
        ld      (hl), $3E       ; make GO SUB end-marker $3E - too high for
                                ; high order byte of line number.
        dec     hl              ; point to unimportant low-order byte.
		
		dec		hl
		ld 		(hl), $06
		dec 	hl
		ld 		(hl), $76		; put $0676 in the new stack
		
        ld      (ERR_SP), hl    ; set the error stack pointer ERR_SP to
                                ; the base of the now empty machine stack.
		
        ld      sp, hl          ; and initialize the stack-pointer to this

		out 	($FE), a		; turn interrupts back on
		
		rst 	$08				; exit with error 0 to unwind stack to $0676
		defb	$FF
