
; Visual 1050, cursor redefinition.
; Stefano, September 2025

    PUBLIC  set_cursor

    EXTERN  v1050_sendchar
    EXTERN  __v1050_byte
    EXTERN  CRT_FONT


; Set the cursor shape
; Entry:    hl = 12 bytes bitmap to load from, or 0 to wipe the cursor

set_cursor:
    push    hl

    ld      d, -1

chr_loop:
    inc     d
    pop     hl

    ld      a,h           ; if HL=0, wipe the cursor
    or      l
    jr      z,blank_cursor

    ld      a, (hl)       ; otherwise it is a pointer to the cursor bitmap
    inc     hl
blank_cursor:

    push    hl
    call    load_cursor_byte
    ld      a, 12
    sub     d
    jr      nz, chr_loop

    pop     hl
    ret



	; Load a single byte in the cursor bitmap
	; D = row# in chr$ (0..11)
	; A = byte value

load_cursor_byte:

		; ESC > c ; row ; byte_value F

    push    af

    ld      l, 27
    call    v1050_sendchar
    ld      l, '>'
    call    v1050_sendchar
    ; chr% code, we set to special code 256
    ; to ask the slave 6502 CPU to update the cursor
    ld      l, '='
    call    v1050_sendchar
    ld      l, 0
    call    v1050_sendchar
    ld      l, 1
    call    v1050_sendchar

    ld      l, ';'
    call    v1050_sendchar

    ld      a, d
    call    __v1050_byte

    ld      l, ';'
    call    v1050_sendchar

    pop     af
    call    __v1050_byte
	
    ld      l, 'F'
    jp      v1050_sendchar


