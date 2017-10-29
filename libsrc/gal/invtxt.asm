;
;       Galaksija libraries
;
;--------------------------------------------------------------
; This code comes from the FidoNET Sinclair newsgroup
;--------------------------------------------------------------
;
;       $Id: invtxt.asm $
;
;----------------------------------------------------------------
;
; invtxt() - invert text display
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    invtxt
        PUBLIC    _invtxt

invtxt:
_invtxt:
				ld	hl,$2800        ; DFILE ADDR
				ld	bc,32*16
                LD A,(HL)            ; DFILE CHAR
                XOR 80H              ; ** invert it **
                LD (HL),A            ; POKE DFILE
				dec bc
				ld	a,b
				or c
				jr nz,invtxt
				ret
