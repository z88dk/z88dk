;
;       ZX81 libraries
;
;--------------------------------------------------------------
; This code comes from the FidoNET Sinclair newsgroup
;--------------------------------------------------------------
;
;       $Id: invtxt.asm,v 1.4 2016-06-26 20:32:08 dom Exp $
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
                LD HL,(400CH)        ; DFILE ADDR
                LD C,16H             ; LINES=22
LOOP2:          LD B,20H             ; CHARS=32
LOOP1:          INC HL               ; INC DFILE
                LD A,(HL)            ; DFILE CHAR
                XOR 80H              ; ** invert it **
                LD (HL),A            ; POKE DFILE
                DJNZ LOOP1           ; LINE COUNTER
                INC HL               ; NEW LINE
                DEC C                ; 
                JR NZ, LOOP2         ; UNTIL C=0
                RET
