;-------
; ROM signature
;-------
defb 55h
defb 0aah

; "GA" = normal signature
defb 47h	; "G"
defb 41h	; "A"


; Jump past the signature
jp __SignatureDefaultEnd	;jp	801fh


;-------
; Default V-Tech ROM text at offset 0x8004
;-------

.rom_text
	;defb "VTECH PC-PROGCARD V1.00"	; Original text
	defb "2017 by Bernhard Slawik"

.rom_version
	defb 01h


__SignatureDefaultEnd: