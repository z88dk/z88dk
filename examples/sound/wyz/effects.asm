
	SECTION	rodata_user

	PUBLIC	_myeffects

	defc	_myeffects = EFFECT_TABLE


;SFX format is quite simple:
;
;defb byte1,byte2
;defb byte1,byte2
;...
;defb $ff

;Where byte 1 and bits 7, 6, 5 & 4 from byte2 are the sound frequency 
;and bits 3, 2, 1 & 0 of byte2 is the amplitude.
;Effect finishes when &ff is found.

EFFECT_TABLE:
                defw _EFECTO0
                defw _EFECTO1
                defw _EFECTO2
                defw _EFECTO3


_EFECTO0:

defb $58,$0D
defb $50,$0B
defb $47,$0A
defb $3E,$06
defb $35,$03
defb $50,$09
defb $47,$0A
defb $3E,$07
defb $FF

_EFECTO1:

defb $58,$0C
defb $5D,$0D
defb $61,$0E
defb $66,$0F
defb $6A,$0E
defb $6F,$0D
defb $7A,$0C
defb $78,$0B
defb $7C,$0A
defb $85,$09
defb $8E,$08
defb $97,$07
defb $A0,$06
defb $A9,$05
defb $FF


_EFECTO2:

defb $1F,$0B
defb $1A,$0C
defb $1F,$0D
defb $16,$0E
defb $1F,$0E
defb $0D,$0D
defb $1F,$0C
defb $0D,$0B
defb $00,$00
defb $00,$00
defb $1F,$08
defb $1A,$09
defb $1F,$0A
defb $16,$0B
defb $1F,$0B
defb $0D,$0A
defb $1F,$09
defb $0D,$07
defb $00,$00
defb $00,$00
defb $1F,$06
defb $1A,$07
defb $1F,$08
defb $16,$08
defb $1F,$07
defb $0D,$06
defb $1F,$05
defb $FF

_EFECTO3:

defb $1A,$0E
defb $1A,$0E
defb $00,$00
defb $1A,$0A
defb $1A,$0A
defb $00,$00
defb $1A,$0C
defb $1A,$0C
defb $00,$00
defb $1A,$08
defb $1A,$08
defb $FF
