;;;; Helpers: Only needed for debugging the vgl lib
__HelpersStart:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; @FIXME: Just for testing ;;;;;;;;;;;;;;;;;;;

; Speaker off
ld	a, 0h	; +20h
out	(12h), a

call _main                  ; hl = return status


;jr __HelpersStart
;
;
;PUBLIC _print_char
;_print_char:
;	ld a, l
;	out	(0bh), a
;	call _delay_1fff
;	ret


PUBLIC _out_0x0a
_out_0x0a:
	ld	a, l
	out	(0ah),a
	
	call _delay_010f
	ret

;PUBLIC _out_0x0b
;_out_0x0b:
;	; Set cursor character?
;	ld	a, l
;	out	(0bh),a
;	call _delay_1fff
;	ret
;
;
;_delay_1fff:
;	; Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
;	push	hl
;	ld	hl, 1fffh
;_delay_1fff_loop:
;	dec	l
;	jr	nz, _delay_1fff_loop
;	dec	h
;	jr	nz, _delay_1fff_loop
;	pop	hl
;	ret

PUBLIC _delay_010f
_delay_010f:
	; Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
	push	hl
	ld	hl, 010fh
_delay_010f_loop:
	dec	l
	jr	nz, _delay_010f_loop
	dec	h
	jr	nz, _delay_010f_loop
	pop	hl
	ret

__HelpersEnd:

