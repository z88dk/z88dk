;
;	Mattel AQUARIUS Routines
;
;	getk() Read key status
;
;	Dec 2001 -> Sept 2017 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.4+  (github exported) $
;


	SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	
	
.getk
._getk

        ld      bc,$00ff		; Scan all columns at once.
        in      a,(c)			; Read the results.
        cpl     				; invert - (a key down now gives 1)
        and     $3f				; check all rows.
		
        jr      z,getk_exit		; If NO key pressed, then exit.
								; else continue scanning, one column at a time.
SCNCOL8:
        ld      b,$7f			; 01111111 - scanning column 8
        in      a,(c)
        cpl     				; invert bits
        and     $0f				; check lower 4 bits
        jr      nz,KEYDOWN      ; there is a KEYDOWN

        ld      b,$bf			; 10111111 - start with column 7
SCNCOLS2:
		in      a,(c)
        cpl     				; invert bits
        and     $3f				; is there any key down?
        jr      nz,KEYDOWN		; YES: goto KEYDOWN, 
        rrc     b				; NO: try next column
        jr      c,SCNCOLS2		; when the 0 bit gets to CARRY FLAG we know
		
		; we have scanned all the columns, nothing found
		xor a
        jr      getk_exit


;
; KEYDOWN
; Jump here if a key is found to be pressed.
; the B register still holds the bit pattern of the column being scanned.
; so one bit of B will be 0 the rest 1
;
KEYDOWN:
        ld      de,$0000		; DE is used as a column counter.

;
; KROWCNT, converts the BIT number of the row and column into 
; actual numbers. So if bit 7 was set, a would hold 7.
; the column is multiplied by 6 so it can be added to the row number
; to give a unique scan code for each key.
; There are 8 columns of 6 keys giving a total of 48 keys.
;
KROWCNT:
        inc     e
        rra     
        jr      nc,KROWCNT		; Count how many rotations to get the bit into the carry.
        ld      a,e				; A now holds the bit number which was SET
								; eg if bit 4 of A was set, A would now be $04
KCOLCNT:
        rr      b
        jr      nc,KFOUND		; once the 0 bit gets to CARRY we jump to 
        add     a,$06			; add 6 for each rotate, to give the column number.
        jr      KCOLCNT

;
; At this point A = (column*6)+row
;
KFOUND:
		ld		e,a
		call	$1f01			; KDECODE + 1 (skip the scan count increment)
		

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

;	ld  (sticky_key),a
;
.getk_exit
	ld	l,a
	ld	h,0
	ret

