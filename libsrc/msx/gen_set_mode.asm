;
;	z88dk library: Generic VDP support code
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode
;
;	$Id: gen_set_mode.asm,v 1.2 2010-09-15 09:00:39 stefano Exp $
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
    call    VDPreg_Write    ; reg1
    
        
    ld    a,$0E
    call    VDPreg_Write    ; reg2
    
    ld    a,$FF
    call    VDPreg_Write    ; reg3
    
    ld    a,$03
    call    VDPreg_Write    ; reg4
    
    ld    a,$76
    call    VDPreg_Write    ; reg5
    
    ld    a,$03
    call    VDPreg_Write    ; reg6
    
    ld    a,$00
    call    VDPreg_Write    ; reg7
    
    
    ld    c,$00
IF FORm5
    ld    a,$03
ELSE
    ld    a,$02
ENDIF
    call    VDPreg_Write    ; reg0
    
    ld    a,$E2
    call    VDPreg_Write    ; reg1
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
