;
;		Copy the graphics area to the zx printer
;
;		Stefano Bodrato, 2018
;
;
;	$Id: arx_hardcopy.asm $
;
		SECTION code_clib
		PUBLIC    zx_hardcopy
		PUBLIC    _zx_hardcopy
		
		;EXTERN  base_graphics
		EXTERN  pixeladdress
		EXTERN  hr_rows
		EXTERN  zx_fast
		EXTERN  zx_slow


.zx_hardcopy
._zx_hardcopy

        CALL zx_fast

        LD A,(hr_rows)          ; 8 or 24 "text" rows

        ADD A
        ADD A
        ADD A                   ; *8

        LD B,A                  ; REGISTER B = 64 OR 192 LINES (192 X LOOP1)
;        LD HL,(base_graphics)   ; REGISTER HL POINTS TO 256X192 BIT ARRAY

        XOR A                   ; SET REGISTER BITS 0-7 TO ZERO
        OUT ($FB),A             ; START PRINTER (BIT 2=0)

.LOOP1
		push de
		push bc
		ld	h,0
		ld	a,(hr_rows)
		sub b
		ld	l,b
		call pixeladdress
		ld	h,d
		ld	l,e
		pop bc
		pop de

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

;; COPY-BYTES
.L0F14  LD      E,(HL)          ; get byte data
        ;INC     HL
		ld		a,8
        LD      B,A             ; B=8 for the COPY-BITS loop
		add		l				; move forward to 8 bytes
		ld		l,a
		ld		a,h
		adc		0
		ld		h,a
		
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
		
        DJNZ LOOP1              ; REPEAT 64 OR 192 TIMES

        PUSH BC                 ; BALANCE STACK

.copy_exit
        POP BC                  ; BALANCE STACK
        LD A,4                  ; BIT 2 IS PRINTER ON/OFF BIT
        OUT ($FB),A             ; TURN OFF PRINTER

        JP zx_slow
