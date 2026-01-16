
SECTION FOTB
org 55000

; *** Song layout ***
LOOPSTART:            DEFW      PAT0
                      DEFW      PAT1
                      DEFW      PAT2
                      DEFW      PAT3
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT7
                      DEFW      PAT6
                      DEFW      PAT7
                      DEFW      PAT8
                      DEFW      PAT9
                      DEFW      PAT10
                      DEFW      PAT11
                      DEFW      PAT12
                      DEFW      PAT13
                      DEFW      PAT14
                      DEFW      PAT15
                      DEFW      PAT16
                      DEFW      PAT17
                      DEFW      PAT16
                      DEFW      PAT17
                      DEFW      PAT18
                      DEFW      PAT19
                      DEFW      PAT20
                      DEFW      PAT19
                      DEFW      PAT21
                      DEFW      PAT22
                      DEFW      PAT23
                      DEFW      PAT24
                      DEFW      PAT25
                      DEFW      PAT26
                      DEFW      PAT27
                      DEFW      PAT28
                      DEFW      PAT29
                      DEFW      PAT30
                      DEFW      PAT31
                      DEFW      PAT32
                      DEFW      PAT33
                      DEFW      PAT34
                      DEFW      PAT35
                      DEFW      PAT36
                      DEFW      PAT37
                      DEFW      PAT38
                      DEFW      PAT39
                      DEFW      PAT40
                      DEFW      PAT41
                      DEFW      PAT42
                      DEFW      PAT43
                      DEFW      PAT44
                      DEFW      PAT45
                      DEFW      PAT46
                      DEFW      PAT47
                      DEFW      PAT48
                      DEFW      PAT49
                      DEFW      PAT50
                      DEFW      PAT51
                      DEFW      PAT52
                      DEFW      PAT53
                      DEFW      PAT54
                      DEFW      PAT53
                      DEFW      PAT54
                      DEFW      PAT55
                      DEFW      PAT56
                      DEFW      PAT57
                      DEFW      PAT58
                      DEFW      PAT59
                      DEFW      PAT60
                      DEFW      PAT61
                      DEFW      PAT60
                      DEFW      PAT62
                      DEFW      PAT63
                      DEFW      PAT64
                      DEFW      PAT65
                      DEFW      PAT66
                      DEFW      PAT67
                      DEFW      PAT66
                      DEFW      PAT68
                      DEFW      PAT69
                      DEFW      PAT70
                      DEFW      PAT71
                      DEFW      PAT72
                      DEFW      PAT73
                      DEFW      PAT74
                      DEFW      PAT16
                      DEFW      PAT75
                      DEFW      PAT76
                      DEFW      PAT78
                      DEFW      PAT77
                      DEFW      $0000
                      DEFW      LOOPSTART

; *** Patterns ***
PAT0:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$92,$C3,$8E,$C1
                DEFB      $01    ,$01    ,$9D,$ED
                DEFB      $00    ,$00    ,$AD,$25
                DEFB      $01    ,$01    ,$BC,$68
                DEFB      $01    ,$01    ,$CD,$25
                DEFB      $01    ,$01    ,$DC,$68
                DEFB      $01    ,$01    ,$EB,$B6
                DEFB      $01    ,$01    ,$FB,$0D
                DEFB  $FF  ; End of Pattern

PAT1:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$00    ,$FB,$B6
                DEFB      $01    ,$01    ,$EB,$0D
                DEFB      $01    ,$01    ,$DA,$6E
                DEFB      $01    ,$01    ,$C9,$D9
                DEFB      $01    ,$01    ,$B9,$4B
                DEFB      $01    ,$01    ,$A8,$C6
                DEFB      $01    ,$01    ,$98,$47
                DEFB      $01    ,$01    ,$87,$D0
                DEFB  $FF  ; End of Pattern

PAT2:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $90,$EC,$B1,$61,$87,$60
                DEFB      $01    ,$01    ,$96,$F6
                DEFB      $00    ,$00    ,$A6,$92
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $01    ,$01    ,$D6,$34
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$86
                DEFB  $FF  ; End of Pattern

PAT3:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C4,$E7
                DEFB      $01    ,$01    ,$B4,$A5
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$23
                DEFB      $01    ,$01    ,$83,$E8
                DEFB  $FF  ; End of Pattern

PAT4:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $01    ,$01    ,$C3,$49
                DEFB      $01    ,$01    ,$D3,$1A
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$C3
                DEFB  $FF  ; End of Pattern

PAT5:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$7B
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$1A
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $01    ,$01    ,$A3,$1A
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$C3
                DEFB  $FF  ; End of Pattern

PAT6:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$3B,$B1,$D8,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $00    ,$00    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $01    ,$01    ,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$7B
                DEFB  $FF  ; End of Pattern

PAT7:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$B1,$76,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$7B
                DEFB      $01    ,$00    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$1A
                DEFB      $01    ,$B1,$3B,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$1A
                DEFB      $01    ,$00    ,$93,$49
                DEFB      $01    ,$01    ,$83,$7B
                DEFB  $FF  ; End of Pattern

PAT8:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B2,$76,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $00    ,$00    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $91,$F4,$B2,$76,$C3,$49
                DEFB      $01    ,$01    ,$D3,$1A
                DEFB      $00    ,$00    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$C3
                DEFB  $FF  ; End of Pattern

PAT9:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$B2,$76,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$1A
                DEFB      $00    ,$00    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$7B
                DEFB      $91,$A4,$B1,$D8,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $00    ,$00    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$7B
                DEFB  $FF  ; End of Pattern

PAT10:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$76,$01    ,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $00    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $91,$F4,$B2,$76,$C3,$49
                DEFB      $01    ,$01    ,$D3,$1A
                DEFB      $00    ,$00    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$C3
                DEFB  $FF  ; End of Pattern

PAT11:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$B2,$76,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$1A
                DEFB      $00    ,$00    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$7B
                DEFB      $91,$A4,$B1,$D8,$B3,$B0
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $00    ,$00    ,$94,$63
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT12:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$8D,$B2,$76,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $00    ,$00    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $91,$A4,$B2,$76,$C3,$E8
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $00    ,$00    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT13:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $90,$FA,$B1,$A4,$F4,$E7
                DEFB      $01    ,$01    ,$E4,$A5
                DEFB      $00    ,$00    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$23
                DEFB      $90,$D2,$B1,$61,$B3,$E8
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $00    ,$00    ,$94,$63
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT14:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $90,$FA,$B1,$A4,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $00    ,$00    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT15:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $01    ,$01    ,$E4,$A5
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$23
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT16:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $01    ,$01    ,$D4,$23
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB  $FF  ; End of Pattern

PAT17:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F3,$E8
                DEFB      $01    ,$01    ,$E4,$23
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$A5
                DEFB      $01    ,$01    ,$B4,$E7
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$94,$E7
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT18:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$A4,$81,$F4,$B4,$E7
                DEFB      $01    ,$92,$76,$01
                DEFB      $01    ,$A2,$C3,$00
                DEFB      $01    ,$B2,$76,$01
                DEFB      $01    ,$C2,$C3,$B4,$E7
                DEFB      $01    ,$D2,$76,$01
                DEFB      $01    ,$E2,$C3,$01
                DEFB      $01    ,$F2,$76,$01
                DEFB  $FF  ; End of Pattern

PAT19:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$F2,$9B,$B5,$37
                DEFB      $01    ,$E2,$52,$01
                DEFB      $01    ,$D2,$9B,$01
                DEFB      $01    ,$C2,$52,$01
                DEFB      $01    ,$B2,$9B,$01
                DEFB      $01    ,$A2,$52,$01
                DEFB      $01    ,$92,$9B,$01
                DEFB      $01    ,$82,$52,$01
                DEFB  $FF  ; End of Pattern

PAT20:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$00    ,$B4,$E7
                DEFB      $01    ,$92,$76,$01
                DEFB      $01    ,$A2,$C3,$00
                DEFB      $01    ,$B2,$76,$01
                DEFB      $01    ,$C2,$C3,$B4,$E7
                DEFB      $01    ,$D2,$76,$01
                DEFB      $01    ,$E2,$C3,$01
                DEFB      $01    ,$F2,$76,$01
                DEFB  $FF  ; End of Pattern

PAT21:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B1,$3B,$84,$E7
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $00    ,$00    ,$A4,$E7
                DEFB      $01    ,$01    ,$B4,$A5
                DEFB      $92,$52,$B2,$9B,$C4,$E7
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $00    ,$00    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT22:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B1,$3B,$F4,$E7
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $92,$52,$B2,$9B,$D4,$E7
                DEFB      $01    ,$01    ,$C4,$A5
                DEFB      $92,$31,$B2,$C3,$B4,$E7
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $92,$11,$B2,$ED,$94,$E7
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT23:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $81,$F4,$F3,$1A,$84,$E7
                DEFB      $91,$F4,$E3,$1A,$95,$37
                DEFB      $A1,$F4,$D3,$1A,$A5,$86
                DEFB      $B1,$F4,$C3,$1A,$B5,$DB
                DEFB      $C1,$F4,$B3,$1A,$C6,$34
                DEFB      $D1,$F4,$A3,$1A,$D5,$DB
                DEFB      $E1,$F4,$93,$1A,$E5,$86
                DEFB      $F1,$F4,$83,$1A,$F5,$37
                DEFB  $FF  ; End of Pattern

PAT24:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$86
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $FF  ; End of Pattern

PAT25:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$81,$08,$B4,$E7
                DEFB      $01    ,$91,$A4,$01
                DEFB      $01    ,$A1,$D8,$00
                DEFB      $01    ,$B1,$A4,$01
                DEFB      $01    ,$C1,$D8,$B6,$92
                DEFB      $01    ,$D1,$A4,$01
                DEFB      $01    ,$E1,$D8,$01
                DEFB      $01    ,$F1,$A4,$01
                DEFB  $FF  ; End of Pattern

PAT26:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $B6,$34,$F1,$BD,$96,$F6
                DEFB      $01    ,$E1,$8D,$01
                DEFB      $01    ,$D1,$BD,$01
                DEFB      $01    ,$C1,$8D,$01
                DEFB      $01    ,$B1,$BD,$01
                DEFB      $01    ,$A1,$8D,$01
                DEFB      $01    ,$91,$BD,$01
                DEFB      $01    ,$81,$8D,$01
                DEFB  $FF  ; End of Pattern

PAT27:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$00    ,$B6,$92
                DEFB      $01    ,$91,$A4,$01
                DEFB      $01    ,$A1,$D8,$00
                DEFB      $01    ,$B1,$A4,$01
                DEFB      $01    ,$C1,$D8,$B6,$92
                DEFB      $01    ,$D1,$A4,$01
                DEFB      $01    ,$E1,$D8,$01
                DEFB      $01    ,$F1,$A4,$01
                DEFB  $FF  ; End of Pattern

PAT28:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $96,$34,$F1,$BD,$B6,$F6
                DEFB      $01    ,$E1,$8D,$01
                DEFB      $01    ,$D1,$BD,$01
                DEFB      $01    ,$C1,$8D,$01
                DEFB      $01    ,$B1,$BD,$01
                DEFB      $01    ,$A1,$8D,$01
                DEFB      $01    ,$91,$BD,$01
                DEFB      $01    ,$81,$8D,$01
                DEFB  $FF  ; End of Pattern

PAT29:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$B1,$A4,$86,$92
                DEFB      $01    ,$01    ,$96,$F6
                DEFB      $01    ,$00    ,$A6,$92
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $91,$8D,$B1,$BD,$C6,$92
                DEFB      $01    ,$01    ,$D6,$F6
                DEFB      $00    ,$00    ,$E6,$92
                DEFB      $01    ,$01    ,$F6,$34
                DEFB  $FF  ; End of Pattern

PAT30:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$B1,$A4,$F6,$92
                DEFB      $01    ,$01    ,$E6,$F6
                DEFB      $91,$8D,$B1,$BD,$D6,$92
                DEFB      $01    ,$01    ,$C6,$34
                DEFB      $91,$76,$B1,$D8,$B6,$92
                DEFB      $01    ,$01    ,$A6,$F6
                DEFB      $91,$61,$B1,$F4,$96,$92
                DEFB      $01    ,$01    ,$86,$34
                DEFB  $FF  ; End of Pattern

PAT31:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$4D,$B2,$11,$86,$92
                DEFB      $01    ,$01    ,$96,$F6
                DEFB      $01    ,$00    ,$A7,$60
                DEFB      $01    ,$01    ,$B7,$D0
                DEFB      $00    ,$01    ,$C8,$47
                DEFB      $01    ,$01    ,$D7,$D0
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $FF  ; End of Pattern

PAT32:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F6,$92
                DEFB      $01    ,$01    ,$E6,$F6
                DEFB      $01    ,$01    ,$D7,$60
                DEFB      $01    ,$01    ,$C7,$D0
                DEFB      $01    ,$01    ,$B8,$47
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $01    ,$01    ,$97,$60
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT33:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$4D,$B2,$31,$86,$92
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $00    ,$00    ,$A5,$DB
                DEFB      $01    ,$01    ,$B5,$86
                DEFB      $00    ,$01    ,$C5,$37
                DEFB      $01    ,$01    ,$D6,$F6
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$F6,$34
                DEFB  $FF  ; End of Pattern

PAT34:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$4D,$B2,$31,$F6,$92
                DEFB      $01    ,$01    ,$E6,$34
                DEFB      $00    ,$00    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$86
                DEFB      $91,$76,$B2,$31,$B5,$37
                DEFB      $01    ,$01    ,$A5,$86
                DEFB      $00    ,$00    ,$95,$DB
                DEFB      $01    ,$01    ,$86,$34
                DEFB  $FF  ; End of Pattern

PAT35:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$4D,$B2,$31,$86,$92
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $00    ,$00    ,$A5,$DB
                DEFB      $01    ,$01    ,$B5,$86
                DEFB      $91,$08,$B1,$BD,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $00    ,$00    ,$E5,$37
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB  $FF  ; End of Pattern

PAT36:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$18,$B1,$A4,$F5,$37
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $00    ,$00    ,$D5,$DB
                DEFB      $01    ,$01    ,$C6,$34
                DEFB      $90,$FA,$B1,$A4,$B5,$DB
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $00    ,$00    ,$96,$92
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT37:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $90,$EC,$B1,$D8,$8E,$C1
                DEFB      $01    ,$01    ,$9D,$ED
                DEFB      $01    ,$01    ,$AD,$25
                DEFB      $01    ,$01    ,$BC,$68
                DEFB      $01    ,$01    ,$CD,$25
                DEFB      $01    ,$01    ,$DC,$68
                DEFB      $01    ,$01    ,$EB,$B6
                DEFB      $01    ,$01    ,$FB,$0D
                DEFB  $FF  ; End of Pattern

PAT38:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$FB,$B6
                DEFB      $01    ,$01    ,$EB,$0D
                DEFB      $01    ,$01    ,$DA,$6E
                DEFB      $01    ,$01    ,$C9,$D9
                DEFB      $01    ,$01    ,$B9,$4B
                DEFB      $01    ,$01    ,$A8,$C6
                DEFB      $01    ,$01    ,$98,$47
                DEFB      $01    ,$01    ,$87,$D0
                DEFB  $FF  ; End of Pattern

PAT39:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$00    ,$87,$60
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $01    ,$01    ,$A7,$60
                DEFB      $01    ,$01    ,$B6,$F6
                DEFB      $90,$EC,$B1,$D8,$C7,$60
                DEFB      $01    ,$01    ,$D7,$D0
                DEFB      $90,$BB,$B1,$76,$E7,$60
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $FF  ; End of Pattern

PAT40:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $90,$9D,$B1,$3B,$F7,$60
                DEFB      $01    ,$01    ,$E7,$D0
                DEFB      $90,$7D,$B0,$FA,$D7,$60
                DEFB      $01    ,$01    ,$C6,$F6
                DEFB      $90,$9D,$B1,$3B,$B7,$60
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $90,$BB,$B1,$76,$97,$60
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT41:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $90,$EC,$B1,$D8,$87,$60
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $01    ,$01    ,$A7,$60
                DEFB      $01    ,$01    ,$B6,$F6
                DEFB      $B0,$EC,$F1,$D8,$C7,$60
                DEFB      $01    ,$01    ,$D7,$D0
                DEFB      $B0,$BB,$F1,$76,$E7,$60
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $FF  ; End of Pattern

PAT42:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $B0,$9D,$B1,$3B,$F7,$60
                DEFB      $01    ,$01    ,$E7,$D0
                DEFB      $B0,$7D,$B0,$FA,$D7,$60
                DEFB      $01    ,$01    ,$C6,$F6
                DEFB      $B0,$9D,$B1,$3B,$B7,$60
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $B0,$BB,$B1,$76,$97,$60
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT43:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$81,$D8,$B7,$60
                DEFB      $01    ,$91,$BD,$01
                DEFB      $01    ,$A1,$A4,$00
                DEFB      $01    ,$B1,$8D,$01
                DEFB      $01    ,$C1,$A4,$01
                DEFB      $01    ,$D1,$8D,$01
                DEFB      $01    ,$E1,$76,$01
                DEFB      $01    ,$F1,$61,$01
                DEFB  $FF  ; End of Pattern

PAT44:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$F1,$76,$01
                DEFB      $01    ,$E1,$61,$01
                DEFB      $01    ,$D1,$4D,$01
                DEFB      $01    ,$C1,$3B,$01
                DEFB      $01    ,$B1,$29,$01
                DEFB      $01    ,$A1,$18,$01
                DEFB      $01    ,$91,$08,$01
                DEFB      $01    ,$80,$FA,$01
                DEFB  $FF  ; End of Pattern

PAT45:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$80,$EC,$01
                DEFB      $01    ,$90,$FA,$01
                DEFB      $01    ,$A0,$EC,$01
                DEFB      $01    ,$B0,$DE,$01
                DEFB      $01    ,$C0,$EC,$B7,$60
                DEFB      $01    ,$D0,$FA,$01
                DEFB      $01    ,$E0,$EC,$B5,$DB
                DEFB      $01    ,$F0,$DE,$01
                DEFB  $FF  ; End of Pattern

PAT46:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$F0,$EC,$B4,$E7
                DEFB      $01    ,$E0,$FA,$01
                DEFB      $01    ,$D0,$EC,$B3,$E8
                DEFB      $01    ,$C0,$DE,$01
                DEFB      $01    ,$B0,$EC,$B4,$E7
                DEFB      $01    ,$A0,$FA,$01
                DEFB      $01    ,$90,$EC,$B5,$DB
                DEFB      $01    ,$80,$DE,$01
                DEFB  $FF  ; End of Pattern

PAT47:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$80,$EC,$97,$60
                DEFB      $01    ,$90,$FA,$01
                DEFB      $01    ,$A0,$EC,$01
                DEFB      $01    ,$B0,$DE,$01
                DEFB      $01    ,$C0,$EC,$F7,$60
                DEFB      $01    ,$D0,$FA,$01
                DEFB      $01    ,$E0,$EC,$F5,$DB
                DEFB      $01    ,$F0,$DE,$01
                DEFB  $FF  ; End of Pattern

PAT48:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$F0,$EC,$E4,$E7
                DEFB      $01    ,$E0,$FA,$01
                DEFB      $01    ,$D0,$EC,$D3,$E8
                DEFB      $01    ,$C0,$DE,$01
                DEFB      $01    ,$B0,$EC,$C4,$E7
                DEFB      $01    ,$A0,$FA,$01
                DEFB      $01    ,$90,$EC,$B5,$DB
                DEFB      $01    ,$80,$DE,$01
                DEFB  $FF  ; End of Pattern

PAT49:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$80,$EC,$A7,$60
                DEFB      $01    ,$90,$FA,$01
                DEFB      $01    ,$A1,$08,$00
                DEFB      $01    ,$B1,$18,$01
                DEFB      $01    ,$C1,$29,$01
                DEFB      $01    ,$D1,$3B,$01
                DEFB      $01    ,$E1,$4D,$01
                DEFB      $01    ,$F1,$61,$01
                DEFB  $FF  ; End of Pattern

PAT50:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$00    ,$F1,$76
                DEFB      $01    ,$01    ,$E1,$8D
                DEFB      $01    ,$01    ,$D1,$A4
                DEFB      $01    ,$01    ,$C1,$BD
                DEFB      $01    ,$01    ,$B1,$D8
                DEFB      $01    ,$01    ,$A1,$F4
                DEFB      $01    ,$01    ,$92,$11
                DEFB      $01    ,$01    ,$82,$31
                DEFB  $FF  ; End of Pattern

PAT51:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$82,$52
                DEFB      $01    ,$01    ,$92,$76
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$B2,$C3
                DEFB      $01    ,$01    ,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$1A
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$7B
                DEFB  $FF  ; End of Pattern

PAT52:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$7B
                DEFB      $01    ,$01    ,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$7B
                DEFB  $FF  ; End of Pattern

PAT53:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B2,$ED,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $00    ,$00    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $01    ,$01    ,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$7B
                DEFB  $FF  ; End of Pattern

PAT54:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$B2,$ED,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$7B
                DEFB      $01    ,$00    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$1A
                DEFB      $01    ,$B2,$76,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$1A
                DEFB      $01    ,$00    ,$93,$49
                DEFB      $01    ,$01    ,$83,$7B
                DEFB  $FF  ; End of Pattern

PAT55:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B2,$ED,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $00    ,$00    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $91,$F4,$B2,$76,$C3,$49
                DEFB      $01    ,$01    ,$D3,$1A
                DEFB      $00    ,$00    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$C3
                DEFB  $FF  ; End of Pattern

PAT56:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$B2,$76,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$1A
                DEFB      $00    ,$00    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$7B
                DEFB      $91,$D8,$B1,$A4,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $00    ,$00    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$7B
                DEFB  $FF  ; End of Pattern

PAT57:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$76,$B2,$76,$83,$B0
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $00    ,$00    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $91,$F4,$B2,$76,$C3,$49
                DEFB      $01    ,$01    ,$D3,$1A
                DEFB      $00    ,$00    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$C3
                DEFB  $FF  ; End of Pattern

PAT58:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$B2,$76,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$1A
                DEFB      $00    ,$00    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$7B
                DEFB      $91,$D8,$B1,$A4,$B3,$B0
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $00    ,$00    ,$94,$63
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT59:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$8D,$B2,$31,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $00    ,$00    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $91,$A4,$B1,$F4,$C3,$E8
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $00    ,$00    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT60:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$F4,$B3,$49,$F4,$E7
                DEFB      $01    ,$01    ,$E4,$A5
                DEFB      $00    ,$00    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$23
                DEFB      $91,$A4,$B2,$C3,$B3,$E8
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $00    ,$00    ,$94,$63
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT61:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$F4,$B3,$49,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $00    ,$00    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT62:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$F4,$B3,$49,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $00    ,$00    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $92,$31,$B2,$9B,$C4,$63
                DEFB      $01    ,$01    ,$D4,$23
                DEFB      $00    ,$00    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB  $FF  ; End of Pattern

PAT63:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$F4,$B3,$49,$F3,$E8
                DEFB      $01    ,$01    ,$E4,$23
                DEFB      $00    ,$00    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$A5
                DEFB      $92,$76,$B3,$1A,$B4,$E7
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $00    ,$00    ,$94,$E7
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $FF  ; End of Pattern

PAT64:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$F4,$B3,$49,$84,$E7
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $00    ,$00    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$23
                DEFB      $91,$F4,$B3,$49,$C3,$E8
                DEFB      $01    ,$01    ,$D4,$23
                DEFB      $00    ,$00    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT65:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$B2,$ED,$F4,$E7
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $00    ,$00    ,$D5,$DB
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $91,$D8,$B2,$C3,$B7,$60
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $00    ,$00    ,$97,$60
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT66:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$3B,$B1,$D8,$87,$60
                DEFB      $01    ,$01    ,$96,$F6
                DEFB      $91,$D8,$B2,$ED,$A6,$92
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $00    ,$00    ,$C5,$DB
                DEFB      $01    ,$01    ,$D7,$D0
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $FF  ; End of Pattern

PAT67:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $B2,$ED,$00    ,$F7,$60
                DEFB      $01    ,$01    ,$E6,$F6
                DEFB      $00    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$C6,$34
                DEFB      $B2,$76,$01    ,$B5,$DB
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $00    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT68:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B2,$ED,$F7,$60
                DEFB      $01    ,$01    ,$E6,$F6
                DEFB      $00    ,$00    ,$D6,$92
                DEFB      $01    ,$01    ,$C6,$34
                DEFB      $92,$11,$B3,$49,$B5,$DB
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $00    ,$00    ,$96,$92
                DEFB      $01    ,$01    ,$86,$F6
                DEFB  $FF  ; End of Pattern

PAT69:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B2,$ED,$87,$60
                DEFB      $01    ,$01    ,$01
                DEFB      $00    ,$00    ,$A4,$A5
                DEFB      $01    ,$01    ,$B4,$E7
                DEFB      $92,$76,$B2,$77,$C5,$37
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $91,$F4,$B1,$F5,$E5,$DB
                DEFB      $01    ,$01    ,$F6,$34
                DEFB  $FF  ; End of Pattern

PAT70:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$A4,$B1,$A5,$F6,$92
                DEFB      $01    ,$01    ,$E6,$34
                DEFB      $91,$61,$B1,$62,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$86
                DEFB      $91,$A4,$B1,$A5,$B5,$DB
                DEFB      $01    ,$01    ,$A5,$86
                DEFB      $91,$F4,$B1,$F5,$95,$37
                DEFB      $01    ,$01    ,$84,$E7
                DEFB  $FF  ; End of Pattern

PAT71:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$76,$B2,$76,$84,$A5
                DEFB      $01    ,$01    ,$94,$E7
                DEFB      $00    ,$00    ,$A5,$37
                DEFB      $01    ,$01    ,$B5,$86
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $01    ,$01    ,$D6,$34
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $FF  ; End of Pattern

PAT72:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $91,$D8,$B3,$B0,$F7,$60
                DEFB      $01    ,$01    ,$E7,$D0
                DEFB      $00    ,$00    ,$D7,$60
                DEFB      $01    ,$01    ,$C6,$F6
                DEFB      $01    ,$01    ,$B7,$60
                DEFB      $01    ,$01    ,$A8,$47
                DEFB      $01    ,$01    ,$98,$C6
                DEFB      $01    ,$01    ,$89,$4B
                DEFB  $FF  ; End of Pattern

PAT73:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B4,$E7,$89,$D9
                DEFB      $01    ,$01    ,$99,$4B
                DEFB      $00    ,$00    ,$A8,$C6
                DEFB      $01    ,$01    ,$B8,$47
                DEFB      $92,$76,$B4,$63,$C8,$C6
                DEFB      $01    ,$01    ,$D8,$47
                DEFB      $00    ,$00    ,$E7,$D0
                DEFB      $01    ,$01    ,$F7,$60
                DEFB  $FF  ; End of Pattern

PAT74:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $92,$76,$B3,$E8,$F7,$D0
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $00    ,$00    ,$D6,$F6
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$86
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $FF  ; End of Pattern

PAT75:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$F3,$E8
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$D3,$7B
                DEFB      $01    ,$01    ,$C3,$49
                DEFB      $01    ,$01    ,$B3,$1A
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$92,$C3
                DEFB      $01    ,$01    ,$82,$9B
                DEFB  $FF  ; End of Pattern

PAT76:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$82,$76
                DEFB      $01    ,$01    ,$92,$9B
                DEFB      $01    ,$01    ,$A2,$76
                DEFB      $01    ,$01    ,$B2,$52
                DEFB      $01    ,$01    ,$C2,$9B
                DEFB      $01    ,$01    ,$D2,$52
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$F2,$52
                DEFB      $01    ,$F0,$9D,$F2,$76
                DEFB      $01    ,$E1,$3B,$01
                DEFB      $01    ,$D1,$29,$D2,$C3
                DEFB      $01    ,$C1,$3B,$01
                DEFB      $01    ,$F1,$18,$B2,$ED
                DEFB      $01    ,$E1,$3B,$01
                DEFB      $01    ,$D0,$FA,$93,$49
                DEFB      $01    ,$C1,$3B,$01
                DEFB      $01    ,$00    ,$83,$B0
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$7B
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$D3,$7B
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$7B
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$B3,$B0,$D4,$23
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$B3,$B0,$B4,$63
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$B3,$49,$94,$A5
                DEFB      $01    ,$01    ,$01
                DEFB      $91,$3B,$B2,$ED,$84,$E7
                DEFB      $01    ,$01    ,$01
                DEFB      $00    ,$00    ,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$C1,$D8
                DEFB      $01    ,$01    ,$D1,$F4
                DEFB      $01    ,$01    ,$E2,$11
                DEFB      $01    ,$01    ,$F2,$31
                DEFB      $01    ,$01    ,$F2,$52
                DEFB      $01    ,$01    ,$E2,$76
                DEFB      $01    ,$01    ,$D2,$9B
                DEFB      $01    ,$01    ,$C2,$C3
                DEFB      $01    ,$01    ,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$1A
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$83,$7B
                DEFB      $01    ,$01    ,$83,$B0
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $01    ,$01    ,$C4,$A5
                DEFB      $01    ,$01    ,$D4,$E7
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$86
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB      $01    ,$01    ,$E6,$34
                DEFB      $01    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$C6,$F6
                DEFB      $01    ,$01    ,$B7,$60
                DEFB      $01    ,$01    ,$A8,$47
                DEFB      $01    ,$01    ,$98,$C6
                DEFB      $01    ,$01    ,$89,$4B
                DEFB  $FF  ; End of Pattern

PAT77:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $00    ,$00    ,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT78:
                DEFW  1451   ; was 1850     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$89,$D9
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $91,$3B,$B2,$76,$F4,$E7
                DEFB      $01    ,$01    ,$01
                DEFB      $00    ,$00    ,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $F0,$9D,$B1,$3C,$81,$3B
                DEFB      $E0,$9D,$01    ,$91,$3B
                DEFB      $D0,$9D,$01    ,$A1,$3B
                DEFB      $C0,$9D,$01    ,$B1,$3B
                DEFB      $B0,$9D,$01    ,$C1,$3B
                DEFB      $A0,$9D,$01    ,$D1,$3B
                DEFB      $90,$9D,$01    ,$E1,$3B
                DEFB      $80,$9D,$01    ,$F1,$3B
                DEFB  $FF  ; End of Pattern
