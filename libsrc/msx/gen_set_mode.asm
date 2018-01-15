;
;	z88dk library: Generic VDP support code
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode
;
;	$Id: gen_set_mode.asm,v 1.8 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_set_mode
	PUBLIC	_msx_set_mode
	PUBLIC  VDPreg_Write
	
	INCLUDE	"msx/vdp.inc"


msx_set_mode:
_msx_set_mode:
	ld	a,l
	and	a
	jr	z,initxt
	dec	a
	jr	z,init32
	dec	a
	jr	z,inigrp
	;dec	a
	;jr	z,inimlt


; Switch 2 Video Mode n. 0
initxt:
; MSX:  $00,$F0,$00,$00,$01,$00,$00,$F4
; SVI:  $00,$F0,$00,$FF,$01,$36,$07,$F4
; SC3:  $00,$F0,$0F,$FF,$03,$76,$03,$13
; MTX:  $00,$D0,$07,$00,$03,$7E,$07

    ld    c,$01
;IF FORsc3000
;	jp	$39E5
;ELSE
    ld    a,$D0
    call    VDPreg_Write    ; reg1  - text MODE
    
    ld    a,$07
    call    VDPreg_Write    ; reg2  -  NAME TABLE
    
    xor a
    call    VDPreg_Write    ; reg3  -  COLOUR TABLE
    
    ld    a,$03
    call    VDPreg_Write    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    
    ld    a,$7E
    call    VDPreg_Write    ; reg5  -  SPRITE ATTR. TAB.
    
    ld    a,$07
    call    VDPreg_Write    ; reg6  -  SPRITE PATTERN GEN. TAB.
    
    ld    a,$f5 ; (00 ?)
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    
		; reg0  - TEXT MODE
    ld    c,$00
IF FORm5
    ld    a,$01		; bit 1 (external video flag) must be set on Sord M5
ELSE
    xor a		; .. and reset on the other targets
ENDIF
    call    VDPreg_Write

	; reg1
    ld    a,$D0   ; ($C0 for MTX ?)  ; reg1 - TEXT MODE
    call    VDPreg_Write
    ret
;ENDIF

; Switch 2 Video Mode n. 1

init32:
; MSX:  $00,$E0,$06,$80,        $00,$36,$07,$04
; SVI?: $00,$E0,$06,$7F(00<>ff),$00,$36,$07,$04
; MTX?: $00,$D0,$04,$80,        $00,$7E,$07

    ld    c,$01
    ld    a,$D0
    call    VDPreg_Write    ; reg1  - text MODE
    
    ld    a,$04
    call    VDPreg_Write    ; reg2  -  NAME TABLE
    
    ld	a,$80
    call    VDPreg_Write    ; reg3  -  COLOUR TABLE
    
    xor		a
    call    VDPreg_Write    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    
    ld    a,$7E
    call    VDPreg_Write    ; reg5  -  SPRITE ATTR. TAB.
    
    ld    a,$07
    call    VDPreg_Write    ; reg6  -  SPRITE PATTERN GEN. TAB.
    
    ld    a,$f5 ; (00 ?)
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    
    
		; reg0  - TEXT MODE
    ld    c,$00
IF FORm5
    ld    a,$01		; bit 1 (external video flag) must be set on Sord M5
ELSE
    xor a		; .. and reset on the other targets
ENDIF
    call    VDPreg_Write
	
;
; -- Thanks to Saverio Russo his initial hints --
;
; Switch 2 Video Mode n. 2
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
inigrp:
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; SVI:  $02,$E0,$06,$FF,$03,$36,$07,$07
; MSX:  $02,$E0,$06,$FF,$03,$36,$07,$04
; SC3:  $02,$E0,$0E,$FF,$03,$76,$03,$05
; SC3B: $02,$E2,$0E,$FF,$03,$76,$03,$00
; EINS: $02,$C0,$0E,$FF,$03,$76,$03,$F4   $0F for backdrop color = WHITE 
; MTX:  $02,$C0,$0F,$FF,$03,$7E,$07
; MTXb:	$02,$C2,$0F,$FF,$03,$73,$07,$F3
; MTXc:	$02,$E2,$06,$FF,$03,$38,$07,$01	; astropac
; MTXd: $02,$C2,$06,$FF,$03,$38,$07,$01	; kilopede


;IF FORsc3000
;	jp	$39E2	; set screen 1
;ELSE
    ; reg1  - GRAPH MODE, first reset bit #6 to blank the screen
    ld    c,$01
IF FORm5
	ld a,$80	; bit 7 must be set on Sord M5
ELSE
	xor a		; bit 7 must be reset on sc3000
ENDIF
    call    VDPreg_Write
	
    ; reg2  -  NAME TABLE
IF FORmtx
    ld    a,$0f
ELSE
    ld    a,$0C
ENDIF
    call    VDPreg_Write

    ; reg3  -  COLOUR TABLE
    ld    a,$FF
    call    VDPreg_Write

    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    ld    a,$03
    call    VDPreg_Write
    
    ; reg5  -  SPRITE ATTR. TAB.
    ld    a,$76
    call    VDPreg_Write
    
    ; reg6  -  SPRITE PATTERN GEN. TAB.
    ld    a,$03
    call    VDPreg_Write
    
    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    xor   a
    call    VDPreg_Write

	; reg0  - GRAPH MODE
    ld    c,$00
IF FORm5
    ld    a,$03		; bit 1 (external video flag) must be set on Sord M5
ELSE
    ld    a,$02		; .. and reset on the other targets
ENDIF
    call    VDPreg_Write

	; reg1 - GRAPH MODE
	; (it was first set to $80)
    ld    a,$E2   ; (MTX ..or better C0 or C2?)
    call    VDPreg_Write

    ret
;ENDIF

; Switch 2 Video Mode n. 3
inimlt:
; On MTX, a game sets the 16 colours mode as follows:
; -- graph mode (reg0=2)
; reg1 - c2
; reg2 - 06		-- bit 0 and 3 are toggled ??
; reg3 - ff
; reg4 - 03
; reg5 - 38
; reg6 - 07
; reg7 - 01

	ret


; *** WRTVDP ***
; Copy a value into VDP reg
; IN: C = reg, A = val
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
VDPreg_Write:  
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

;IF FORsc3000
;	call $2BBF
;	inc c
;	ret
;ELSE

	ld	b,a
	
	ld a,i		; get the current status of the irq line
	di
	push af        
	ex (sp),hl
	ld (bit_irqstatus),hl
	pop hl

	ld	a,b
	out     (VDP_CMD),a
	ld      a,c
	and     $07
	or      $80		; enable bit for "set register" command
	out     (VDP_CMD),a
	inc     c
	
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af
	ret po
	ei
	
	ret
	
;ENDIF


	SECTION		bss_clib
	
bit_irqstatus:		defb 0
