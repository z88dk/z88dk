;
;       ZX81 libraries
;
;--------------------------------------------------------------
; This code comes from the FidoNET Sinclair newsgroup
;--------------------------------------------------------------
;
;       $Id: invtxt.asm,v 1.1 2007-10-01 12:26:46 stefano Exp $
;
;----------------------------------------------------------------
;
; invtxt() - invert text display
;
;----------------------------------------------------------------

        XLIB    invtxt

invtxt:
                LD HL,(400CH)           ; DFILE ADDR
                LD C,16H                ; LINES=22
LOOP2:          LD B,20H                ; CHARS=32
LOOP1:          INC HL                  ; INC DFILE
                LD A,(HL)               ; DFILE CHAR
                ADD A,80H               ; IN A/ADD 80
                LD (HL),A               ; POKE DFILE
                DJNZ LOOP1              ; LINE COUNTER
                INC HL                  ; NEW LINE
                DEC C                   ; UNTIL C=0
                JR NZ, LOOP2            ; UNTIL B=0
                RET
