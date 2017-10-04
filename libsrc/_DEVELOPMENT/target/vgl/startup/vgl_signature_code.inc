;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROM signature for ROM cartridges containing code ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Must be first bytes in ROM
;SECTION CODE


; Default ROM lead-in
; 0x8000, 0x8001
defb 55h
defb 0aah


; Code identifier
IF __VGL_ROM_AUTOSTART = 1
   ; ROM signature which triggers auto-start (never used "in the wild", but the detection code was found in all V-Tech Genius Leader firmwares)
   ; "YE" = auto-start signature
   defb 59h ; "Y"
   defb 45h ; "E"
ELSE
   ; "GA" = normal signature (i.e. non-autostart code)
   ;defb 47h ; "G"
   ;defb 41h ; "A"
   
   ; PreComputer1000 autostart
   defb 0x33  ; 0x33 = autostart jump to 0x8010
   defb 0x00  ; Dont care
ENDIF

; Jump past the signature
jp __SignatureAutostartEnd ; usually "jp 801fh"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; V-Tech ROM text at memory offset 0x8004 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.rom_text
   ;defb "VTECH PC-PROGCARD V1.00"; Original text (23 bytes)
   IFDEF __VGL_MODEL
      ; Z88DK text with build info
      defb "Z88DK"
      defb " "
      defb "VGL"
      defb " "
      defb "MODEL"
      defb (0x30 + (__VGL_MODEL / 1000))
      
      ;defb (0x30 + (__VGL_MODEL % 1000) / 100)
      ;defb (0x30 + (__VGL_MODEL % 100) / 10)
      ;defb (0x30 + (__VGL_MODEL % 10))
      jp __SignatureAutostartEnd  ; 0x8010 is entry point for PreComputer 1000
      
      defb " "
      IF __VGL_ROM_AUTOSTART = 1
         defb "A"
      ELSE
         defb "N"
      ENDIF
      defb "  " ; pad to 23 characters
   ELSE
      defb "Z88DK minimal config   ";
   ENDIF

.rom_version
   defb 01h


__SignatureAutostartEnd: