;-------
; Header for quiz ROMs (no code, just quiz data; if signature found: started via code at 0x2240 on model 4000)
;-------
defb 55h
defb 0aah

defb 11h	; ld	de, 
defb 02h	; Version/language?