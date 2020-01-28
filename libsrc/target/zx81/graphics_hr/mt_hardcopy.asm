;
;		Copy the graphics area to the zx printer
;
;		Stefano Bodrato, 2018
;
;
;	$Id: mt_hardcopy.asm $
;
		SECTION code_clib
		PUBLIC    zx_hardcopy
		PUBLIC    _zx_hardcopy
		
		EXTERN  zx_fast
		EXTERN  zx_slow


.zx_hardcopy
._zx_hardcopy

        CALL zx_fast
		
; REGISTER B = 64 OR 192 LINES (192 X LOOP1)
IF FORzx81mt64
		ld	b,64	; new row counter
ELSE
		ld	b,192	; new row counter
ENDIF

        LD HL,($407B)           ; REGISTER HL POINTS TO THE GRAPHICS D-FILE

        XOR A                   ; SET REGISTER BITS 0-7 TO ZERO
        OUT ($FB),A             ; START PRINTER (BIT 2=0)

.LOOP1
        IN A,($FB)              ; GET PRINTER STATUS BYTE
        RLA                     ; ROTATE BIT 7 (LF BUSY) TO C FLAG
        JR NC,LOOP1             ; LOOP IF LINEFEED IS BUSY

        PUSH BC                 ; SAVE ROW COUNT

.L0EF4  LD      A,B             ; row counter
        CP      $03             ; cleverly prepare a printer control mask
        SBC     A,A             ; to slow printer for the last two pixel lines
        AND     $02             ; keep bit 1
        OUT     ($FB),A         ; bit 2 is reset, turn on the zx printer 
        LD      D,A             ; save the printer control mask


;; COPY-L-1
.L0EFD  ;CALL    L1F54           ; routine 


.L1F54  LD      A,$7F           ; BREAK-KEY 
        IN      A,($FE)         ;
        RRA                     ;

        jr nc,copy_exit

;; COPY-CONT
.L0F0C  IN      A,($FB)         ; read printer port
        ADD     A,A             ; test bit 6 and 7
        JP      M,copy_exit     ; return if no printer or hw error

        JR      NC,L0F0C        ; if bit 7 is reset (LF BUSY), then wait

        LD      C,32            ; 32 bytes line
		LD      E,0
		JR      FIRSTCOL

;; COPY-BYTES
.L0F14  LD      E,(HL)          ; get byte data
.FIRSTCOL
        INC     HL
        LD      B,8             ; 8 bit

;; COPY-BITS
.L0F18  RL      D               ; mix the printer control mask
        RL      E               ; and the data byte
        RR      D               ; to alter the stylus speed

;; COPY-WAIT
.L0F1E  IN      A,($FB)         ; read the printer port
        RRA                     ; test for alignment signal from encoder.
        JR      NC,L0F1E        ; loop until not present to COPY-WAIT

        LD      A,D             ; control byte to A
        OUT     ($FB),A         ; and output to printer por
        DJNZ    L0F18           ; loop for all eight bits to COPY-BITS

        DEC     C               ; loop for all the 32 bytes in the current line
        JR      NZ,L0F14        ; to COPY-BYTES

        POP BC
		INC HL					; 33rd byte (HALT line terminator on Memotech HRG)
        DJNZ LOOP1              ; REPEAT 64 OR 192 TIMES

        PUSH BC                 ; BALANCE STACK

.copy_exit
        POP BC                  ; BALANCE STACK
        LD A,4                  ; BIT 2 IS PRINTER ON/OFF BIT
        OUT ($FB),A             ; TURN OFF PRINTER

        JP zx_slow
