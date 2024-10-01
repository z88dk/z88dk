
        SECTION rodata_user

        PUBLIC  _myeffects

        defc    _myeffects=EFFECT_TABLE


;SFX format is quite simple:
;
;defb byte1,byte2,byte3
;defb byte1,byte2,byte3
;...
;defb $ff
;Effect finishes when &ff is found.

EFFECT_TABLE:
        defw    SONIDO0
        defw    SONIDO1
        defw    SONIDO2
        defw    SONIDO3
        defw    SONIDO4
        defw    SONIDO5
        defw    SONIDO6

;Efectos
;Efecto 'bass drum'
SONIDO0:
        DB      139, 63, 0, 162, 108, 0, 255
;Efecto 'drum'
SONIDO1:
        DB      232, 46, 0, 0, 91, 12, 255
;Efecto 'hithat'
SONIDO2:
        DB      0, 13, 1, 255
;Efecto 'bass drum vol 2'
SONIDO3:
        DB      186, 57, 0, 0, 102, 0, 162, 131, 0, 255
;Efecto 'Hit hat 2'
SONIDO4:
        DB      0, 9, 5, 255
;Efecto 'Bongo 1'
SONIDO5:
        DB      186, 31, 0, 232, 30, 0, 0, 45, 0, 69, 44, 0, 255
;Efecto 'Bongo 2'
SONIDO6:
        DB      69, 47, 0, 186, 46, 0, 46, 61, 0, 232, 60, 0, 255
