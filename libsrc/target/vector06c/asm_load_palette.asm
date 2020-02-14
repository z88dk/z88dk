
	SECTION	code_driver
	PUBLIC	asm_load_palette

; Entry: hl = palette
;
; Note: Enable interrupts
;
asm_load_palette:
	ld	de,15
	add	hl,de
	ei
	halt
        ld de,$100f
INIT1:  ld a,e
        out ($02),a
        ld A,(hl)
        out ($0C),a
        out ($0C),a
        out ($0C),a
        out ($0C),a
        out ($0C),a
        dec hl
        out ($0C),a
        dec e
        out ($0C),a
        dec d
        out ($0C),a
        jp nz,INIT1
	ret


