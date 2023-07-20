;
; 	ANSI Video handling for the Microbee
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_CHAR
	EXTERN	generic_console_printc
	EXTERN	__console_x
	EXTERN	INVRS

.ansi_CHAR
;	ld	hl,INVRS		;TODO: really?
;	or	(HL)
	ld	hl,INVRS
	ld  d,a
	xor a
	add (hl)
	ld  a,d
	jr  z,no_inverse
	add 144-32
.no_inverse
	ld	d,a
	ld	bc,(__console_x)
	ld	e,1
	call	generic_console_printc
	ret

	SECTION code_crt_init

	EXTERN ansicolumns
        EXTERN asm_bee_set_screenmode

        ; If we're compiled with -clib=ansi40 then set screenmode to 1
        ; else set to 0 (80column mode)
        ld      c,0
	ld	a,ansicolumns
        cp      40
        jr      nz,skip40
        ld      c,2
skip40:
        ld      a,c
        call    asm_bee_set_screenmode
