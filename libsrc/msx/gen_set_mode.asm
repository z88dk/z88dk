;
;	z88dk library: Generic VDP support code
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode
;
;	$Id: gen_set_mode.asm $
;

    SECTION code_clib
	PUBLIC	msx_set_mode
	PUBLIC	_msx_set_mode
	
	INCLUDE	"msx/vdp.inc"

	EXTERN	SETWRT
	EXTERN	FILVRM
	EXTERN	l_tms9918_disable_interrupts
	EXTERN	l_tms9918_enable_interrupts

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

    ld    e,$01
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
    ld    e,$00
    xor a		; .. and reset on the other targets
    call    VDPreg_Write

	; reg1
    ld    a,$D0   ; ($C0 for MTX ?)  ; reg1 - TEXT MODE
    call    VDPreg_Write
    ret

; Switch 2 Video Mode n. 1

init32:

; MSX:  $00,$E0,$06,$80,        $00,$36,$07,$04
; SVI?: $00,$E0,$06,$7F(00<>ff),$00,$36,$07,$04
; MTX?: $00,$D0,$04,$80,        $00,$7E,$07

    ld    e,$01
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
    
;    ld    a,$f5 ; (00 ?)
IF FORm5___2
	ld	a,1		; avoid transparent color (to be confirmed)
ELSE
    xor   a
ENDIF    
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    
		; reg0  - TEXT MODE
    ld    e,$00
IF FORm5___2
	ld	a,1		; external video flag bit must be set on M5
ELSE
    xor a		; .. and reset on the other targets
ENDIF
    call    VDPreg_Write
	ret
	
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
; M5:   $02,$E2,$06,$FF,$03,$36,$07,$61
; M5:   $03,$A2,$0E,$FF,$03,$76,$03,$11 ; name table at 3800 in place of 1800
; PV2:  $02,$82,$07,$ff,$03,$3e,$03,$f0 ; and then r1 = e2

; Compare example from MSX emulator for M5,
; on reg#0 of the SORD M5, external video flag bit must be set
; msx:  02 62 11 23 21 33 11 E0
; M5:   03 E2 11 23 21 33 11 E1

; Final state: 02 e0 06 ff 03 76 03 00


    ; reg1  - GRAPH MODE, first reset bit #6 to blank the screen
    ld    e,$01
	xor a		; bit 7 must be reset on sc3000
    call    VDPreg_Write
	
    ; reg2  -  NAME TABLE
IF FORmtx
    ld    a,$0f
ELSE
    ld    a,$06		; M5 = MSX = SVI
;    ld    a,$0C		; EINSTEIN ?
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
IF FORm5___2
    ld    a,$07		; M5 = MSX = SVI
ELSE
    ld    a,$03
ENDIF
    call    VDPreg_Write
    
    ; reg7  -  INK & PAPER-/BACKDROPCOL.
IF FORm5
	ld	a,1		; avoid transparent color (to be confirmed)
ELSE
    xor   a
ENDIF
    call    VDPreg_Write

	; reg0  - GRAPH MODE
    ld    e,$00
IF FORm5
    ld    a,$03		; set bit 0 on m5___2 (to be confirmed)
ELSE
    ld    a,$02		; .. and reset on the other targets
ENDIF
    call    VDPreg_Write

	; reg1 - GRAPH MODE
	; (it was first set to $80)
    ;ld    a,$E2   ; MTX, M5
IF FORadam
    ld	a,$D0		;Disable interrupt on Adam
ELSE
	ld    a,$E0   ; MTX, M5
ENDIF
    call    VDPreg_Write
	
	
	; Pattern table should probably be initialized on other targets as well,
	; Memotech MTX does not seem to require the initialization (discovered experimentally)
	; SETWRT on the M5 sets C correctly on exit, it may be differente elsewhere

	ld	hl,$1800
	call	SETWRT
IF VDP_DATA >= 0
	ld	bc,VDP_DATA
ENDIF
	xor	a
	ld	e,3
pattern:
IF VDP_DATA < 0
	ld	(-VDP_DATA),a
ELSE
	out	(c),a
ENDIF
	inc	a
	jr	nz,pattern
	dec	e
	jr	nz,pattern
	ld	bc,6144	; set VRAM attribute area
	ld	a,$F1	; white on black
	ld	hl,8192
	call	FILVRM
	ret

	
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
; IN: E = reg, A = val
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
VDPreg_Write:  
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

	ld		d,a
	call	l_tms9918_disable_interrupts
	ld		a,d
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	ld	bc,VDP_CMD
	out	(c),a
ENDIF
	ld      a,e
	and     $07
	or      $80		; enable bit for "set register" command
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	out	(c),a
ENDIF
	inc     e
	call	l_tms9918_enable_interrupts
	ret

