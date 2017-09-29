;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ROM signature for ROM cartridges containing quiz data (no code) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Must be first bytes in ROM
;SECTION CODE


; Default ROM lead-in
defb 55h
defb 0aah


; Quiz identifier
defb 11h	; ld	de, 
defb 02h	; Version/language?