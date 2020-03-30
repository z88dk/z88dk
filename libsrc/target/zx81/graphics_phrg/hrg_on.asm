;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;   Set HRG mode
;
;	$Id: hrg_on.asm $
;

	MODULE    __pseudohrg_hrg_on

	SECTION	code_graphics
;	PUBLIC	hrgmode

	PUBLIC	hrg_on
	PUBLIC	_hrg_on
	
	EXTERN	base_graphics

	EXTERN        L0229
	EXTERN        L0292
	EXTERN        MTCH_P3

	INCLUDE "graphics/grafix.inc"


;hrgmode:	defb	2

.hrg_on
._hrg_on

; if hrgpage has not been specified, then set a default value

hires:
	; wait for video sync to reduce flicker
            ;halt
HRG_Sync:
            ld    hl,$4034        ; FRAMES counter
            ld    a,(hl)          ; get old FRAMES
HRG_Sync1:
            cp    (hl)            ; compare to new FRAMES
            jr    z,HRG_Sync1     ; exit after a change is detected
            
            ld    a,12        ; FONT ptr in ROM at address: 12 * 256 = 3072
            ld    i,a
            ld    iy,hresgen


IF (maxy>191)
			; patch is not necessary for 192 rows
ELSE
            ld  a,96-(maxy*6/12)
            ld	(MTCH_P3+1),a	; patch also our custom interrupt handler for 64 rows
ENDIF

            ret



hresgen:
            ;; ld hl,0e71eh
            ;ld hl,base_graphics+$8000-33	; (10)
			
			ld hl,(base_graphics)	; 16
			set 7,h					; 8
            ld de,33				; (unchanged)
			scf			; replaces 1 NOP
			ccf			; replaces 1 NOP
			sbc hl,de				; 15	--> total: 39-10=29
			
            di
            ld c,0feh
            
            ;ld b,$16    ; ORIGINAL timing
            
;            nop            ;  z88dk ADJUSTED timing
;            nop
;            nop			; 4-3: 1 tick sync difference  :/

            ;ld b,$15		; 14*13+8	-> Tuned on EO
			ld b,$13		; (14-3)*13+8	-> 39 ticks less, for dynamic position with base_graphics (tuned on EO)
            
sync3:        djnz sync3

            ld b,maxy
genline:    in a,(c)        ; trick the ULA and reset the..
            out (0ffh),a    ; ..character ROW counter
            add hl,de
            call ulaout
            dec b           ; row count
            jp nz, genline  ; loop
            call L0292
            call L0220
            ld iy,hresgen    ; re-set IX to point to hresgen
            jp 02a4h

ulaout:
            jp (hl)        ; 'execute' the display file at its shadowed position (the given row + $8000)

L0220:        
        PUSH    AF              ;
        PUSH    BC              ;
        PUSH    DE              ;
        PUSH    HL              ;
        JP      L0229           ; to DISPLAY-1   (was JR, equivalent T states, I think)

