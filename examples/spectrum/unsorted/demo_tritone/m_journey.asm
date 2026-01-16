
SECTION JOURNEY
org 55000

; *** Song layout ***
LOOPSTART:            DEFW      PAT0
                      DEFW      PAT1
                      DEFW      PAT1
                      DEFW      PAT1
                      DEFW      PAT2
                      DEFW      PAT11
                      DEFW      PAT12
                      DEFW      PAT13
                      DEFW      PAT13
                      DEFW      PAT11
                      DEFW      PAT12
                      DEFW      PAT14
                      DEFW      PAT15
                      DEFW      PAT22
                      DEFW      PAT22
                      DEFW      PAT23
                      DEFW      PAT23
                      DEFW      PAT22
                      DEFW      PAT22
                      DEFW      PAT24
                      DEFW      PAT25
                      DEFW      PAT31
                      DEFW      PAT31
                      DEFW      PAT33
                      DEFW      PAT33
                      DEFW      PAT35
                      DEFW      PAT35
                      DEFW      PAT36
                      DEFW      PAT36
                      DEFW      PAT37
                      DEFW      PAT37
                      DEFW      PAT38
                      DEFW      PAT38
                      DEFW      PAT41
                      DEFW      PAT42
                      DEFW      PAT43
                      DEFW      PAT44
                      DEFW      PAT45
                      DEFW      PAT46
                      DEFW      $0000
                      DEFW      LOOPSTART

; *** Patterns ***
PAT0:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$81,$3B,$82,$77,$84,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $91,$76,$93,$B0,$97,$60
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $A1,$3B,$A2,$76,$A4,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $B1,$D8,$B2,$ED,$B7,$60
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $C1,$3B,$C2,$76,$C4,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $D1,$76,$D3,$B0,$D7,$60
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $E1,$3B,$E2,$76,$E4,$E7
                DEFB      $01    ,$01    ,$F4,$E7
                DEFB      $F1,$D8,$F2,$ED,$F7,$60
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$F1,$3B,$F4,$63,$F4,$E7
                DEFB      $01    ,$01    ,$01
                DEFB      $E1,$76,$E3,$B0,$E7,$60
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$D1,$3B,$D4,$63,$D9,$D9
                DEFB      $01    ,$01    ,$01
                DEFB      $C1,$D8,$C3,$B0,$C7,$60
                DEFB      $01    ,$01    ,$01
                DEFB  $06,$B1,$3B,$B4,$63,$B9,$D9
                DEFB      $01    ,$01    ,$01
                DEFB      $A1,$76,$A3,$B0,$A7,$60
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$91,$3B,$94,$63,$99,$D9
                DEFB      $01    ,$01    ,$01
                DEFB  $08,$81,$D8,$83,$B0,$87,$60
                DEFB  $09,$01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT1:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3C,$F1,$3B,$80,$9D
                DEFB      $91,$76,$F1,$3B,$01
                DEFB      $92,$76,$E1,$3B,$01
                DEFB      $91,$3C,$D1,$3B,$01
                DEFB  $04,$91,$76,$C1,$3B,$01
                DEFB      $92,$31,$B1,$3B,$01
                DEFB      $91,$3C,$A1,$3B,$01
                DEFB      $91,$76,$91,$3B,$01
                DEFB  $06,$91,$F4,$81,$3B,$01
                DEFB      $91,$3C,$91,$3B,$01
                DEFB      $91,$76,$A1,$3B,$01
                DEFB      $91,$D8,$B1,$3B,$01
                DEFB  $04,$91,$3C,$C1,$3B,$01
                DEFB      $91,$76,$D1,$3B,$01
                DEFB  $09,$91,$D8,$E1,$3B,$01
                DEFB  $08,$91,$76,$F1,$3B,$01
                DEFB  $FF  ; End of Pattern

PAT2:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3C,$81,$3B,$F0,$9D
                DEFB      $91,$77,$81,$3B,$01
                DEFB      $92,$76,$81,$3B,$01
                DEFB      $91,$3C,$81,$3B,$01
                DEFB  $04,$91,$77,$81,$3B,$F0,$A6
                DEFB      $92,$31,$81,$3B,$F0,$B0
                DEFB      $91,$3C,$81,$3B,$F0,$BB
                DEFB      $91,$77,$81,$3B,$F0,$C6
                DEFB  $06,$91,$F4,$81,$3B,$F0,$D2
                DEFB      $91,$3C,$91,$3B,$F0,$DE
                DEFB  $09,$91,$77,$91,$3B,$F0,$EC
                DEFB      $91,$D8,$91,$3B,$F0,$FA
                DEFB  $04,$91,$3C,$91,$3B,$F1,$08
                DEFB      $91,$77,$91,$3B,$F1,$18
                DEFB  $07,$91,$D9,$91,$3B,$F1,$29
                DEFB  $08,$91,$76,$91,$3B,$F1,$3B
                DEFB  $FF  ; End of Pattern

PAT11:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3B,$F2,$76,$F1,$3C
                DEFB      $91,$76,$F1,$3B,$F1,$3C
                DEFB      $92,$76,$E1,$3B,$E1,$3C
                DEFB      $91,$3B,$D1,$3B,$D1,$3C
                DEFB  $04,$91,$76,$C1,$3B,$C1,$3C
                DEFB      $92,$31,$B0,$9D,$B1,$3B
                DEFB      $91,$3B,$A0,$9D,$A1,$3C
                DEFB      $91,$76,$90,$9D,$91,$3B
                DEFB  $06,$91,$F4,$80,$9D,$81,$3B
                DEFB      $91,$3B,$90,$9D,$91,$3C
                DEFB  $08,$91,$76,$A0,$9D,$A1,$3B
                DEFB      $91,$D8,$B0,$9D,$B1,$3B
                DEFB  $04,$91,$3B,$C2,$C3,$F1,$61
                DEFB      $91,$76,$D0,$9D,$E1,$61
                DEFB  $05,$91,$D8,$E0,$9D,$D1,$61
                DEFB  $0E,$91,$76,$F0,$9D,$C1,$61
                DEFB  $FF  ; End of Pattern

PAT12:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3B,$F2,$76,$F1,$76
                DEFB      $91,$76,$F0,$9D,$F1,$77
                DEFB  $06,$92,$76,$E0,$9D,$E1,$76
                DEFB      $91,$3B,$D0,$9D,$D1,$76
                DEFB  $04,$91,$76,$C0,$9D,$C1,$77
                DEFB      $92,$31,$B0,$9D,$B1,$76
                DEFB      $91,$3B,$A0,$9D,$A1,$76
                DEFB  $0E,$91,$76,$90,$9D,$91,$77
                DEFB  $06,$91,$F4,$80,$9D,$81,$76
                DEFB      $91,$3B,$90,$9D,$91,$76
                DEFB  $06,$91,$76,$A0,$9D,$A1,$77
                DEFB      $91,$D8,$B0,$9D,$B1,$76
                DEFB  $04,$91,$3B,$C2,$76,$F1,$A4
                DEFB      $91,$76,$D1,$3B,$E1,$A4
                DEFB  $07,$91,$D8,$E1,$3B,$D1,$A4
                DEFB  $08,$91,$76,$F1,$3B,$C1,$A4
                DEFB  $FF  ; End of Pattern

PAT13:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$90,$EC,$F3,$B0,$F2,$C3
                DEFB      $91,$18,$F0,$EC,$F1,$61
                DEFB      $91,$D8,$E1,$D7,$E1,$61
                DEFB      $90,$EC,$D0,$EB,$D1,$61
                DEFB  $04,$91,$18,$C0,$EC,$C2,$C3
                DEFB      $91,$A4,$B0,$EC,$B1,$61
                DEFB      $90,$EC,$A0,$EB,$A1,$61
                DEFB  $0E,$91,$18,$90,$EC,$91,$61
                DEFB  $06,$91,$76,$81,$D8,$81,$61
                DEFB      $90,$EC,$90,$EB,$91,$61
                DEFB  $09,$91,$18,$A0,$EC,$A1,$61
                DEFB      $91,$61,$B0,$EC,$B1,$60
                DEFB  $04,$90,$EC,$C3,$B0,$C1,$61
                DEFB      $91,$18,$D0,$EC,$D1,$61
                DEFB  $07,$91,$61,$E1,$D8,$E1,$60
                DEFB  $09,$91,$18,$F0,$EC,$F1,$61
                DEFB  $FF  ; End of Pattern

PAT14:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$90,$EC,$F3,$B0,$F2,$31
                DEFB      $91,$18,$F0,$EC,$F2,$31
                DEFB      $91,$D8,$E1,$D9,$E2,$31
                DEFB      $90,$EC,$D0,$ED,$D2,$31
                DEFB  $04,$91,$18,$C0,$EC,$C2,$31
                DEFB      $91,$A4,$B0,$EC,$B2,$31
                DEFB      $90,$EC,$A0,$ED,$A2,$31
                DEFB  $0E,$91,$18,$90,$EC,$92,$31
                DEFB  $06,$91,$76,$83,$B0,$F2,$76
                DEFB      $90,$EC,$90,$ED,$E2,$76
                DEFB  $09,$91,$18,$A0,$EC,$D2,$76
                DEFB      $91,$61,$B0,$EC,$C2,$76
                DEFB  $04,$90,$EC,$C3,$B0,$B2,$76
                DEFB      $91,$18,$D0,$EC,$A2,$76
                DEFB  $07,$91,$61,$E3,$B0,$92,$76
                DEFB  $08,$91,$18,$F0,$EC,$82,$76
                DEFB  $FF  ; End of Pattern

PAT15:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$90,$EC,$F3,$B0,$F2,$C3
                DEFB      $91,$18,$F0,$EC,$F2,$C3
                DEFB      $91,$D8,$E1,$D9,$E2,$C3
                DEFB      $90,$EC,$D0,$ED,$D2,$C3
                DEFB  $04,$91,$18,$C0,$EC,$C2,$C3
                DEFB      $91,$A4,$B0,$EC,$B2,$C3
                DEFB      $90,$EC,$A0,$ED,$A2,$C3
                DEFB  $0E,$91,$18,$90,$EC,$92,$C3
                DEFB  $06,$91,$76,$83,$B0,$82,$C3
                DEFB      $90,$EC,$90,$ED,$92,$C3
                DEFB  $09,$91,$18,$A0,$EC,$A2,$C3
                DEFB      $91,$61,$B0,$EC,$B2,$C3
                DEFB  $04,$90,$EC,$C3,$B0,$C2,$C3
                DEFB      $91,$18,$D0,$EC,$D2,$C3
                DEFB  $09,$91,$61,$E3,$B0,$E2,$C3
                DEFB      $91,$18,$F0,$EC,$F2,$C3
                DEFB  $FF  ; End of Pattern

PAT22:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3B,$F3,$B0,$F2,$76
                DEFB      $90,$9D,$F1,$3B,$F2,$31
                DEFB      $90,$9D,$E1,$3B,$E2,$76
                DEFB      $90,$9D,$D1,$3B,$D2,$31
                DEFB  $04,$91,$3B,$C3,$B0,$C2,$76
                DEFB      $90,$9D,$B1,$3B,$B1,$3C
                DEFB      $90,$9D,$A1,$3B,$A2,$76
                DEFB      $90,$9D,$91,$3B,$92,$31
                DEFB  $06,$91,$3B,$83,$B0,$82,$76
                DEFB      $90,$9D,$91,$3B,$91,$3C
                DEFB      $90,$9D,$A1,$3B,$A2,$76
                DEFB      $90,$9D,$B1,$3B,$B1,$3C
                DEFB  $04,$91,$3B,$C3,$B0,$C2,$ED
                DEFB      $90,$9D,$D1,$3B,$D1,$3B
                DEFB  $09,$90,$9D,$E3,$B0,$E2,$76
                DEFB      $90,$9D,$F1,$3B,$F1,$3C
                DEFB  $FF  ; End of Pattern

PAT23:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$D8,$F3,$B0,$F2,$C3
                DEFB      $80,$ED,$F0,$EC,$F2,$76
                DEFB      $80,$EC,$E3,$B0,$E2,$C3
                DEFB      $80,$ED,$D0,$EC,$D1,$61
                DEFB  $04,$81,$D8,$C0,$EC,$C2,$C3
                DEFB      $80,$ED,$B0,$EC,$B1,$61
                DEFB      $80,$ED,$A0,$EC,$A2,$C3
                DEFB  $0E,$80,$ED,$90,$EC,$92,$76
                DEFB  $06,$81,$D8,$83,$B0,$82,$C3
                DEFB      $80,$ED,$90,$EC,$91,$61
                DEFB  $09,$80,$ED,$A0,$EC,$A2,$C3
                DEFB      $80,$ED,$B0,$EC,$B1,$61
                DEFB  $04,$81,$D8,$C3,$49,$C2,$76
                DEFB      $80,$ED,$D0,$EC,$D1,$61
                DEFB  $07,$80,$EC,$E3,$B0,$E2,$C3
                DEFB  $09,$80,$ED,$F0,$EC,$F1,$61
                DEFB  $FF  ; End of Pattern

PAT24:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$D8,$F3,$B0,$F2,$31
                DEFB      $90,$EC,$F0,$ED,$F2,$31
                DEFB      $90,$EC,$E3,$B0,$E2,$31
                DEFB      $90,$EC,$D0,$ED,$D2,$31
                DEFB  $04,$91,$D8,$C0,$EC,$C2,$31
                DEFB      $90,$EC,$B0,$ED,$B2,$31
                DEFB      $90,$EC,$A0,$ED,$A2,$31
                DEFB  $0E,$90,$EC,$90,$ED,$92,$31
                DEFB  $06,$91,$D8,$83,$B0,$F2,$76
                DEFB      $90,$EC,$90,$ED,$E2,$76
                DEFB  $09,$90,$EC,$A0,$ED,$D2,$76
                DEFB      $90,$EC,$B0,$ED,$C2,$76
                DEFB  $04,$91,$D8,$C3,$B0,$B2,$76
                DEFB      $90,$EC,$D0,$ED,$A2,$76
                DEFB  $07,$90,$EC,$E3,$B0,$92,$76
                DEFB  $08,$90,$EC,$F0,$ED,$82,$76
                DEFB  $FF  ; End of Pattern

PAT25:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$D8,$F3,$B0,$F2,$C3
                DEFB      $90,$EC,$F0,$ED,$F2,$C3
                DEFB      $90,$EC,$E1,$D8,$E2,$C3
                DEFB      $90,$EC,$D0,$ED,$D2,$C3
                DEFB  $04,$91,$D8,$C0,$EC,$C2,$C3
                DEFB      $90,$EC,$B0,$ED,$B2,$C3
                DEFB      $90,$EC,$A0,$ED,$A2,$C3
                DEFB  $0E,$90,$EC,$90,$ED,$92,$C3
                DEFB  $06,$91,$D8,$83,$B0,$F3,$49
                DEFB      $90,$EC,$90,$ED,$F3,$49
                DEFB  $09,$91,$D8,$A0,$EC,$E3,$49
                DEFB      $90,$EC,$B0,$ED,$D3,$49
                DEFB  $04,$91,$D8,$C3,$B0,$C3,$B1
                DEFB      $90,$EC,$D0,$ED,$B3,$B0
                DEFB  $09,$91,$D8,$E3,$B0,$A3,$B1
                DEFB      $90,$EC,$F0,$ED,$93,$B0
                DEFB  $FF  ; End of Pattern

PAT31:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$92,$76,$B1,$3B,$F7,$60
                DEFB      $91,$3B,$B4,$E7,$F5,$DB
                DEFB      $91,$3B,$B3,$B0,$E4,$E7
                DEFB      $91,$3B,$B0,$9D,$D2,$76
                DEFB  $04,$92,$76,$B1,$3B,$C4,$E7
                DEFB      $91,$3B,$B0,$9D,$B2,$76
                DEFB      $91,$3B,$B2,$ED,$A4,$63
                DEFB      $91,$3B,$B0,$9D,$00
                DEFB  $06,$92,$76,$81,$3C,$84,$E7
                DEFB      $91,$3B,$01    ,$94,$63
                DEFB      $91,$3B,$B2,$76,$A4,$E7
                DEFB      $91,$3B,$B0,$9D,$00
                DEFB  $04,$92,$76,$D1,$3C,$C5,$DB
                DEFB      $91,$3B,$01    ,$00
                DEFB  $09,$91,$3B,$F2,$76,$E4,$E7
                DEFB      $91,$3B,$F0,$9D,$00
                DEFB  $FF  ; End of Pattern

PAT33:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$D8,$F3,$B0,$F5,$86
                DEFB      $80,$EC,$F0,$ED,$F4,$E7
                DEFB      $81,$D8,$E3,$B0,$E4,$63
                DEFB      $80,$EC,$D0,$ED,$D1,$61
                DEFB  $04,$81,$D8,$C0,$EC,$C3,$B0
                DEFB      $80,$EC,$B0,$ED,$B1,$61
                DEFB      $81,$D8,$A0,$EC,$A2,$C3
                DEFB  $0E,$80,$EC,$90,$ED,$92,$76
                DEFB  $06,$81,$D8,$83,$B0,$82,$C3
                DEFB      $80,$EC,$90,$ED,$91,$61
                DEFB  $09,$80,$EC,$A0,$ED,$A2,$C3
                DEFB      $80,$EC,$B0,$ED,$B1,$60
                DEFB  $04,$81,$D8,$C3,$B0,$C4,$63
                DEFB      $80,$EC,$D0,$ED,$D1,$61
                DEFB  $07,$80,$EC,$E3,$B0,$E4,$E6
                DEFB  $09,$80,$EC,$F0,$ED,$F1,$61
                DEFB  $FF  ; End of Pattern

PAT35:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$92,$32,$B1,$18,$F4,$63
                DEFB      $91,$18,$B4,$63,$F4,$63
                DEFB      $91,$18,$B3,$49,$E4,$63
                DEFB      $91,$18,$B0,$8C,$D4,$63
                DEFB  $04,$92,$32,$B1,$18,$C4,$63
                DEFB      $91,$18,$B0,$8C,$B4,$63
                DEFB      $90,$FA,$B1,$F4,$A4,$63
                DEFB      $91,$18,$B0,$8C,$94,$63
                DEFB  $06,$92,$32,$81,$19,$84,$63
                DEFB      $91,$18,$01    ,$94,$63
                DEFB      $91,$18,$B2,$31,$A4,$63
                DEFB      $91,$18,$B0,$8C,$B4,$63
                DEFB  $04,$92,$32,$D1,$19,$C4,$63
                DEFB      $91,$18,$01    ,$D4,$63
                DEFB  $09,$91,$18,$F2,$31,$E4,$63
                DEFB      $91,$18,$F0,$8C,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT36:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$A4,$B0,$D2,$F4,$23
                DEFB      $90,$D2,$B3,$49,$F4,$23
                DEFB      $90,$D2,$B2,$76,$E4,$23
                DEFB      $90,$D2,$B0,$69,$D4,$23
                DEFB  $04,$91,$A4,$B0,$D2,$C4,$23
                DEFB      $90,$D2,$B0,$69,$B4,$23
                DEFB      $90,$BB,$B1,$76,$A4,$23
                DEFB      $90,$D2,$B0,$69,$94,$23
                DEFB  $06,$91,$A4,$80,$D3,$84,$23
                DEFB      $90,$D2,$01    ,$94,$23
                DEFB      $90,$D2,$B1,$A4,$A4,$23
                DEFB      $90,$D2,$B0,$69,$B4,$23
                DEFB  $04,$91,$A4,$D0,$D3,$C4,$23
                DEFB      $90,$D2,$01    ,$D4,$23
                DEFB  $09,$90,$D2,$F1,$A4,$E4,$23
                DEFB      $90,$D2,$F0,$69,$F4,$23
                DEFB  $FF  ; End of Pattern

PAT37:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$F4,$B0,$FA,$F3,$E8
                DEFB      $90,$FA,$B3,$E8,$F3,$E8
                DEFB      $90,$FA,$B2,$ED,$E3,$E8
                DEFB      $90,$FA,$B0,$7D,$D3,$E8
                DEFB  $04,$91,$F4,$B0,$FA,$C3,$E8
                DEFB      $90,$FA,$B0,$7D,$B3,$E8
                DEFB      $90,$EC,$B1,$D8,$A3,$E8
                DEFB      $90,$FA,$B0,$7D,$93,$E8
                DEFB  $06,$91,$F4,$80,$FB,$83,$E8
                DEFB      $90,$FA,$01    ,$93,$E8
                DEFB      $90,$FA,$B1,$F4,$A3,$E8
                DEFB      $90,$FA,$B0,$7D,$B3,$E8
                DEFB  $04,$91,$F4,$D0,$FB,$C3,$E8
                DEFB      $90,$FA,$01    ,$D3,$E8
                DEFB  $09,$90,$FA,$F1,$F4,$E3,$E8
                DEFB      $90,$FA,$F0,$7D,$F3,$E8
                DEFB  $FF  ; End of Pattern

PAT38:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$76,$B0,$BB,$F3,$B0
                DEFB      $90,$BB,$B2,$ED,$F3,$B0
                DEFB      $90,$BB,$B2,$31,$E3,$B0
                DEFB      $90,$BB,$B0,$5D,$D3,$B0
                DEFB  $04,$91,$76,$B0,$BB,$C3,$B0
                DEFB      $90,$BB,$B0,$5D,$B3,$B0
                DEFB      $91,$61,$B1,$61,$A3,$B0
                DEFB      $90,$BB,$B0,$5D,$93,$B0
                DEFB  $06,$91,$76,$80,$BC,$83,$B0
                DEFB      $90,$BB,$01    ,$93,$B0
                DEFB      $90,$BB,$B1,$76,$A3,$B0
                DEFB      $90,$BB,$B0,$5D,$B3,$B0
                DEFB  $04,$91,$76,$D0,$BC,$C3,$B0
                DEFB      $90,$BB,$01    ,$D3,$B0
                DEFB  $09,$90,$BB,$F1,$76,$E3,$B0
                DEFB      $90,$BB,$F0,$5D,$F3,$B0
                DEFB  $FF  ; End of Pattern

PAT41:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3B,$F1,$3C,$F4,$E7
                DEFB      $91,$76,$F1,$3B,$F2,$76
                DEFB      $92,$76,$E1,$3B,$E5,$86
                DEFB      $91,$3B,$D1,$3C,$D2,$76
                DEFB  $04,$91,$76,$C1,$3B,$C5,$DB
                DEFB      $92,$31,$B1,$3B,$B2,$76
                DEFB      $91,$3B,$A1,$3C,$A4,$E7
                DEFB  $0E,$91,$76,$91,$3B,$92,$76
                DEFB  $06,$91,$F4,$81,$3B,$85,$86
                DEFB      $91,$3B,$91,$3C,$92,$76
                DEFB      $91,$76,$A1,$3B,$A5,$DB
                DEFB      $91,$D8,$B1,$3B,$B2,$76
                DEFB  $04,$91,$3B,$C1,$3C,$C6,$92
                DEFB      $91,$76,$D1,$3B,$D2,$76
                DEFB  $09,$91,$D8,$E1,$3B,$E5,$86
                DEFB      $91,$76,$F1,$3B,$F2,$76
                DEFB  $FF  ; End of Pattern

PAT42:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3C,$F1,$3B,$F5,$DB
                DEFB      $91,$76,$F1,$3B,$F2,$76
                DEFB      $92,$76,$E1,$3B,$E6,$92
                DEFB      $91,$3C,$D1,$3B,$D2,$76
                DEFB  $04,$91,$76,$C1,$3B,$C7,$60
                DEFB      $92,$31,$B1,$3B,$B2,$76
                DEFB      $91,$3C,$A1,$3B,$A5,$DB
                DEFB  $0E,$91,$76,$91,$3B,$92,$76
                DEFB  $06,$91,$F4,$81,$3B,$87,$60
                DEFB      $91,$3C,$91,$3B,$92,$76
                DEFB      $91,$76,$A1,$3B,$A8,$C6
                DEFB      $91,$D8,$B1,$3B,$B2,$76
                DEFB  $04,$91,$3C,$C1,$3B,$C9,$D9
                DEFB      $91,$76,$D1,$3B,$D2,$76
                DEFB  $09,$91,$D8,$E1,$3B,$EB,$B6
                DEFB      $91,$76,$F1,$3B,$F2,$76
                DEFB  $FF  ; End of Pattern

PAT43:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3C,$F1,$3B,$F9,$D9
                DEFB      $91,$76,$F1,$3B,$F4,$E7
                DEFB      $92,$76,$E1,$3B,$E9,$D9
                DEFB      $91,$3C,$D1,$3B,$D4,$E7
                DEFB  $04,$91,$76,$C1,$3B,$C9,$D9
                DEFB      $92,$31,$B1,$3B,$B4,$E7
                DEFB      $91,$3C,$A1,$3B,$A9,$D9
                DEFB      $91,$76,$91,$3B,$99,$D9
                DEFB  $06,$91,$F4,$81,$3B,$89,$D9
                DEFB      $91,$3C,$91,$3B,$94,$E7
                DEFB      $91,$76,$A1,$3B,$A9,$D9
                DEFB      $91,$D8,$B1,$3B,$B9,$D9
                DEFB  $04,$91,$3C,$C1,$3B,$C4,$E7
                DEFB      $91,$76,$D1,$3B,$D9,$D9
                DEFB  $09,$91,$D8,$E1,$3B,$E4,$E7
                DEFB      $91,$76,$F1,$3B,$F9,$D9
                DEFB  $FF  ; End of Pattern

PAT44:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$91,$3C,$F1,$3B,$F9,$D9
                DEFB      $91,$76,$F1,$3B,$F4,$E7
                DEFB      $92,$76,$E1,$3B,$E8,$C6
                DEFB      $91,$3C,$D1,$3B,$D4,$E7
                DEFB  $04,$91,$76,$C1,$3B,$C9,$D9
                DEFB      $92,$31,$B1,$3B,$B4,$E7
                DEFB      $91,$3C,$A1,$3B,$A7,$60
                DEFB      $91,$76,$91,$3B,$99,$D9
                DEFB  $06,$91,$F4,$81,$3B,$88,$C6
                DEFB      $91,$3C,$91,$3B,$99,$D9
                DEFB      $91,$76,$A1,$3B,$A6,$92
                DEFB      $91,$D8,$B1,$3B,$B9,$D9
                DEFB  $04,$91,$3C,$C1,$3B,$C7,$60
                DEFB      $91,$76,$D1,$3B,$D9,$D9
                DEFB  $09,$91,$D8,$E1,$3B,$E5,$DB
                DEFB      $91,$76,$F1,$3B,$F9,$D9
                DEFB  $FF  ; End of Pattern

PAT45:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$92,$31,$B1,$18,$F8,$C6
                DEFB      $91,$18,$B4,$63,$F4,$63
                DEFB      $91,$18,$B3,$49,$E6,$92
                DEFB      $91,$18,$B0,$8C,$D4,$63
                DEFB  $04,$92,$31,$B1,$18,$C5,$DB
                DEFB      $91,$18,$B0,$8C,$B4,$63
                DEFB      $91,$18,$B1,$F4,$A5,$86
                DEFB      $91,$18,$B0,$8C,$94,$63
                DEFB  $06,$92,$31,$81,$19,$85,$86
                DEFB      $91,$18,$01    ,$94,$63
                DEFB      $91,$18,$B2,$31,$A5,$DB
                DEFB      $91,$18,$B0,$8C,$B4,$63
                DEFB  $04,$92,$31,$D1,$19,$C6,$92
                DEFB      $91,$18,$01    ,$D4,$63
                DEFB  $09,$91,$18,$F2,$31,$E7,$D0
                DEFB      $91,$18,$F0,$8C,$F4,$63
                DEFB  $FF  ; End of Pattern

PAT46:
                DEFW  2414  ;; was 3078     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$92,$31,$B1,$18,$F8,$C6
                DEFB      $91,$18,$B4,$63,$F4,$63
                DEFB      $91,$18,$B3,$49,$E8,$C6
                DEFB      $91,$18,$B0,$8C,$D4,$63
                DEFB  $04,$92,$31,$B1,$18,$C6,$92
                DEFB      $91,$18,$B0,$8C,$B4,$63
                DEFB      $91,$18,$B1,$F4,$A4,$63
                DEFB      $91,$18,$B0,$8C,$94,$63
                DEFB  $06,$92,$31,$81,$19,$88,$C6
                DEFB      $91,$18,$01    ,$94,$63
                DEFB      $91,$18,$B2,$31,$A6,$92
                DEFB      $91,$18,$B0,$8C,$B4,$63
                DEFB  $04,$92,$31,$D1,$19,$C5,$DB
                DEFB      $91,$18,$01    ,$D4,$63
                DEFB  $09,$91,$18,$F2,$31,$E5,$86
                DEFB      $91,$18,$F0,$8C,$F4,$63
                DEFB  $FF  ; End of Pattern

