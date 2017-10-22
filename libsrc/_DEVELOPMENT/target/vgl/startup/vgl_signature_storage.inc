;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROM signature for SRAM cartridges containing a file system ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Information taken from "SUPERSPEICHER" 32kb

; Must be first bytes in ROM
;SECTION CODE


; Default ROM lead-in
defb 55h
defb 0aah


; SRAM identifier (?)
defb 0eeh

; 0x8003: Status
defb 0
defb 0
defb 0


; 0x8006: FAT, uninitialized
;defb 0xbb
;defb 0x47

; 0x8006: FAT with initial files
; 7 empty files:
defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

defb 0xbb
defb "FEHLER"
defb 0xbc
defb 0x00

; 0x8048
defb 0x70
defb 0x70

; 0x8050: main storage area
defb 0x00
defb 0x00
defb 0x00
defb 0x00
defb 0x00
