;
;	z88dk library: Generic VDP support code
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode
;
;	$Id: gen_set_mode.asm,v 1.3 2011-04-05 19:44:40 stefano Exp $
;


	XLIB	msx_set_mode
	
	INCLUDE	"msx/vdp.inc"


msx_set_mode:
	ld	a,l
	and	a
	jr	z,initxt
	dec	a
	jr	z,init32
	dec	a
	jr	z,inigrp
	dec	a
	jr	z,inimlt


; Switch 2 Video Mode n. 0
initxt:

; Switch 2 Video Mode n. 1
init32:


; Hint coming from Saverio Russo, a quick way to make things
; work quickly...  details will come afterwards.
;
; Switch 2 Video Mode n. 2
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
inigrp:
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

    ld    c,$01
    ld    a,$80
    call    VDPreg_Write    ; reg1  - GRAPH MODE
    
    ld    a,$0E   ; ($F0 for MTX ?)
    call    VDPreg_Write    ; reg2  -  NAME TABLE
    
    ld    a,$FF				;
    call    VDPreg_Write    ; reg3  -  COLOUR TABLE
    
    ld    a,$03
    call    VDPreg_Write    ; reg4  -  PT./TXT/MCOL-GEN.TAB.
    
    ld    a,$76
    call    VDPreg_Write    ; reg5  -  SPRITE ATTR. TAB.
    
    ld    a,$03
    call    VDPreg_Write    ; reg6  -  SPRITE PATTERN GEN. TAB.
    
    ld    a,$00
    call    VDPreg_Write    ; reg7  -  INK & PAPER-/BACKDROPCOL.
    
    
    ld    c,$00
IF FORm5
    ld    a,$03		; reg0  - GRAPH MODE
ELSE
    ld    a,$02		; reg0  - GRAPH MODE
ENDIF
    call    VDPreg_Write
    
    ld    a,$E2   ; ($C0 for MTX ?)  ; reg1 - GRAPH MODE
    call    VDPreg_Write
    ret


; Switch 2 Video Mode n. 3
inimlt:
	ret


; *** WRTVDP ***
; Copy a value into VDP reg
; IN: C = reg, A = val
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
VDPreg_Write:  
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»


	push    af
	out     (VDP_CMD),a
	ld      a,c
	and     $07
	or      $80
	out     (VDP_CMD),a
	inc    c
	pop     af
	ret     
