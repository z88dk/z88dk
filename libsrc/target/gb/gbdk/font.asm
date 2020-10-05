; font.ms
;
;	Michael Hope, 1999
;	michaelh@earthling.net
;	Distrubuted under the Artistic License - see www.opensource.org
;


    INCLUDE "target/gb/def/gb_globals.def"


    PUBLIC	tmode_out
    PUBLIC	tmode
    PUBLIC	asm_setchar
    PUBLIC  asm_font_load
    PUBLIC  asm_font_set
    PUBLIC  asm_load_z88dk_font
    PUBLIC  asm_load_z88dk_udg

    GLOBAL	display_off


    GLOBAL	__console_y, __console_x

    EXTERN	asm_cls
    EXTERN	asm_adv_curs
    EXTERN	__mode
    EXTERN	generic_console_font32

    ; Structure offsets
    defc sfont_handle_sizeof    =	3
    defc sfont_handle_font      =	1
    defc sfont_handle_first_tile	=	0

    ; Other bits
    defc FONT_BCOMPRESSED	=	2

    defc CR     		= 	0x0A          ; Unix
    defc SPACE			=	0x00

    ; Maximum number of fonts
    defc MAX_FONTS		= 	6

    ; Globals from drawing.s
    ; FIXME: Hmmm... check the linkage of these
    GLOBAL	__fgcolour
    GLOBAL	__bgcolour

	SECTION	bss_driver
	; The current font
font_current:
	defs	sfont_handle_sizeof
	; +0 =
	; +1 = font address low
	; +2 = font address high
	; Cached copy of the first free tile
font_first_free_tile:
	defs	1
	; Table containing descriptors for all of the fonts
font_table:
	defs	sfont_handle_sizeof*MAX_FONTS
	
	SECTION	code_driver
	; Copy uncompressed 16 byte tiles from (BC) to (HL), length = DE*2
	; Note: HL must be aligned on a UWORD boundry
font_copy_uncompressed:
    ld      a,d
    or      e
    ret     z
    ld      a,h
    cp      0x98
    jr      c,fc_4
    sub     0x98-0x88
    ld      h,a
fc_4:
    xor     a
    cp      e		; Special for when e=0 you will get another loop
    jr      nz,fc_1
    dec     d
fc_1:
    ldh     a,(STAT)
    bit     1,a
    jr      nz,fc_1
    ld      a,(bc)
    ld	    (hl+),a
    inc	    bc
stat_1:	
    ldh     a,(STAT)
    bit     1,a
    jr      nz,stat_1
    ld      a,(bc)
    ld      (hl),a
    inc     bc
    inc	    l
    jr      nz,fc_2
    inc     h
    ld      a,h		; Special wrap-around
    cp      0x98
    jr      nz,fc_2
    ld      h,0x88
fc_2:
    dec     e
    jr      nz,fc_1
    dec     d
    bit     7,d		; -1?
    jr      z,fc_1
    ret

    ; Copy a set of compressed (8 bytes/cell) tiles to VRAM
    ; Sets the foreground and background colours based on the current
    ; font colours
    ; Entry:
    ;	From (BC) to (HL), length (DE) where DE = #cells * 8
    ;	Uses the current __fgcolour and __bgcolour fiedefs
font_copy_compressed:
    ld      a,d
    or      e
    ret     z		; Do nothing

    ld      a,h
    cp      0x98		; Take care of the 97FF -> 8800 wrap around
    jr      c,font_copy_compressed_loop
    sub     0x98-0x88
    ld      h,a
font_copy_compressed_loop:
    push    de
    ld      a,(bc)
    ld      e,a
    inc     bc
    push    bc

    ld      bc,0
        ; Do the background colour first
    ld      a,(__bgcolour)
    bit     0,a
    jr      z,font_copy_compressed_bg_grey1
    ld      b,0xFF
font_copy_compressed_bg_grey1:
    bit     1,a
    jr      z,font_copy_compressed_bg_grey2
    ld      c,0xFF
font_copy_compressed_bg_grey2:
    ; BC contains the background colour
    ; Compute what xoring we need to do to get the correct fg colour
    ld      d,a
    ld      a,(__fgcolour)
    xor     d
    ld      d,a

    bit     0,d
    jr      z,font_copy_compressed_grey1
    ld      a,e
    xor     b
    ld      b,a
font_copy_compressed_grey1:
    bit     1,d
    jr      z,font_copy_compressed_grey2
    ld      a,e
    xor     c
    ld      c,a
font_copy_compressed_grey2:
    ldh     a,(STAT)
    bit     1,a
    jr      nz,font_copy_compressed_grey2
    ld      (hl),b
    inc     hl
stat_2:
    ldh     a,(STAT)
    bit     1,a
    jr      nz,stat_2
    ld      (hl),c
    inc     hl
    ld      a,h		; Take care of the 97FFF -> 8800 wrap around
    cp      0x98
    jr      nz,fcc_1
    ld      h,0x88
fcc_1:
    pop     bc
    pop     de
    dec     de
    ld      a,d
    or      e
    jr      nz,font_copy_compressed_loop
    ret
	
; Load the font HL
asm_font_load:
    call    display_off
    push    hl

    ; Find the first free font entry
    ld      hl,font_table+sfont_handle_font
    ld      b,MAX_FONTS
font_load_find_slot:
    ld      a,(hl)		; Check to see if this entry is free
    inc     hl		; Free is 0000 for the font pointer
    or      (hl)
    jr      z,font_load_found

    inc     hl
    inc     hl
    dec     b
    jr      nz,font_load_find_slot
    pop     hl
    ld      hl,0
    jr      font_load_exit	; Couldn't find a free space
font_load_found:
    ; HL points to the end of the free font table entry
    pop     de
    ld      (hl),d		; Copy across the font struct pointer
    dec     hl
    ld      (hl),e

    ld      a,(font_first_free_tile)
    dec     hl
    ld      (hl),a		

    push    hl
    call    asm_font_set	; Set this new font to be the default

    ; Only copy the tiles in if were in text mode
    ld      a,(__mode)
    and     T_MODE

    call    nz,font_copy_current

    ; Increase the 'first free tile' counter
    ld      hl,font_current+sfont_handle_font
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a

    inc     hl		; Number of tiles used
    ld      a,(font_first_free_tile)
    add     a,(hl)
    ld      (font_first_free_tile),a

    pop     hl		; Return font setup in HL
font_load_exit:
    ;; Turn the screen on
    LDH     A,(LCDC)
    OR      @10000001       ; LCD           = On
                            ; BG            = On
    AND     @11100111       ; BG Chr        = 0x8800
                            ; BG Bank       = 0x9800
    LDH     (LCDC),A

    RET

	; Copy the tiles from the current font into VRAM
font_copy_current:	
    ; Find the current font data
    ld      hl,font_current+sfont_handle_font
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a     ;hl = font address

    inc     hl      ; Points to the 'tiles required' entry
    ld      e,(hl)
    ld      d,0
    rl      e       ; Multiple DE by 8
    rl      d
    rl      e
    rl      d
    rl      e
    rl      d       ; DE has the length of the tile data
    dec     hl

    ld      a,(hl)  ; Get the flags
    push    af
    and     3       ; Only lower 2 bits set encoding table size

    ld      bc,128
    cp      FONT_128ENCODING    ; 0 for 256 char encoding table, 1 for 128 char
    jr      z,font_copy_current_copy

    ld      bc,0
    cp      FONT_NOENCODING
    jr      z,font_copy_current_copy

    ld      bc,256  ; Must be 256 element encoding
font_copy_current_copy:
    inc     hl
    inc     hl      ; Points to the start of the encoding table
    add     hl,bc
    ld      c,l
    ld      b,h     ; BC points to the start of the tile data		

    ; Find the offset in VRAM for this font
    ld      a,(font_current+sfont_handle_first_tile)	; First tile used for this font
    ld      l,a		
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl

    ld      a,0x90  ; Tile 0 is at 9000h
    add     a,h
    ld      h,a
    ; Is this font compressed?
    pop	    af      ; Recover flags
    bit     FONT_BCOMPRESSED,a
    ; Do the jump in a mildly different way
    jp	    z,font_copy_uncompressed
    jp	    font_copy_compressed

; Set the current font to HL
asm_font_set:
    ld      a,(hl+)
    ld      (font_current),a
    ld      a,(hl+)
    ld      (font_current+1),a
    ld      a,(hl+)
    ld      (font_current+2),a
    ret


	;; Print a character without interpretation
out_char:
    call    asm_setchar
    call    asm_adv_curs
    ret


;; Print the character in A
; C =x, B=y
asm_setchar:
    push    af
    ld      a,(font_current+2)
    ; Must be non-zero if the font system is setup (cant have a font in page zero)
    or      a
    jr      nz,asm_setchar_3

    push    bc
    ; Font system is not yet setup - init it and copy in the default font
    ; Kind of a compatibility mode
    call    _font_init

    ; Need all of the tiles
    xor     a
    ld      (font_first_free_tile),a

    ld      hl,generic_console_font32
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    call    asm_font_load
    pop     bc
asm_setchar_3:
    pop     af
    push    de
    push    hl
    push    bc      ;Save coordinates
    ; Compute which tile maps to this character
    ld      e,a
    ld      hl,font_current+sfont_handle_font
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a     ;hl = address of font
    ld      a,(hl+) ;font encoding
    and     3
    cp      FONT_NOENCODING
    jr      z,asm_setchar_no_encoding
    inc     hl
    ; Now at the base of the encoding table
    ; E is set above
    ld      d,0
    add     hl,de
    ld      e,(hl)  ; That's the tile!
asm_setchar_no_encoding:
    ld      a,(font_current+0)  ;first tile
    add     a,e
    ld      e,a     ;e = tile to use

    pop     bc      ;c = x, b = y
    push    bc

    LD      L,B
    LD      H,0x00
    ADD     HL,HL
    ADD     HL,HL
    ADD     HL,HL
    ADD     HL,HL
    ADD     HL,HL
    LD      B,0x00  ;Add on x coordinate now
    ADD     HL,BC
    LD      BC,0x9800
    ADD     HL,BC

stat_4:
    ldh     a,(STAT)
    bit     1,a
    jr      nz,stat_4

    LD      (HL),E
    POP     BC
    POP     HL
    POP     DE
    RET


_font_init:
    push    bc
    call    tmode
    xor     a       ; We use the first tile as a space _always_
    ld      (font_first_free_tile),a

    ; Clear the font table
    ld      hl,font_table
    ld      b,sfont_handle_sizeof*MAX_FONTS
init_1:
    ld      (hl+),a
    dec     b
    jr      nz,init_1
    ld      (__bgcolour),a	;a = 0
    ld      a,3
    ld      (__fgcolour),a
    call    asm_cls
    pop     bc
    ret



    SECTION code_driver
    GLOBAL  vbl
    GLOBAL  lcd
    GLOBAL  int_0x40
    GLOBAL  int_0x48
    GLOBAL  remove_int

	;; Enter text mode
tmode:
    DI          ; Disable interrupts

    ;; Turn the screen off
    LDH     A,(LCDC)
    BIT     7,A
    JR      Z,tmode_1

    ;; Turn the screen off
    CALL    display_off

    ;; Remove any interrupts setup by the drawing routine

    ;	LD	BC,vbl
    ;	LD	HL,int_0x40
    ;	CALL	remove_int
    ;	LD	BC,lcd
    ;	LD	HL,int_0x48
    ;	CALL	remove_int
tmode_1:

    CALL    tmode_out

    ;; Turn the screen on
    LDH     A,(LCDC)
    OR      @10000001   ; LCD		= On
                        ; BG		= On
    AND     @11100111   ; BG Chr	= 0x8800
                        ; BG Bank	= 0x9800
    LDH     (LCDC),A
    EI                  ; Enable interrupts
    RET

;; Text mode (out only)
tmode_out:
    XOR     A
    LD      (__console_x),A
    LD      (__console_y),A
    ;; Clear screen
    CALL    asm_cls
    LD      A,T_MODE
    LD      (__mode),A
    RET



; Entry: bc = address of font (with gb header)
asm_load_z88dk_font:
    push    bc
    ld      a,(font_current+2)
    ; Must be non-zero if the font system is setup (cant have a font in page zero)
    and     a
    call    z,_font_init
    xor     a
    ld      (font_first_free_tile),a
    ld      c,l
    ld      b,h
    call    asm_font_load
    pop     bc
    ret

; Entry: bc = address of UDG bitmaps
asm_load_z88dk_udg:
    ld      a,(font_current+2)
    ; Must be non-zero if the font system is setup (cant have a font in page zero)
    and     a
    jr      nz,set_udgs
    push    bc
    ld      hl,generic_console_font32
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    call    asm_load_z88dk_font
    pop     bc
set_udgs:
    ld      hl,$8800    ;Tile 128 is the first UDG
    ld      de,64 * 8
    call    font_copy_compressed
    ret
    
