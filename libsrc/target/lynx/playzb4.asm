;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
; Camputers Lynx version (4mhz CPU, 6 bit DAC on port $0084)
; calibrated for a fixed 8khz bitrate

;
;$Id: playzb4.asm $
;

; extern void __LIB__ playzb4(uchar *SamStart, ushort SamLen);
; play 4 bit pulse wave encoded data using sid master volume

	SECTION code_clib
	
	PUBLIC	playzb4
	PUBLIC	_playzb4

playzb4:
_playzb4:

;call    csv
;ld      l,(ix+6)        ;sample start addr
;ld      h,(ix+7)
;ld      e,(ix+8)        ;sample length
;ld      d,(ix+9)

pop	bc
pop	de	;sample length
pop	hl	;sample start addr
push	hl
push	de
push	bc

exx
ld bc,0x0084	; Output port
exx

rep1:
;; delay 1
ld   b,36
rep1b:                   ;repeat
djnz rep1b

ld      a,(hl)          ; a = sample byte
and     $f0             ; 4 bit nibble
srl a
srl a
exx
out		(c),a
exx

;; delay 2
ld   b,36
rep2:                   ;repeat
djnz rep2

ld      a,(hl)          ; a = sample byte
rlca                    ; a = a div 16
rlca                    ;
rlca                    ;
rlca                    ;
and     $f0             ; 4 bit nibble
srl a
srl a
exx
out		(c),a
exx

inc     hl              ; hl = hl+1
dec     e               ;
jr      nz,rep1         ;
dec     d               ; de = de-1
jr      nz,rep1         ;until de = 0


ret
