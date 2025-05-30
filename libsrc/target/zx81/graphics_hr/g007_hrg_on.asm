;--------------------------------------------------------------
; ZX81 HRG library for the G007 expansion
; by Stefano Bodrato, Fall 2014
;--------------------------------------------------------------
;
;   Set HRG mode
;
;	$Id: g007_hrg_on.asm $
;

    SECTION code_clib
    PUBLIC  hrg_on
    PUBLIC  _hrg_on
    EXTERN  base_graphics

    EXTERN  G007_P1
    EXTERN  G007_P2
    EXTERN  G007_P3


hrg_on:
_hrg_on:


; if hrgpage has not been specified, then set a default value
; TODO: this check should be improved, when the BASIC program is modified, the D-FILE shifts.
;       We also miss an option to provide a fixed position for the HRG page avoiding the
;       ROM's MAKE-ROOM approach.
;
;	ld      hl,(base_graphics)
;	ld      a,h
;	or      l
;	jr      nz,gotpage

  IF    FORzx81g64

	LD HL,($400C)    ; D-FILE
	LD A,$76
	DEC HL
	DEC HL
	CP (HL)
	jr z,__zx81g64_no_init

; ;$2DF8  01;92;19    LD BC,$1992         ; 6546 -> (6528+18) -> (34*192+18)
; ;$2DFB  2A;0C;40    LD HL,($400C)
; ;$2DFE  2B          DEC HL
; ;$2DFF  CD;9E;09    CALL $099E          ; [MAKE-ROOM]
; ;$2E02  3E;76       LD A,$76
; 
 	ld a,64
 	ld ($2318),a
; 	; TODO: find a working way to allocate a lower amount of memory
; 	;ld bc,34*64+18	;  an $2DF8 it uses to be $1992 (34*192+18)
; 	ld bc,192*64+18
; 	inc hl          ; points to D-FILE -1
; 	call $2DFF

	call $2DF8

__zx81g64_no_init:
  ELSE

	; check if we already have reserved graphics memory
	LD HL,($400C)    ; D-FILE
	LD A,$76
	DEC HL
	DEC HL
	CP (HL)
	call nz,$2DF8
    ;call 11807           ; Set up graphics page if not reserved yet

  ENDIF

;IF FORzx81g64
;	ld		hl,29000		; on a 16K system we leave a space of abt 1.5K bytes for stack
;ELSE
;	ld		hl,25000		; on a 16K system we leave a space of a bit more than 1K for stack
;ENDIF
;	ld		(base_graphics),hl
;	ld      ($2306),hl                  ; Current HRG page

;gotpage:
    ld      hl, ($2306)                 ; Current HRG page
    ld      (base_graphics), hl

    ld      de, 9
    add     hl, de

  IF    FORzx81g64
    ld      a, 65                       ; new row counter
  ELSE
    ld      a, 193                      ; new row counter
  ENDIF
    push    af

floop:
    ld      b, 34
zloop:
    ld      (hl), 0
    inc     hl
    djnz    zloop
    dec     a
    jr      nz, floop

;	No linefeed characters in G007 mode
;	the D-FILE is just a clean raster picture !
;
;	ld (hl),$76
;	inc hl
;	ld (hl),$76


	; wait for video sync to reduce flicker
;HRG_Sync:
;        ld      hl,$4034        ; FRAMES counter
;        ld      a,(hl)          ; get old FRAMES
;HRG_Sync1:
;        cp      (hl)            ; compare to new FRAMES
;        jr      z,HRG_Sync1     ; exit after a change is detected

; Patch the shadow rom
    pop     af
	;ld	a,193
    ld      (G007_P2+2), A              ; patch our custom interrupt handler

    ld      hl, display_3
    ld      (G007_P1+1), hl
    ld      (G007_P3+1), hl


	; In the normal ZX81 ROM BASIC the I register contains 0x1E, pointing
	; into the character pixel table in the ROM, Bit 0 of I is thus '0'.
	; In high res mode, the I register has the value 0x1F, where D0 is '1',
	; The G007 board uses the A8 bit to understand whether the ZX81 must run
	; in graphics or in text mode. During a refresh cyclem A0..A7 presents the
	; the contents of the refresh-row register (only D0-D6 count, D7 is just
	; whatever was last written into R), A8-15 present the contents of the
	; interrupt vector register.
	
    ld      a, $1f                      ; ROM address $1F00 +  enable graphics mode and shadow memory blocks
    ld      i, a

    ret



display_3:
;  HRG replacement fot DISPLAY-3
    dec     hl
    ld      a, ($4028)
IF FORzx81g64
    add		58
ENDIF
    ld      c, a
    pop     iy                          ;  z80asm will do an IX<>IY swap
    ld      a, ($403B)                  ; test CDFLAG
    and     128                         ; is in FAST mode ?
;	bit	7,(ix+$eb)	;  z80asm will do an IX<>IY swap
    jp      nz, $29d
        ;; zx81 rom:   jp   nz,$2a9         ; if so, jp to DISPLAY-4

    ld      a, $fe
    ld      b, 1
    ld      hl, $2d9a
    call    $2d95
	
    add     hl, hl
    nop
    ld      e, a
    ld      hl, (base_graphics)         ; Start address of HRG display file, less 9
    set     7, h
    jp      (iy)                        ;  z80asm will do an IX<>IY swap



; This is a DISPLAY-5 variant, perhaps toggling between "JP (HL)" and "HALT"
;00002D95:	LD R,A
;00002D97:	LD A,DDh
;00002D99:	EI
;00002D9A:	HALT



