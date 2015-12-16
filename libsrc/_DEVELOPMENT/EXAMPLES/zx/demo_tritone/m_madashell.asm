
SECTION MADASHELL
org 55000

; *** Song layout ***
LOOPSTART:            DEFW      PAT125
                      DEFW      PAT126
                      DEFW      PAT0
                      DEFW      PAT1
                      DEFW      PAT2
                      DEFW      PAT1
                      DEFW      PAT3
                      DEFW      PAT4
                      DEFW      PAT3
                      DEFW      PAT4
                      DEFW      PAT11
                      DEFW      PAT12
                      DEFW      PAT21
                      DEFW      PAT22
                      DEFW      PAT23
                      DEFW      PAT24
                      DEFW      PAT25
                      DEFW      PAT26
                      DEFW      PAT27
                      DEFW      PAT28
                      DEFW      PAT29
                      DEFW      PAT31
                      DEFW      PAT32
                      DEFW      PAT33
                      DEFW      PAT34
                      DEFW      PAT41
                      DEFW      PAT42
                      DEFW      PAT43
                      DEFW      PAT44
                      DEFW      PAT51
                      DEFW      PAT52
                      DEFW      PAT51
                      DEFW      PAT54
                      DEFW      PAT22
                      DEFW      PAT23
                      DEFW      PAT24
                      DEFW      PAT25
                      DEFW      PAT26
                      DEFW      PAT27
                      DEFW      PAT28
                      DEFW      PAT29
                      DEFW      PAT31
                      DEFW      PAT32
                      DEFW      PAT33
                      DEFW      PAT34
                      DEFW      $0000
                      DEFW      LOOPSTART

; *** Patterns ***
PAT0:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$83,$B0,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $91,$18,$94,$63,$B4,$23
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $01    ,$01    ,$94,$23
                DEFB      $01    ,$01    ,$84,$23
                DEFB      $A1,$D8,$A3,$B0,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $B1,$A4,$B3,$49,$84,$73
                DEFB      $01    ,$01    ,$94,$83
                DEFB      $01    ,$01    ,$A4,$73
                DEFB      $01    ,$01    ,$B4,$63
                DEFB  $05,$C1,$18,$C2,$31,$C4,$73
                DEFB      $01    ,$01    ,$D4,$83
                DEFB      $01    ,$01    ,$E4,$73
                DEFB      $01    ,$01    ,$F4,$63
                DEFB      $D1,$3B,$D2,$76,$F4,$73
                DEFB      $01    ,$01    ,$E4,$83
                DEFB      $01    ,$01    ,$D4,$73
                DEFB      $01    ,$01    ,$C4,$63
                DEFB  $15,$E0,$EC,$E1,$D8,$B4,$73
                DEFB      $01    ,$01    ,$A4,$83
                DEFB      $01    ,$01    ,$94,$73
                DEFB      $01    ,$01    ,$84,$63
                DEFB      $F0,$D2,$F1,$A4,$84,$78
                DEFB      $01    ,$01    ,$94,$82
                DEFB      $01    ,$01    ,$A4,$78
                DEFB      $01    ,$01    ,$B4,$63
                DEFB  $06,$F0,$EC,$F1,$D8,$C4,$3B
                DEFB      $01    ,$01    ,$D4,$13
                DEFB      $01    ,$01    ,$E3,$FF
                DEFB      $01    ,$01    ,$F3,$E4
                DEFB      $E1,$18,$E2,$31,$E3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $01    ,$01    ,$B3,$B0
                DEFB  $16,$D1,$D8,$D3,$B0,$A3,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $C1,$A4,$C3,$49,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$B0
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB  $05,$B1,$18,$B2,$31,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $A0,$76,$A2,$76,$C4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB  $16,$90,$EC,$91,$D8,$84,$E7
                DEFB      $01    ,$01    ,$94,$E7
                DEFB      $01    ,$01    ,$A4,$E7
                DEFB      $01    ,$01    ,$B4,$E7
                DEFB  $06,$80,$D2,$81,$A4,$C4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT1:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$80,$76,$83,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$B0
                DEFB      $90,$EC,$90,$76,$C3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$49
                DEFB  $16,$A1,$D8,$A0,$EC,$F2,$C3
                DEFB      $01    ,$01    ,$E2,$C3
                DEFB      $01    ,$01    ,$D2,$C3
                DEFB      $01    ,$01    ,$C2,$C3
                DEFB      $B0,$EC,$B0,$76,$B2,$76
                DEFB      $01    ,$01    ,$A2,$76
                DEFB      $01    ,$01    ,$92,$76
                DEFB      $01    ,$01    ,$82,$76
                DEFB  $05,$C1,$18,$C0,$8C,$82,$31
                DEFB      $01    ,$01    ,$92,$31
                DEFB      $01    ,$01    ,$A2,$31
                DEFB      $01    ,$01    ,$B2,$31
                DEFB      $D0,$EC,$D0,$76,$C1,$D8
                DEFB      $01    ,$01    ,$D1,$D8
                DEFB      $01    ,$01    ,$E1,$D8
                DEFB      $01    ,$01    ,$F1,$D8
                DEFB  $16,$E1,$18,$E0,$8C,$F2,$31
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $F1,$3B,$F0,$9D,$F2,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$F0,$EC,$F0,$76,$F0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $E0,$EC,$E0,$76,$F0,$D2
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $16,$D1,$D8,$D0,$EC,$F0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $C0,$EC,$C0,$76,$F0,$D2
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$B1,$18,$B0,$8C,$F1,$18
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $A0,$EC,$A0,$76,$F0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $16,$91,$18,$90,$8C,$F1,$18
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$81,$3B,$80,$9D,$F1,$3B
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT2:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$80,$76,$F4,$63
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C5,$86
                DEFB      $90,$EC,$90,$76,$00
                DEFB      $01    ,$01    ,$00
                DEFB      $01    ,$01    ,$00
                DEFB      $01    ,$01    ,$00
                DEFB  $16,$A1,$D8,$A0,$EC,$83,$B0
                DEFB      $01    ,$01    ,$95,$86
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B5,$86
                DEFB      $B0,$EC,$B0,$76,$00
                DEFB      $01    ,$01    ,$00
                DEFB      $01    ,$01    ,$00
                DEFB      $01    ,$01    ,$00
                DEFB  $05,$C1,$18,$C0,$8C,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $D0,$EC,$D0,$76,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$B0
                DEFB  $16,$E1,$18,$E0,$8C,$83,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $F1,$3B,$F0,$9D,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB  $06,$F0,$EC,$F0,$76,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$C5
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$9B
                DEFB      $E0,$EC,$E0,$76,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$C5
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$9B
                DEFB  $16,$D1,$D8,$D0,$EC,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $C0,$EC,$C0,$76,$C4,$E7
                DEFB      $01    ,$01    ,$D4,$E7
                DEFB      $01    ,$01    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB  $05,$B1,$18,$B0,$8C,$F5,$86
                DEFB      $01    ,$01    ,$E5,$96
                DEFB      $01    ,$01    ,$D5,$A6
                DEFB      $01    ,$01    ,$C5,$96
                DEFB      $A0,$EC,$A0,$76,$B5,$86
                DEFB      $01    ,$01    ,$A5,$96
                DEFB      $01    ,$01    ,$95,$A6
                DEFB      $01    ,$01    ,$85,$96
                DEFB  $16,$91,$18,$90,$8C,$86,$92
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$B6,$92
                DEFB      $81,$3B,$80,$9D,$C7,$60
                DEFB      $01    ,$01    ,$D7,$60
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $01    ,$01    ,$F7,$60
                DEFB  $FF  ; End of Pattern

PAT3:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $E0,$8C,$E1,$18,$C5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $16,$D1,$18,$D2,$31,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $C0,$8C,$C1,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $05,$B0,$D2,$B1,$A4,$86,$34
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $A0,$8C,$A1,$18,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB  $16,$91,$18,$92,$31,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $80,$8C,$81,$18,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB  $06,$80,$8C,$81,$18,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $90,$8C,$91,$18,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $16,$A1,$18,$A2,$31,$B4,$63
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $B0,$8C,$B1,$18,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$C0,$D2,$C1,$A4,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $D0,$8C,$D1,$18,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $16,$E1,$18,$E2,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $F0,$8C,$F1,$18,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT4:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $E0,$8C,$E1,$18,$C5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $16,$D1,$18,$D2,$31,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $C0,$8C,$C1,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $05,$B0,$D2,$B1,$A4,$86,$34
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $A0,$8C,$A1,$18,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB  $16,$91,$18,$92,$31,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $80,$8C,$81,$18,$B6,$34
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $01    ,$01    ,$86,$34
                DEFB  $06,$80,$8C,$81,$18,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $90,$8C,$91,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$A1,$18,$A2,$31,$B4,$64
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $B0,$8C,$B1,$18,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$C0,$D2,$C1,$A4,$F8,$C6
                DEFB      $01    ,$01    ,$E9,$02
                DEFB      $01    ,$01    ,$D8,$C6
                DEFB      $01    ,$01    ,$C8,$8A
                DEFB      $D0,$8C,$D1,$18,$B8,$C6
                DEFB      $01    ,$01    ,$A9,$02
                DEFB      $01    ,$01    ,$98,$C6
                DEFB      $01    ,$01    ,$88,$8A
                DEFB  $16,$E1,$18,$E2,$31,$88,$C6
                DEFB      $01    ,$01    ,$99,$02
                DEFB      $01    ,$01    ,$A8,$C6
                DEFB      $01    ,$01    ,$B8,$8A
                DEFB      $F0,$8C,$F1,$18,$C8,$C6
                DEFB      $01    ,$01    ,$D9,$02
                DEFB      $01    ,$01    ,$E8,$C6
                DEFB      $01    ,$01    ,$F8,$8A
                DEFB  $FF  ; End of Pattern

PAT11:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$A6,$F1,$4D,$86,$34
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $E0,$A6,$E1,$4D,$C6,$34
                DEFB      $01    ,$01    ,$D6,$34
                DEFB      $01    ,$01    ,$E6,$34
                DEFB      $01    ,$01    ,$F6,$34
                DEFB  $16,$D1,$4D,$D2,$9B,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $01    ,$01    ,$B5,$DB
                DEFB      $C0,$A6,$C1,$4D,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB  $05,$B0,$FA,$B1,$F4,$A5,$DB
                DEFB      $01    ,$01    ,$B5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $A0,$A6,$A1,$4D,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB  $16,$90,$D2,$91,$A4,$C6,$92
                DEFB      $01    ,$01    ,$B6,$92
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $80,$A6,$81,$4D,$87,$D0
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $01    ,$01    ,$B7,$D0
                DEFB  $06,$80,$A6,$81,$4D,$CA,$6E
                DEFB      $01    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$EA,$6E
                DEFB      $01    ,$01    ,$F7,$D0
                DEFB      $90,$A6,$91,$4D,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $16,$A1,$4D,$A2,$9B,$AA,$6E
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$8A,$6E
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $B0,$A6,$B1,$4D,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$C0,$FA,$C1,$F4,$E6,$92
                DEFB      $01    ,$01    ,$F8,$C6
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$D8,$C6
                DEFB      $D0,$A6,$D1,$4D,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $16,$E0,$D2,$E1,$A4,$86,$92
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$B7,$D0
                DEFB      $F0,$A6,$F1,$4D,$00
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT12:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$A6,$F1,$4D,$86,$34
                DEFB      $01    ,$01    ,$96,$34
                DEFB      $01    ,$01    ,$A6,$34
                DEFB      $01    ,$01    ,$B6,$34
                DEFB      $E0,$A6,$E1,$4D,$C6,$F6
                DEFB      $01    ,$01    ,$D6,$F6
                DEFB      $01    ,$01    ,$E6,$F6
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $16,$D1,$4D,$D2,$9B,$E7,$D0
                DEFB      $01    ,$01    ,$D7,$D0
                DEFB      $01    ,$01    ,$C7,$D0
                DEFB      $01    ,$01    ,$B7,$D0
                DEFB      $C0,$A6,$C1,$4D,$A9,$4B
                DEFB      $01    ,$01    ,$99,$4B
                DEFB      $01    ,$01    ,$89,$4B
                DEFB      $01    ,$01    ,$99,$4B
                DEFB  $05,$B0,$FA,$B1,$F4,$AA,$6E
                DEFB      $01    ,$01    ,$BA,$6E
                DEFB      $01    ,$01    ,$CA,$6E
                DEFB      $01    ,$01    ,$DA,$6E
                DEFB      $A0,$A6,$A1,$4D,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB  $16,$90,$D2,$91,$A4,$C6,$92
                DEFB      $01    ,$01    ,$B6,$92
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $80,$A6,$81,$4D,$87,$D0
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $01    ,$01    ,$B7,$D0
                DEFB  $06,$80,$A6,$81,$4D,$C9,$D9
                DEFB      $01    ,$01    ,$D9,$ED
                DEFB      $01    ,$01    ,$EA,$01
                DEFB      $01    ,$01    ,$FA,$15
                DEFB      $90,$A6,$91,$4D,$EA,$29
                DEFB      $01    ,$01    ,$DA,$3D
                DEFB      $01    ,$01    ,$CA,$51
                DEFB      $01    ,$01    ,$BA,$58
                DEFB  $16,$A1,$4D,$A2,$9B,$AA,$6E
                DEFB      $01    ,$01    ,$9A,$B8
                DEFB      $01    ,$01    ,$8A,$6E
                DEFB      $01    ,$01    ,$9A,$24
                DEFB      $B0,$A6,$B1,$4D,$AA,$6E
                DEFB      $01    ,$01    ,$BA,$B8
                DEFB      $01    ,$01    ,$CA,$6E
                DEFB      $01    ,$01    ,$DA,$24
                DEFB  $05,$C0,$FA,$C1,$F4,$EA,$6E
                DEFB      $01    ,$01    ,$FA,$B8
                DEFB      $01    ,$01    ,$EA,$6E
                DEFB      $01    ,$01    ,$DA,$24
                DEFB      $D0,$A6,$D1,$4D,$CA,$6E
                DEFB      $01    ,$01    ,$BA,$B8
                DEFB      $01    ,$01    ,$AA,$6E
                DEFB      $01    ,$01    ,$9A,$24
                DEFB  $05,$E0,$D2,$E1,$A4,$8A,$6E
                DEFB      $01    ,$01    ,$99,$D9
                DEFB      $01    ,$01    ,$A9,$4B
                DEFB      $01    ,$01    ,$B8,$C6
                DEFB  $06,$F0,$A6,$F1,$4D,$C8,$47
                DEFB      $01    ,$01    ,$D7,$D0
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $FF  ; End of Pattern

PAT21:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$90,$D2,$F1,$A4,$F3,$49
                DEFB      $01    ,$E1,$A4,$01
                DEFB      $01    ,$D1,$A4,$E4,$63
                DEFB      $01    ,$C1,$A4,$01
                DEFB      $01    ,$B1,$A4,$D3,$49
                DEFB      $01    ,$A1,$A4,$01
                DEFB      $01    ,$91,$A4,$C4,$63
                DEFB      $01    ,$81,$A4,$01
                DEFB  $06,$01    ,$01    ,$B3,$49
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$C6,$F1,$8D,$F3,$1A
                DEFB      $01    ,$E1,$8D,$01
                DEFB      $01    ,$D1,$8D,$E3,$49
                DEFB      $01    ,$C1,$8D,$01
                DEFB      $01    ,$B1,$8D,$D3,$1A
                DEFB      $01    ,$A1,$8D,$01
                DEFB      $01    ,$91,$8D,$C3,$49
                DEFB      $01    ,$81,$8D,$01
                DEFB  $0E,$01    ,$01    ,$B3,$1A
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$90,$BB,$F1,$76,$F2,$ED
                DEFB      $01    ,$E1,$76,$01
                DEFB      $01    ,$D1,$76,$E3,$1A
                DEFB      $01    ,$C1,$76,$01
                DEFB      $01    ,$B1,$76,$D2,$ED
                DEFB      $01    ,$A1,$76,$01
                DEFB      $01    ,$91,$76,$C3,$1A
                DEFB      $01    ,$81,$76,$01
                DEFB  $15,$01    ,$01    ,$B2,$ED
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A3,$1A
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$A6,$F1,$4D,$F2,$9B
                DEFB      $01    ,$E1,$4D,$01
                DEFB      $01    ,$D1,$4D,$E2,$ED
                DEFB      $01    ,$C1,$4D,$01
                DEFB      $01    ,$B1,$4D,$D2,$9B
                DEFB      $01    ,$A1,$4D,$01
                DEFB      $01    ,$91,$4D,$C2,$ED
                DEFB      $01    ,$81,$4D,$01
                DEFB  $16,$01    ,$01    ,$B2,$9B
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$90,$7D,$F0,$FA,$F1,$F4
                DEFB      $01    ,$E0,$FA,$E1,$F4
                DEFB      $01    ,$D0,$FA,$D1,$F4
                DEFB      $01    ,$C0,$FA,$C1,$F4
                DEFB      $01    ,$B0,$FA,$B1,$F4
                DEFB      $01    ,$A0,$FA,$A1,$F4
                DEFB      $01    ,$90,$FA,$91,$F4
                DEFB      $01    ,$80,$FA,$81,$F4
                DEFB  $05,$90,$84,$F1,$08,$F2,$11
                DEFB      $01    ,$E1,$08,$E2,$11
                DEFB      $01    ,$D1,$08,$D2,$11
                DEFB      $01    ,$C1,$08,$C2,$11
                DEFB  $06,$01    ,$B1,$08,$B2,$11
                DEFB      $01    ,$A1,$08,$A2,$11
                DEFB      $01    ,$91,$08,$92,$11
                DEFB      $01    ,$81,$08,$82,$11
                DEFB  $FF  ; End of Pattern

PAT22:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$F2,$31
                DEFB      $01    ,$01    ,$E2,$31
                DEFB      $01    ,$01    ,$D2,$31
                DEFB      $01    ,$01    ,$C2,$31
                DEFB      $E0,$8C,$E1,$18,$B2,$31
                DEFB      $01    ,$01    ,$A2,$31
                DEFB      $01    ,$01    ,$92,$31
                DEFB      $01    ,$01    ,$82,$31
                DEFB  $16,$D1,$18,$D2,$31,$82,$31
                DEFB      $01    ,$01    ,$92,$31
                DEFB      $01    ,$01    ,$A2,$31
                DEFB      $01    ,$01    ,$B2,$31
                DEFB      $C0,$8C,$C1,$18,$C2,$31
                DEFB      $01    ,$01    ,$D2,$31
                DEFB      $01    ,$01    ,$E2,$31
                DEFB      $01    ,$01    ,$F2,$31
                DEFB  $07,$B0,$D2,$B1,$A4,$F2,$31
                DEFB      $01    ,$01    ,$E2,$45
                DEFB      $01    ,$01    ,$D2,$31
                DEFB      $01    ,$01    ,$C2,$1D
                DEFB      $A0,$8C,$A1,$18,$B2,$31
                DEFB      $01    ,$01    ,$A2,$47
                DEFB      $01    ,$01    ,$92,$31
                DEFB      $01    ,$01    ,$82,$1B
                DEFB  $16,$91,$18,$92,$31,$82,$31
                DEFB      $01    ,$01    ,$92,$49
                DEFB      $01    ,$01    ,$A2,$31
                DEFB      $01    ,$01    ,$B2,$19
                DEFB      $80,$8C,$81,$18,$C2,$31
                DEFB      $01    ,$01    ,$D2,$4B
                DEFB      $01    ,$01    ,$E2,$31
                DEFB      $01    ,$01    ,$F2,$17
                DEFB  $06,$80,$8C,$81,$18,$F2,$31
                DEFB      $01    ,$01    ,$E2,$4D
                DEFB      $01    ,$01    ,$D2,$31
                DEFB      $01    ,$01    ,$C2,$15
                DEFB      $90,$8C,$91,$18,$B2,$31
                DEFB      $01    ,$01    ,$A2,$4D
                DEFB      $01    ,$01    ,$92,$31
                DEFB      $01    ,$01    ,$82,$15
                DEFB  $16,$A1,$18,$A2,$31,$82,$31
                DEFB      $01    ,$01    ,$92,$4D
                DEFB      $01    ,$01    ,$A2,$31
                DEFB      $01    ,$01    ,$B2,$15
                DEFB      $B0,$8C,$B1,$18,$C2,$31
                DEFB      $01    ,$01    ,$D2,$4D
                DEFB      $01    ,$01    ,$E2,$31
                DEFB      $01    ,$01    ,$F2,$15
                DEFB  $07,$C0,$D2,$C1,$A4,$F2,$31
                DEFB      $01    ,$01    ,$E2,$4D
                DEFB      $01    ,$01    ,$D2,$31
                DEFB      $01    ,$01    ,$C2,$15
                DEFB      $D0,$8C,$D1,$18,$B2,$31
                DEFB      $01    ,$01    ,$A2,$4D
                DEFB      $01    ,$01    ,$92,$31
                DEFB      $01    ,$01    ,$82,$15
                DEFB  $16,$E1,$18,$E2,$31,$82,$31
                DEFB      $01    ,$01    ,$92,$4D
                DEFB      $01    ,$01    ,$A2,$31
                DEFB      $01    ,$01    ,$B2,$15
                DEFB      $F0,$8C,$F1,$18,$C2,$31
                DEFB      $01    ,$01    ,$D2,$4D
                DEFB      $01    ,$01    ,$E2,$31
                DEFB      $01    ,$01    ,$F2,$15
                DEFB  $FF  ; End of Pattern

PAT23:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$F2,$9B
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$D2,$9B
                DEFB      $01    ,$01    ,$C2,$9B
                DEFB      $E0,$8C,$E1,$18,$B2,$9B
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$92,$9B
                DEFB      $01    ,$01    ,$82,$9B
                DEFB  $16,$D1,$18,$D2,$31,$82,$9B
                DEFB      $01    ,$01    ,$92,$9B
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$B2,$9B
                DEFB      $C0,$8C,$C1,$18,$C2,$9B
                DEFB      $01    ,$01    ,$D2,$9B
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$F2,$9B
                DEFB  $07,$B0,$D2,$B1,$A4,$F2,$9B
                DEFB      $01    ,$01    ,$E2,$B7
                DEFB      $01    ,$01    ,$D2,$9B
                DEFB      $01    ,$01    ,$C2,$7F
                DEFB      $A0,$8C,$A1,$18,$B2,$9B
                DEFB      $01    ,$01    ,$A2,$B7
                DEFB      $01    ,$01    ,$92,$9B
                DEFB      $01    ,$01    ,$82,$7F
                DEFB  $16,$91,$18,$92,$31,$82,$9B
                DEFB      $01    ,$01    ,$92,$B7
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$B2,$7F
                DEFB      $80,$8C,$81,$18,$C2,$9B
                DEFB      $01    ,$01    ,$D2,$B7
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$F2,$7F
                DEFB  $06,$80,$8C,$81,$18,$F2,$9B
                DEFB      $01    ,$01    ,$E2,$B7
                DEFB      $01    ,$01    ,$D2,$9B
                DEFB      $01    ,$01    ,$C2,$7F
                DEFB      $90,$8C,$91,$18,$B2,$9B
                DEFB      $01    ,$01    ,$A2,$B7
                DEFB      $01    ,$01    ,$92,$9B
                DEFB      $01    ,$01    ,$82,$7F
                DEFB  $16,$A1,$18,$A2,$31,$82,$9C
                DEFB      $01    ,$01    ,$92,$B7
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$B2,$7F
                DEFB      $B0,$8C,$B1,$18,$C2,$9B
                DEFB      $01    ,$01    ,$D2,$B7
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$F2,$7F
                DEFB  $07,$C0,$D2,$C1,$A4,$F2,$9B
                DEFB      $01    ,$01    ,$E2,$B7
                DEFB      $01    ,$01    ,$D2,$9B
                DEFB      $01    ,$01    ,$C2,$7F
                DEFB      $D0,$8C,$D1,$18,$B2,$9B
                DEFB      $01    ,$01    ,$A2,$B7
                DEFB      $01    ,$01    ,$92,$9B
                DEFB      $01    ,$01    ,$82,$7F
                DEFB  $16,$E1,$18,$E2,$31,$82,$9B
                DEFB      $01    ,$01    ,$92,$B7
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$B2,$7F
                DEFB      $F0,$8C,$F1,$18,$C2,$9B
                DEFB      $01    ,$01    ,$D2,$B7
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$F2,$7F
                DEFB  $FF  ; End of Pattern

PAT24:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$F2,$ED
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$ED
                DEFB      $E0,$8C,$E1,$18,$B2,$ED
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$ED
                DEFB  $16,$D1,$18,$D2,$31,$82,$ED
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$ED
                DEFB      $C0,$8C,$C1,$18,$C2,$ED
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$ED
                DEFB  $07,$B0,$D2,$B1,$A4,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$09
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$D1
                DEFB      $A0,$8C,$A1,$18,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$09
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$D1
                DEFB  $16,$91,$18,$92,$31,$82,$ED
                DEFB      $01    ,$01    ,$93,$09
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$D1
                DEFB      $80,$8C,$81,$18,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$09
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$D1
                DEFB  $06,$80,$8C,$81,$18,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$09
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$D1
                DEFB      $90,$8C,$91,$18,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$09
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$D1
                DEFB  $16,$A1,$18,$A2,$31,$82,$EE
                DEFB      $01    ,$01    ,$93,$09
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$D1
                DEFB      $B0,$8C,$B1,$18,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$09
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$D1
                DEFB  $07,$C0,$D2,$C1,$A4,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$09
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$D1
                DEFB      $D0,$8C,$D1,$18,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$09
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$D1
                DEFB  $16,$E1,$18,$E2,$31,$82,$ED
                DEFB      $01    ,$01    ,$93,$09
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$D1
                DEFB      $F0,$8C,$F1,$18,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$09
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$D1
                DEFB  $FF  ; End of Pattern

PAT25:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$F3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$49
                DEFB      $E0,$8C,$E1,$18,$B3,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$83,$49
                DEFB  $16,$D1,$18,$D2,$31,$83,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $C0,$8C,$C1,$18,$C3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$49
                DEFB  $07,$B0,$D2,$B1,$A4,$F3,$49
                DEFB      $01    ,$01    ,$E3,$65
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$2D
                DEFB      $A0,$8C,$A1,$18,$B3,$49
                DEFB      $01    ,$01    ,$A3,$65
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$83,$2D
                DEFB  $16,$91,$18,$92,$31,$83,$49
                DEFB      $01    ,$01    ,$93,$65
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$2D
                DEFB      $80,$8C,$81,$18,$C3,$49
                DEFB      $01    ,$01    ,$D3,$65
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$2D
                DEFB  $06,$80,$8C,$81,$18,$F2,$ED
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$ED
                DEFB      $90,$8C,$91,$18,$B2,$ED
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$ED
                DEFB  $16,$A1,$18,$A2,$31,$82,$ED
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$ED
                DEFB      $B0,$8C,$B1,$18,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$09
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$D1
                DEFB  $07,$C0,$D2,$C1,$A4,$F3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$49
                DEFB      $D0,$8C,$D1,$18,$B3,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$83,$49
                DEFB  $16,$E1,$18,$E2,$31,$83,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $F0,$8C,$F1,$18,$C3,$49
                DEFB      $01    ,$01    ,$D3,$65
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$2D
                DEFB  $FF  ; End of Pattern

PAT26:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$76,$F0,$EC,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $E0,$76,$E0,$EC,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$B0
                DEFB  $16,$D0,$EC,$D1,$D8,$83,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$B0
                DEFB      $C0,$76,$C0,$EC,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB  $07,$B0,$B0,$B1,$61,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$D8
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$88
                DEFB      $A0,$76,$A0,$EC,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$D8
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$88
                DEFB  $16,$90,$8C,$91,$18,$83,$B0
                DEFB      $01    ,$01    ,$93,$D8
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$88
                DEFB      $80,$76,$80,$EC,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$D8
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$88
                DEFB  $06,$80,$76,$80,$EC,$F3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$49
                DEFB      $90,$76,$90,$EC,$B3,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$83,$49
                DEFB  $16,$A0,$EC,$A1,$D8,$83,$49
                DEFB      $01    ,$01    ,$93,$71
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$21
                DEFB      $B0,$76,$B0,$EC,$C3,$49
                DEFB      $01    ,$01    ,$D3,$71
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$21
                DEFB  $07,$C0,$B0,$C1,$61,$F3,$49
                DEFB      $01    ,$01    ,$E3,$71
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C3,$21
                DEFB      $D0,$76,$D0,$EC,$B3,$49
                DEFB      $01    ,$01    ,$A3,$71
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$83,$21
                DEFB  $16,$E0,$8C,$E1,$18,$83,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $F0,$76,$F0,$EC,$C3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$49
                DEFB  $FF  ; End of Pattern

PAT27:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$7D,$F0,$FA,$F2,$ED
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$ED
                DEFB      $E0,$7D,$E0,$FA,$B2,$ED
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$ED
                DEFB  $16,$D0,$FA,$D1,$F4,$82,$ED
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$ED
                DEFB      $C0,$7D,$C0,$FA,$C2,$ED
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$ED
                DEFB  $07,$B0,$BB,$B1,$76,$F2,$ED
                DEFB      $01    ,$01    ,$E3,$15
                DEFB      $01    ,$01    ,$D2,$ED
                DEFB      $01    ,$01    ,$C2,$C5
                DEFB      $A0,$7D,$A0,$FA,$B2,$ED
                DEFB      $01    ,$01    ,$A3,$15
                DEFB      $01    ,$01    ,$92,$ED
                DEFB      $01    ,$01    ,$82,$C5
                DEFB  $16,$90,$9D,$91,$3B,$82,$ED
                DEFB      $01    ,$01    ,$93,$15
                DEFB      $01    ,$01    ,$A2,$ED
                DEFB      $01    ,$01    ,$B2,$C5
                DEFB      $80,$7D,$80,$FA,$C2,$ED
                DEFB      $01    ,$01    ,$D3,$15
                DEFB      $01    ,$01    ,$E2,$ED
                DEFB      $01    ,$01    ,$F2,$C5
                DEFB  $06,$80,$7D,$80,$FA,$F3,$E8
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $90,$7D,$90,$FA,$B3,$E8
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$E8
                DEFB  $16,$A0,$FA,$A1,$F4,$83,$E8
                DEFB      $01    ,$01    ,$94,$10
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$C0
                DEFB      $B0,$7D,$B0,$FA,$C3,$E8
                DEFB      $01    ,$01    ,$D4,$10
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$C0
                DEFB  $07,$C0,$BB,$C1,$76,$F3,$E8
                DEFB      $01    ,$01    ,$E4,$10
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$C3,$C0
                DEFB      $D0,$7D,$D0,$FA,$B3,$E8
                DEFB      $01    ,$01    ,$A4,$10
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$C0
                DEFB  $16,$E0,$9D,$E1,$3B,$83,$E8
                DEFB      $01    ,$01    ,$94,$10
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$C0
                DEFB      $F0,$7D,$F0,$FA,$C3,$E8
                DEFB      $01    ,$01    ,$D4,$10
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$C0
                DEFB  $FF  ; End of Pattern

PAT28:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$5D,$F0,$BB,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $E0,$5D,$E0,$BB,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB  $16,$D0,$BB,$D1,$76,$84,$63
                DEFB      $01    ,$01    ,$94,$81
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$45
                DEFB      $C0,$5D,$C0,$BB,$C4,$63
                DEFB      $01    ,$01    ,$D4,$81
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$45
                DEFB  $07,$B0,$8C,$B1,$18,$F3,$E8
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $A0,$5D,$A0,$BB,$B3,$E8
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$E8
                DEFB  $16,$90,$76,$90,$EC,$83,$E8
                DEFB      $01    ,$01    ,$94,$06
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$CA
                DEFB      $80,$5D,$80,$BB,$C3,$E8
                DEFB      $01    ,$01    ,$D4,$06
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$CA
                DEFB  $06,$80,$5D,$80,$BB,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $90,$5D,$90,$BB,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$B0
                DEFB  $16,$A0,$BB,$A1,$76,$83,$B0
                DEFB      $01    ,$01    ,$93,$CE
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$92
                DEFB      $B0,$5D,$B0,$BB,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$CE
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$92
                DEFB  $07,$C0,$8C,$C1,$18,$F3,$E8
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $D0,$5D,$D0,$BB,$B3,$E8
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$E8
                DEFB  $16,$E0,$76,$E0,$EC,$83,$E8
                DEFB      $01    ,$01    ,$94,$06
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$CA
                DEFB      $F0,$5D,$F0,$BB,$C3,$E8
                DEFB      $01    ,$01    ,$D4,$06
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$CA
                DEFB  $FF  ; End of Pattern

PAT29:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$69,$F0,$D2,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $E0,$69,$E0,$D2,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB  $16,$D0,$D2,$D1,$A4,$84,$63
                DEFB      $01    ,$01    ,$94,$8B
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$3B
                DEFB      $C0,$69,$C0,$D2,$C4,$63
                DEFB      $01    ,$01    ,$D4,$8B
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$3B
                DEFB  $07,$B0,$9D,$B1,$3B,$F4,$63
                DEFB      $01    ,$01    ,$E4,$8B
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$3B
                DEFB      $A0,$69,$A0,$D2,$B4,$63
                DEFB      $01    ,$01    ,$A4,$8B
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$3B
                DEFB  $16,$90,$84,$91,$08,$84,$63
                DEFB      $01    ,$01    ,$94,$8B
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$3B
                DEFB      $80,$69,$80,$D2,$C4,$63
                DEFB      $01    ,$01    ,$D4,$8B
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$3B
                DEFB  $06,$80,$69,$80,$D2,$F4,$23
                DEFB      $01    ,$01    ,$E4,$23
                DEFB      $01    ,$01    ,$D4,$23
                DEFB      $01    ,$01    ,$C4,$23
                DEFB      $90,$69,$90,$D2,$B4,$23
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $01    ,$01    ,$94,$23
                DEFB      $01    ,$01    ,$84,$23
                DEFB  $16,$A0,$D2,$A1,$A4,$84,$23
                DEFB      $01    ,$01    ,$94,$4B
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $01    ,$01    ,$B3,$FB
                DEFB      $B0,$69,$B0,$D2,$C4,$23
                DEFB      $01    ,$01    ,$D4,$4B
                DEFB      $01    ,$01    ,$E4,$23
                DEFB      $01    ,$01    ,$F3,$FB
                DEFB  $07,$C0,$9D,$C1,$3B,$F4,$23
                DEFB      $01    ,$01    ,$E4,$4B
                DEFB      $01    ,$01    ,$D4,$23
                DEFB      $01    ,$01    ,$C3,$FB
                DEFB      $D0,$69,$D0,$D2,$B4,$23
                DEFB      $01    ,$01    ,$A4,$4B
                DEFB      $01    ,$01    ,$94,$23
                DEFB      $01    ,$01    ,$83,$FB
                DEFB  $05,$E0,$84,$E1,$08,$84,$23
                DEFB      $01    ,$01    ,$94,$4B
                DEFB      $01    ,$01    ,$A4,$23
                DEFB      $01    ,$01    ,$B3,$FB
                DEFB  $06,$F0,$69,$F0,$D2,$C4,$23
                DEFB      $01    ,$01    ,$D4,$4B
                DEFB      $01    ,$01    ,$E4,$23
                DEFB      $01    ,$01    ,$F3,$FB
                DEFB  $FF  ; End of Pattern

PAT31:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $E0,$8C,$E1,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$D1,$18,$D2,$31,$85,$4B
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$A5,$23
                DEFB      $01    ,$01    ,$B5,$37
                DEFB      $C0,$8C,$C1,$18,$C5,$4B
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$23
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $07,$B0,$D2,$B1,$A4,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $A0,$8C,$A1,$18,$B5,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$85,$DB
                DEFB  $16,$91,$18,$92,$31,$86,$92
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$B6,$92
                DEFB      $80,$8C,$81,$18,$C6,$92
                DEFB      $01    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$F6,$92
                DEFB  $06,$80,$8C,$81,$18,$F6,$BA
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$D6,$6A
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $90,$8C,$91,$18,$B6,$C4
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$96,$60
                DEFB      $01    ,$01    ,$86,$92
                DEFB  $16,$A1,$18,$A2,$31,$85,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$B5,$DB
                DEFB      $B0,$8C,$B1,$18,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB  $07,$C0,$D2,$C1,$A4,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $D0,$8C,$D1,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $15,$E1,$18,$E2,$31,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $F0,$8C,$F1,$18,$C4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT32:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$5D,$F0,$BB,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $E0,$5D,$E0,$BB,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$D0,$BB,$D1,$76,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $C0,$5D,$C0,$BB,$C5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $05,$B0,$8C,$B1,$18,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $A0,$5D,$A0,$BB,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB  $16,$90,$76,$90,$EC,$83,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $80,$5D,$80,$BB,$C3,$E8
                DEFB      $01    ,$01    ,$D3,$DA
                DEFB      $01    ,$01    ,$E3,$CC
                DEFB      $01    ,$01    ,$F3,$BE
                DEFB  $06,$80,$5D,$80,$BB,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $90,$5D,$90,$BB,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$B0
                DEFB  $16,$A0,$BB,$A1,$76,$83,$B0
                DEFB      $01    ,$01    ,$93,$C4
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$9C
                DEFB      $B0,$5D,$B0,$BB,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$C4
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$9C
                DEFB  $05,$C0,$8C,$C1,$18,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$D8
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C3,$88
                DEFB      $D0,$5D,$D0,$BB,$B3,$B0
                DEFB      $01    ,$01    ,$A3,$D8
                DEFB      $01    ,$01    ,$93,$B0
                DEFB      $01    ,$01    ,$83,$88
                DEFB  $07,$E0,$76,$E0,$EC,$83,$B0
                DEFB      $01    ,$01    ,$93,$D8
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B3,$88
                DEFB  $06,$F0,$5D,$F0,$BB,$C3,$B0
                DEFB      $01    ,$01    ,$D3,$D8
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F3,$88
                DEFB  $FF  ; End of Pattern

PAT33:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$8C,$F1,$18,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $E0,$8C,$E1,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$D1,$18,$D2,$31,$85,$4B
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$A5,$23
                DEFB      $01    ,$01    ,$B5,$37
                DEFB      $C0,$8C,$C1,$18,$C5,$55
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$19
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $05,$B0,$D2,$B1,$A4,$F5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $A0,$8C,$A1,$18,$B5,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$85,$DB
                DEFB  $16,$91,$18,$92,$31,$86,$92
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$B6,$92
                DEFB      $80,$8C,$81,$18,$C6,$92
                DEFB      $01    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$F6,$92
                DEFB  $06,$80,$8C,$81,$18,$F6,$BF
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$D6,$65
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $90,$8C,$91,$18,$B6,$C9
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$96,$5B
                DEFB      $01    ,$01    ,$86,$92
                DEFB  $16,$A1,$18,$A2,$31,$85,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$B5,$DB
                DEFB      $B0,$8C,$B1,$18,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB  $05,$C0,$D2,$C1,$A4,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $D0,$8C,$D1,$18,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$E1,$18,$E2,$31,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $F0,$8C,$F1,$18,$C4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT34:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$5D,$F0,$BB,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $E0,$5D,$E0,$BB,$B5,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$85,$DB
                DEFB  $16,$D0,$BB,$D1,$76,$87,$60
                DEFB      $01    ,$01    ,$97,$60
                DEFB      $01    ,$01    ,$A7,$60
                DEFB      $01    ,$01    ,$B7,$60
                DEFB      $C0,$5D,$C0,$BB,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB  $05,$B0,$8C,$B1,$18,$F7,$60
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $01    ,$01    ,$D7,$60
                DEFB      $01    ,$01    ,$C7,$60
                DEFB      $A0,$5D,$A0,$BB,$B7,$D0
                DEFB      $01    ,$01    ,$A7,$D0
                DEFB      $01    ,$01    ,$97,$D0
                DEFB      $01    ,$01    ,$87,$D0
                DEFB  $16,$90,$76,$90,$EC,$88,$C6
                DEFB      $01    ,$01    ,$98,$C6
                DEFB      $01    ,$01    ,$A8,$C6
                DEFB      $01    ,$01    ,$B8,$C6
                DEFB      $80,$5D,$80,$BB,$C8,$C6
                DEFB      $01    ,$01    ,$D8,$C6
                DEFB      $01    ,$01    ,$E8,$C6
                DEFB      $01    ,$01    ,$F9,$4B
                DEFB  $06,$80,$5D,$80,$BB,$F9,$D9
                DEFB      $01    ,$01    ,$EA,$6E
                DEFB      $01    ,$01    ,$DA,$6E
                DEFB      $01    ,$01    ,$CA,$6E
                DEFB      $90,$5D,$90,$BB,$BA,$6E
                DEFB      $01    ,$01    ,$AA,$6E
                DEFB      $01    ,$01    ,$9A,$6E
                DEFB      $01    ,$01    ,$8A,$6E
                DEFB  $16,$A0,$BB,$A1,$76,$8A,$6E
                DEFB      $01    ,$01    ,$9A,$AA
                DEFB      $01    ,$01    ,$AA,$6E
                DEFB      $01    ,$01    ,$BA,$32
                DEFB      $B0,$5D,$B0,$BB,$CA,$6E
                DEFB      $01    ,$01    ,$DA,$AA
                DEFB      $01    ,$01    ,$EA,$6E
                DEFB      $01    ,$01    ,$FA,$32
                DEFB  $05,$C0,$8C,$C1,$18,$FA,$6E
                DEFB      $01    ,$01    ,$EA,$B8
                DEFB      $01    ,$01    ,$DA,$6E
                DEFB      $01    ,$01    ,$CA,$24
                DEFB      $D0,$5D,$D0,$BB,$BA,$6E
                DEFB      $01    ,$01    ,$AA,$B8
                DEFB      $01    ,$01    ,$9A,$6E
                DEFB      $01    ,$01    ,$8A,$24
                DEFB  $16,$E0,$76,$E0,$EC,$8A,$6E
                DEFB      $01    ,$01    ,$9A,$24
                DEFB      $01    ,$01    ,$A9,$D9
                DEFB      $01    ,$01    ,$B9,$92
                DEFB  $06,$F0,$5D,$F0,$BB,$C9,$4B
                DEFB      $01    ,$01    ,$D9,$09
                DEFB      $01    ,$01    ,$E8,$C6
                DEFB      $01    ,$01    ,$F8,$87
                DEFB  $FF  ; End of Pattern

PAT41:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$FA,$83,$E8,$F4,$A5
                DEFB      $01    ,$01    ,$E4,$A5
                DEFB      $01    ,$01    ,$D4,$A5
                DEFB      $01    ,$01    ,$C4,$A5
                DEFB      $91,$29,$94,$A5,$B4,$A5
                DEFB      $01    ,$01    ,$A4,$A5
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $01    ,$01    ,$84,$A5
                DEFB  $16,$A1,$F4,$A3,$E8,$84,$A5
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $01    ,$01    ,$A4,$A5
                DEFB      $01    ,$01    ,$B4,$A5
                DEFB      $B1,$BD,$B3,$7B,$84,$B5
                DEFB      $01    ,$01    ,$94,$C5
                DEFB      $01    ,$01    ,$A4,$B5
                DEFB      $01    ,$01    ,$B4,$A5
                DEFB  $05,$C1,$29,$C2,$52,$C4,$B5
                DEFB      $01    ,$01    ,$D4,$C5
                DEFB      $01    ,$01    ,$E4,$B5
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB      $D1,$4D,$D2,$9B,$F4,$B5
                DEFB      $01    ,$01    ,$E4,$C5
                DEFB      $01    ,$01    ,$D4,$B5
                DEFB      $01    ,$01    ,$C4,$A5
                DEFB  $16,$E0,$FA,$E1,$F4,$B4,$B5
                DEFB      $01    ,$01    ,$A4,$C5
                DEFB      $01    ,$01    ,$94,$B5
                DEFB      $01    ,$01    ,$84,$A5
                DEFB      $F0,$DE,$F1,$BD,$84,$BA
                DEFB      $01    ,$01    ,$94,$C4
                DEFB      $01    ,$01    ,$A4,$BA
                DEFB      $01    ,$01    ,$B4,$A5
                DEFB  $06,$F0,$FA,$F1,$F4,$C4,$7D
                DEFB      $01    ,$01    ,$D4,$55
                DEFB      $01    ,$01    ,$E4,$41
                DEFB      $01    ,$01    ,$F4,$26
                DEFB      $E1,$29,$E2,$52,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB  $16,$D1,$F4,$D3,$E8,$A3,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $C1,$BD,$C3,$7B,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB  $05,$B1,$29,$B2,$52,$E4,$00
                DEFB      $01    ,$01    ,$F3,$E8
                DEFB      $01    ,$01    ,$E3,$D0
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $A1,$4D,$A2,$9B,$C4,$06
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $01    ,$01    ,$A3,$CA
                DEFB      $01    ,$01    ,$93,$E8
                DEFB  $16,$90,$FA,$91,$F4,$84,$A5
                DEFB      $01    ,$01    ,$94,$A5
                DEFB      $01    ,$01    ,$A4,$A5
                DEFB      $01    ,$01    ,$B4,$A5
                DEFB      $80,$DE,$81,$BD,$C4,$A5
                DEFB      $01    ,$01    ,$D4,$A5
                DEFB      $01    ,$01    ,$E4,$A5
                DEFB      $01    ,$01    ,$F4,$A5
                DEFB  $FF  ; End of Pattern

PAT42:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$6F,$80,$DE,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $90,$6F,$90,$DE,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB  $16,$A0,$DE,$A1,$BD,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $B0,$6F,$B0,$DE,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB  $05,$C0,$A6,$C1,$4D,$C5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB      $D0,$6F,$D0,$DE,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB  $16,$E0,$DE,$E1,$BD,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB      $F0,$6F,$F0,$DE,$85,$37
                DEFB      $01    ,$01    ,$95,$55
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$B5,$19
                DEFB  $06,$F0,$6F,$F0,$DE,$C5,$37
                DEFB      $01    ,$01    ,$D5,$55
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$19
                DEFB      $E0,$6F,$E0,$DE,$E5,$37
                DEFB      $01    ,$01    ,$D5,$55
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $01    ,$01    ,$B5,$19
                DEFB  $16,$D0,$DE,$D1,$BD,$A5,$37
                DEFB      $01    ,$01    ,$95,$55
                DEFB      $01    ,$01    ,$85,$37
                DEFB      $01    ,$01    ,$95,$19
                DEFB      $C0,$6F,$C0,$DE,$A5,$37
                DEFB      $01    ,$01    ,$B5,$55
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $01    ,$01    ,$D5,$19
                DEFB  $05,$B0,$A6,$B1,$4D,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $A0,$6F,$A0,$DE,$C4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB  $16,$90,$DE,$91,$BD,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $80,$6F,$80,$DE,$C4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT43:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$A6,$F1,$4D,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $E0,$A6,$E1,$4D,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$D1,$4D,$D2,$9B,$85,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$B5,$37
                DEFB      $C0,$A6,$C1,$4D,$C5,$37
                DEFB      $01    ,$01    ,$D5,$55
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$19
                DEFB  $05,$B0,$FA,$B1,$F4,$F5,$37
                DEFB      $01    ,$01    ,$E5,$55
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$19
                DEFB      $A0,$A6,$A1,$4D,$B5,$37
                DEFB      $01    ,$01    ,$A5,$55
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$95,$19
                DEFB  $16,$91,$4D,$92,$9B,$85,$37
                DEFB      $01    ,$01    ,$85,$55
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$A5,$19
                DEFB      $80,$A6,$81,$4D,$B5,$37
                DEFB      $01    ,$01    ,$C5,$55
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$19
                DEFB  $06,$80,$A6,$81,$4D,$F4,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $01    ,$01    ,$E4,$E7
                DEFB      $01    ,$01    ,$D4,$E7
                DEFB      $90,$A6,$91,$4D,$C4,$E7
                DEFB      $01    ,$01    ,$B4,$E7
                DEFB      $01    ,$01    ,$A4,$E7
                DEFB      $01    ,$01    ,$94,$E7
                DEFB  $16,$A1,$4D,$A2,$9B,$84,$E7
                DEFB      $01    ,$01    ,$94,$E7
                DEFB      $01    ,$01    ,$A4,$E7
                DEFB      $01    ,$01    ,$B4,$E7
                DEFB      $B0,$A6,$B1,$4D,$C4,$E7
                DEFB      $01    ,$01    ,$D4,$E7
                DEFB      $01    ,$01    ,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB  $05,$C0,$FA,$C1,$F4,$F5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $D0,$A6,$D1,$4D,$B5,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$85,$37
                DEFB  $16,$E1,$4D,$E2,$9B,$85,$37
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$B5,$37
                DEFB      $F0,$A6,$F1,$4D,$C5,$37
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $FF  ; End of Pattern

PAT44:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$F0,$5D,$F0,$BB,$F5,$37
                DEFB      $01    ,$01    ,$E5,$5E
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $01    ,$01    ,$C5,$B0
                DEFB      $E0,$5D,$E0,$BB,$B5,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$85,$DB
                DEFB  $16,$D0,$BB,$D1,$76,$85,$DB
                DEFB      $01    ,$01    ,$95,$DB
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$B5,$DB
                DEFB      $C0,$5D,$C0,$BB,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$DB
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$F5,$DB
                DEFB  $05,$B0,$8C,$B1,$18,$F5,$FE
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB      $01    ,$01    ,$D5,$B8
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $A0,$5D,$A0,$BB,$B5,$FE
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $01    ,$01    ,$95,$B8
                DEFB      $01    ,$01    ,$95,$DB
                DEFB  $16,$90,$BB,$91,$76,$85,$FE
                DEFB      $01    ,$01    ,$85,$DB
                DEFB      $01    ,$01    ,$95,$B8
                DEFB      $01    ,$01    ,$A5,$DB
                DEFB      $80,$5D,$80,$BB,$B5,$FE
                DEFB      $01    ,$01    ,$C5,$DB
                DEFB      $01    ,$01    ,$D5,$B8
                DEFB      $01    ,$01    ,$E5,$DB
                DEFB  $06,$80,$5D,$80,$BB,$F5,$DB
                DEFB      $01    ,$01    ,$F5,$B1
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $01    ,$01    ,$D5,$5E
                DEFB      $90,$5D,$90,$BB,$C5,$37
                DEFB      $01    ,$01    ,$B5,$0F
                DEFB      $01    ,$01    ,$A4,$E7
                DEFB      $01    ,$01    ,$94,$C6
                DEFB  $16,$A0,$BB,$A1,$76,$84,$A5
                DEFB      $01    ,$01    ,$94,$84
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$43
                DEFB      $B0,$5D,$B0,$BB,$C4,$23
                DEFB      $01    ,$01    ,$D4,$05
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$CC
                DEFB  $05,$C0,$8C,$C1,$18,$F3,$B0
                DEFB      $01    ,$01    ,$E3,$96
                DEFB      $01    ,$01    ,$D3,$7B
                DEFB      $01    ,$01    ,$C3,$62
                DEFB      $D0,$5D,$D0,$BB,$B3,$49
                DEFB      $01    ,$01    ,$A3,$32
                DEFB      $01    ,$01    ,$93,$1A
                DEFB      $01    ,$01    ,$83,$04
                DEFB  $05,$E0,$BB,$E1,$76,$82,$ED
                DEFB      $01    ,$01    ,$92,$D8
                DEFB      $01    ,$01    ,$A2,$C3
                DEFB      $01    ,$01    ,$B2,$AF
                DEFB  $08,$F0,$5D,$F0,$BB,$C2,$9B
                DEFB      $01    ,$01    ,$D2,$89
                DEFB      $01    ,$01    ,$E2,$76
                DEFB      $01    ,$01    ,$F2,$64
                DEFB  $FF  ; End of Pattern

PAT51:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$81,$18,$82,$31,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $91,$4D,$92,$9B,$B3,$E8
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$E8
                DEFB  $16,$A2,$31,$A2,$31,$83,$49
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $B1,$F4,$B1,$F4,$82,$FD
                DEFB      $01    ,$01    ,$93,$0D
                DEFB      $01    ,$01    ,$A2,$FD
                DEFB      $01    ,$01    ,$B2,$ED
                DEFB  $05,$C1,$4D,$C2,$9B,$C2,$AB
                DEFB      $01    ,$01    ,$D2,$BB
                DEFB      $01    ,$01    ,$E2,$AB
                DEFB      $01    ,$01    ,$F2,$9B
                DEFB      $D1,$76,$D2,$ED,$F5,$47
                DEFB      $01    ,$01    ,$E5,$57
                DEFB      $01    ,$01    ,$D5,$47
                DEFB      $01    ,$01    ,$C5,$37
                DEFB  $16,$E1,$18,$E2,$31,$B5,$47
                DEFB      $01    ,$01    ,$A5,$57
                DEFB      $01    ,$01    ,$95,$47
                DEFB      $01    ,$01    ,$85,$37
                DEFB      $F0,$FA,$F1,$F4,$85,$4C
                DEFB      $01    ,$01    ,$95,$56
                DEFB      $01    ,$01    ,$A5,$4C
                DEFB      $01    ,$01    ,$B5,$37
                DEFB  $06,$F1,$18,$F2,$31,$C5,$0F
                DEFB      $01    ,$01    ,$D4,$E7
                DEFB      $01    ,$01    ,$E4,$D3
                DEFB      $01    ,$01    ,$F4,$B8
                DEFB      $E1,$4D,$E2,$9B,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB  $16,$D2,$31,$D4,$63,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $C1,$F4,$C3,$E8,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB  $05,$B1,$4D,$B2,$9B,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$E8
                DEFB      $01    ,$01    ,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $A1,$76,$A2,$ED,$C4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB  $16,$91,$18,$92,$31,$83,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $80,$FA,$81,$F4,$C3,$49
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$E3,$49
                DEFB      $01    ,$01    ,$F3,$49
                DEFB  $FF  ; End of Pattern

PAT52:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$81,$18,$82,$31,$F4,$63
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $01    ,$01    ,$C4,$63
                DEFB      $91,$4D,$92,$9B,$B4,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$84,$63
                DEFB  $16,$A2,$31,$A2,$31,$84,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $B1,$F4,$B1,$F4,$84,$73
                DEFB      $01    ,$01    ,$94,$83
                DEFB      $01    ,$01    ,$A4,$73
                DEFB      $01    ,$01    ,$B4,$63
                DEFB  $05,$C1,$4D,$C2,$9B,$C4,$73
                DEFB      $01    ,$01    ,$D4,$83
                DEFB      $01    ,$01    ,$E4,$73
                DEFB      $01    ,$01    ,$F4,$63
                DEFB      $D1,$76,$D2,$ED,$F4,$73
                DEFB      $01    ,$01    ,$E4,$83
                DEFB      $01    ,$01    ,$D4,$73
                DEFB      $01    ,$01    ,$C4,$63
                DEFB  $16,$E1,$18,$E2,$31,$B4,$73
                DEFB      $01    ,$01    ,$A4,$83
                DEFB      $01    ,$01    ,$94,$73
                DEFB      $01    ,$01    ,$84,$63
                DEFB      $F0,$FA,$F1,$F4,$84,$78
                DEFB      $01    ,$01    ,$94,$82
                DEFB      $01    ,$01    ,$A4,$78
                DEFB      $01    ,$01    ,$B4,$63
                DEFB  $06,$F1,$18,$F2,$31,$C4,$3B
                DEFB      $01    ,$01    ,$D4,$13
                DEFB      $01    ,$01    ,$E3,$FF
                DEFB      $01    ,$01    ,$F3,$E4
                DEFB      $E1,$4D,$E2,$9B,$E3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB  $16,$D2,$31,$D4,$63,$A3,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$83,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $C1,$F4,$C3,$E8,$A3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $01    ,$01    ,$C3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB  $05,$B1,$4D,$B2,$9B,$E3,$E8
                DEFB      $01    ,$01    ,$F3,$E8
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $A1,$76,$A2,$ED,$C3,$E8
                DEFB      $01    ,$01    ,$B3,$E8
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$94,$63
                DEFB  $16,$91,$18,$92,$31,$83,$E8
                DEFB      $01    ,$01    ,$93,$E8
                DEFB      $01    ,$01    ,$A4,$63
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $80,$FA,$81,$F4,$C3,$E8
                DEFB      $01    ,$01    ,$D3,$E8
                DEFB      $01    ,$01    ,$E4,$63
                DEFB      $01    ,$01    ,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT54:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$90,$D2,$F1,$A4,$F3,$49
                DEFB      $01    ,$E1,$A4,$01
                DEFB      $01    ,$D1,$A4,$E3,$E8
                DEFB      $01    ,$C1,$A4,$01
                DEFB      $01    ,$B1,$A4,$D3,$49
                DEFB      $01    ,$A1,$A4,$01
                DEFB      $01    ,$91,$A4,$C3,$E8
                DEFB      $01    ,$81,$A4,$01
                DEFB  $03,$01    ,$01    ,$B3,$49
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A3,$E8
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$C6,$F1,$8D,$F3,$1A
                DEFB      $01    ,$E1,$8D,$01
                DEFB      $01    ,$D1,$8D,$E3,$49
                DEFB      $01    ,$C1,$8D,$01
                DEFB      $01    ,$B1,$8D,$D3,$1A
                DEFB      $01    ,$A1,$8D,$01
                DEFB      $01    ,$91,$8D,$C3,$49
                DEFB      $01    ,$81,$8D,$01
                DEFB  $08,$01    ,$01    ,$B3,$1A
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$BB,$F1,$76,$F2,$ED
                DEFB      $01    ,$E1,$76,$01
                DEFB      $01    ,$D1,$76,$E3,$1A
                DEFB      $01    ,$C1,$76,$01
                DEFB      $01    ,$B1,$76,$D2,$ED
                DEFB      $01    ,$A1,$76,$01
                DEFB      $01    ,$91,$76,$C3,$1A
                DEFB      $01    ,$81,$76,$01
                DEFB  $06,$01    ,$01    ,$B2,$ED
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A3,$1A
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$A6,$F1,$4D,$F2,$9B
                DEFB      $01    ,$E1,$4D,$01
                DEFB      $01    ,$D1,$4D,$E2,$9B
                DEFB      $01    ,$C1,$4D,$01
                DEFB      $01    ,$B1,$4D,$D2,$9B
                DEFB      $01    ,$A1,$4D,$01
                DEFB      $01    ,$91,$4D,$C2,$9B
                DEFB      $01    ,$81,$4D,$01
                DEFB  $06,$01    ,$01    ,$B2,$9B
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$7D,$F0,$FA,$F1,$F4
                DEFB      $01    ,$E0,$FA,$E1,$F4
                DEFB      $01    ,$D0,$FA,$D1,$F4
                DEFB      $01    ,$C0,$FA,$C1,$F4
                DEFB      $01    ,$B0,$FA,$B1,$F4
                DEFB      $01    ,$A0,$FA,$A1,$F4
                DEFB      $01    ,$90,$FA,$91,$F4
                DEFB      $01    ,$80,$FA,$81,$F4
                DEFB  $05,$90,$84,$F1,$08,$F2,$11
                DEFB      $01    ,$E1,$08,$E2,$11
                DEFB      $01    ,$D1,$08,$D2,$11
                DEFB      $01    ,$C1,$08,$C2,$11
                DEFB  $08,$01    ,$B1,$08,$B2,$11
                DEFB      $01    ,$A1,$08,$A2,$11
                DEFB      $01    ,$91,$08,$92,$11
                DEFB      $01    ,$81,$08,$82,$11
                DEFB  $FF  ; End of Pattern

PAT125:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$83,$B0,$F0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$D0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $91,$18,$94,$63,$B0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$90,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $A1,$D8,$A3,$B0,$80,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $B1,$A4,$B3,$49,$80,$69
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$69
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$C1,$18,$C2,$31,$C0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$E0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $D1,$3B,$D2,$76,$F0,$9D
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$D0,$9D
                DEFB      $01    ,$01    ,$01
                DEFB      $E0,$EC,$E1,$D8,$B0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$90,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $F0,$D2,$F1,$A4,$80,$69
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$69
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$F0,$EC,$F1,$D8,$C0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$E0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $E1,$18,$E2,$31,$E0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$C0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $D1,$D8,$D3,$B0,$A0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$80,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $C1,$A4,$C3,$49,$A0,$69
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$C0,$69
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$B1,$18,$B2,$31,$E0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$E0,$8C
                DEFB      $01    ,$01    ,$01
                DEFB      $A0,$76,$A2,$76,$C0,$9D
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$9D
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$90,$EC,$91,$D8,$80,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$76
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$80,$D2,$81,$A4,$C0,$69
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$E0,$69
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT126:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$B2,$31,$F1,$D8
                DEFB      $01    ,$01    ,$E2,$31
                DEFB      $01    ,$01    ,$D1,$D8
                DEFB      $01    ,$01    ,$C2,$31
                DEFB      $91,$18,$B2,$C3,$B0,$76
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $A1,$D8,$B4,$63,$83,$B0
                DEFB      $01    ,$01    ,$94,$63
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $B1,$A4,$B4,$23,$80,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$C1,$18,$B2,$31,$C0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$E0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $D1,$3B,$B3,$49,$F0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$D0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $E0,$EC,$B3,$B0,$B0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$90,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $F0,$D2,$B3,$49,$80,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$F0,$EC,$B2,$31,$C3,$B0
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F5,$86
                DEFB      $E1,$18,$B2,$C3,$E0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$C0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $D1,$D8,$B2,$31,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$80,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $C1,$A4,$B1,$A4,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$C0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$B1,$18,$B2,$31,$A3,$B0
                DEFB      $01    ,$01    ,$B4,$63
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $01    ,$01    ,$D4,$63
                DEFB      $A0,$76,$B2,$76,$C0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$90,$EC,$B1,$D8,$80,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$A0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$80,$D2,$B1,$A4,$C0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$E0,$EC
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

