SECTION CODE

;-------
; ROM signature for cartridges containing code
;-------
defb 55h
defb 0aah

; "GA" = normal signature (i.e. non-autostart)
defb 47h	; "G"
defb 41h	; "A"


; Jump past the signature
jp __SignatureDefaultEnd	; usually jp	801fh


;-------
; V-Tech ROM text at memory offset 0x8004
;-------

.rom_text
   ;defb "VTECH PC-PROGCARD V1.00"	; Original text (23 bytes)
   ;defb "2017 by Bernhard Slawik"
   defb "Z88DK VGL MODEL "
   defb (0x30 + (__VGL_MODEL / 1000))
   defb (0x30 + (__VGL_MODEL % 1000) / 100)
   defb (0x30 + (__VGL_MODEL % 100) / 10)
   defb (0x30 + (__VGL_MODEL % 10))
   defb " C " ; pad to 23 characters

.rom_version
	defb 01h  ; at memory offset 0x8001b


__SignatureDefaultEnd: