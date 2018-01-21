;
;       Clear Graphics Screen
;
;       Amstrad CPC version by Stefano Bodrato  15/6/2001
;
;
;	$Id: clg.asm,v 1.9 2016-06-19 21:10:08 dom Exp $
;


        SECTION   code_clib
        PUBLIC    clg
        PUBLIC    _clg

        INCLUDE "target/cpc/def/cpcfirm.def"
        
        INCLUDE	"graphics/grafix.inc"

; Possible colors: 0 (blue), 1 (yellow), 2 (cyan), 3 (red)
;
;

.clg
._clg
;; mode 1
ld a,2
	call    firmware
	defw scr_set_mode

; set border
ld bc,$1a1a	; white
push bc
call    firmware
defw	scr_set_border
pop bc

; set pen 0
	xor a
	call    firmware
	defw	scr_set_ink

; set pen 1
ld a,1
;ld bc,$0101	; blue
	ld bc,0
	call    firmware
	defw	scr_set_ink

;; set pen 2
;ld a,2
;ld bc,$0b0b	; sky blue
;	call    firmware
;	defw	scr_set_ink

;; set pen 3
;ld a,3
;ld bc,$0	; black
;	call    firmware
;	defw	scr_set_ink


;        ld      a,bcolor
;        call    firmware
;        defw    gra_set_paper
		
;        ld      a,fcolor
;        call    firmware
;        defw    gra_set_pen


	; gra_clear_window needs colors to be set, 
	; scr_clear forces default (cyan on blue)

        call    firmware
        defw    scr_clear
	
        call    firmware
		defw    gra_clear_window
        ret
