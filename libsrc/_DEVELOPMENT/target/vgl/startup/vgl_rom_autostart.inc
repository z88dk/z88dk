;-------
; ROM signature that triggers auto-start (never used "in the wild", but the detection code was found in all V-Tech Genius Leader firmwares)
;-------
defb 55h
defb 0aah

; "YE" = auto-start signature
defb 59h	; "Y"
defb 45h	; "E"


; Jump past the signature
jp __SignatureAutostartEnd	; usually "jp	801fh"


;-------
; Default V-Tech ROM text at memory offset 0x8004
;-------

.rom_text
	;defb "VTECH PC-PROGCARD V1.00"	; Original text (23 bytes)
	defb "2017 by Bernhard Slawik"

.rom_version
	defb 01h


__SignatureAutostartEnd: