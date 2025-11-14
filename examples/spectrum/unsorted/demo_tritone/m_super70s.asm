
SECTION SUPER70S
org 55000

; *** Song layout ***
LOOPSTART:            DEFW      PAT0
                      DEFW      PAT0
                      DEFW      PAT1
                      DEFW      PAT2
                      DEFW      PAT3
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT7
                      DEFW      PAT8
                      DEFW      PAT7
                      DEFW      PAT8
                      DEFW      $0000
                      DEFW      LOOPSTART

; *** Patterns ***
PAT0:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$81,$D8,$87,$60
                DEFB      $90,$EC,$92,$31,$93,$B0
                DEFB      $A0,$EC,$A2,$C3,$A7,$60
                DEFB      $B0,$EC,$B3,$B0,$B3,$B0
                DEFB      $C0,$EC,$C4,$63,$00
                DEFB      $D0,$EC,$D7,$60,$01
                DEFB      $E0,$EC,$E5,$86,$01
                DEFB      $F0,$EC,$F4,$63,$01
                DEFB  $06,$80,$EC,$F1,$D8,$87,$60
                DEFB      $90,$EC,$E2,$31,$93,$B0
                DEFB      $A0,$EC,$D2,$C3,$A7,$60
                DEFB      $B0,$EC,$C3,$B0,$B3,$B0
                DEFB  $04,$81,$18,$B4,$63,$84,$63
                DEFB      $91,$18,$A3,$B0,$98,$C6
                DEFB      $A1,$18,$92,$C3,$A4,$63
                DEFB      $B1,$18,$82,$31,$B8,$C6
                DEFB      $F1,$18,$81,$D8,$00
                DEFB      $E1,$18,$92,$31,$01
                DEFB      $D1,$18,$A2,$C3,$01
                DEFB      $C1,$18,$B3,$B0,$01
                DEFB  $06,$81,$18,$C2,$C3,$87,$60
                DEFB      $91,$18,$D2,$31,$93,$B0
                DEFB      $A1,$18,$E1,$D8,$A7,$60
                DEFB      $B1,$18,$F2,$31,$B3,$B0
                DEFB  $04,$81,$3B,$F2,$C3,$89,$D9
                DEFB      $91,$3B,$E3,$B0,$94,$E7
                DEFB      $A1,$3B,$D4,$63,$A9,$D9
                DEFB      $B1,$3B,$C3,$B0,$B4,$E7
                DEFB      $C1,$3B,$B2,$C3,$00
                DEFB      $D1,$3B,$A2,$31,$01
                DEFB      $E1,$3B,$91,$D8,$01
                DEFB      $F1,$3B,$82,$31,$01
                DEFB  $06,$E1,$3B,$82,$C3,$01
                DEFB      $D1,$3B,$93,$B0,$01
                DEFB      $C1,$3B,$A4,$63,$01
                DEFB      $B1,$3B,$B3,$B0,$01
                DEFB      $A1,$3B,$C2,$C3,$01
                DEFB      $91,$3B,$D2,$31,$01
                DEFB      $81,$3B,$E1,$D8,$01
                DEFB      $91,$3B,$F2,$31,$01
                DEFB  $05,$A1,$4D,$F2,$C3,$8A,$6E
                DEFB      $B1,$4D,$E3,$B0,$98,$C6
                DEFB      $C1,$4D,$D4,$63,$AA,$6E
                DEFB      $D1,$4D,$C2,$C3,$B8,$C6
                DEFB      $E1,$4D,$B2,$31,$00
                DEFB      $F1,$4D,$A1,$D8,$01
                DEFB      $E1,$4D,$92,$31,$01
                DEFB      $D1,$4D,$82,$C3,$01
                DEFB  $04,$C1,$3B,$83,$B0,$89,$D9
                DEFB      $B1,$3B,$94,$63,$98,$C6
                DEFB      $A1,$3B,$A3,$B0,$A9,$D9
                DEFB      $91,$3B,$B2,$C3,$B8,$C6
                DEFB      $81,$3B,$C2,$31,$00
                DEFB      $91,$3B,$D1,$D8,$01
                DEFB      $A1,$3B,$E2,$31,$01
                DEFB      $B1,$3B,$F2,$C3,$01
                DEFB  $06,$C1,$18,$F3,$B0,$88,$C6
                DEFB      $D1,$18,$E2,$C3,$97,$60
                DEFB      $E1,$18,$D2,$31,$A8,$C6
                DEFB      $F1,$18,$C1,$D8,$B7,$60
                DEFB      $E1,$18,$B2,$31,$00
                DEFB      $D1,$18,$A2,$C3,$01
                DEFB      $C1,$18,$93,$B0,$01
                DEFB      $B1,$18,$82,$C3,$01
                DEFB  $FF  ; End of Pattern

PAT1:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$81,$D8,$8E,$C1
                DEFB      $90,$EC,$92,$31,$9E,$C1
                DEFB      $A0,$EC,$A2,$C3,$BE,$C1
                DEFB      $B0,$EC,$B3,$B0,$DE,$C1
                DEFB      $C0,$EC,$C4,$63,$8B,$0D
                DEFB      $D0,$EC,$D7,$60,$9B,$0D
                DEFB      $E0,$EC,$E5,$86,$BB,$0D
                DEFB      $F0,$EC,$F4,$63,$DB,$0D
                DEFB  $06,$80,$EC,$F1,$D8,$88,$C6
                DEFB      $90,$EC,$E2,$31,$98,$C6
                DEFB      $A0,$EC,$D2,$C3,$B8,$C6
                DEFB      $B0,$EC,$C3,$B0,$D8,$C6
                DEFB  $04,$81,$18,$B4,$63,$87,$60
                DEFB      $91,$18,$A3,$B0,$97,$60
                DEFB      $A1,$18,$92,$C3,$B7,$60
                DEFB      $B1,$18,$82,$31,$D7,$60
                DEFB      $F1,$18,$81,$D8,$00
                DEFB      $E1,$18,$92,$31,$01
                DEFB      $D1,$18,$A2,$C3,$01
                DEFB      $C1,$18,$B3,$B0,$01
                DEFB  $06,$81,$18,$C2,$C3,$87,$60
                DEFB      $91,$18,$D2,$31,$93,$B0
                DEFB      $A1,$18,$E1,$D8,$A7,$60
                DEFB      $B1,$18,$F2,$31,$B3,$B0
                DEFB  $04,$81,$3B,$F2,$C3,$89,$D9
                DEFB      $91,$3B,$E3,$B0,$94,$E7
                DEFB      $A1,$3B,$D4,$63,$A9,$D9
                DEFB      $B1,$3B,$C3,$B0,$B4,$E7
                DEFB      $C1,$3B,$B2,$C3,$00
                DEFB      $D1,$3B,$A2,$31,$01
                DEFB      $E1,$3B,$91,$D8,$01
                DEFB      $F1,$3B,$82,$31,$01
                DEFB  $06,$E1,$3B,$82,$C3,$01
                DEFB      $D1,$3B,$93,$B0,$01
                DEFB      $C1,$3B,$A4,$63,$01
                DEFB      $B1,$3B,$B3,$B0,$01
                DEFB      $A1,$3B,$C2,$C3,$01
                DEFB      $91,$3B,$D2,$31,$01
                DEFB      $81,$3B,$E1,$D8,$01
                DEFB      $91,$3B,$F2,$31,$01
                DEFB  $05,$A1,$4D,$F2,$C3,$8A,$6E
                DEFB      $B1,$4D,$E3,$B0,$98,$C6
                DEFB      $C1,$4D,$D4,$63,$AA,$6E
                DEFB      $D1,$4D,$C2,$C3,$B8,$C6
                DEFB      $E1,$4D,$B2,$31,$00
                DEFB      $F1,$4D,$A1,$D8,$01
                DEFB      $E1,$4D,$92,$31,$01
                DEFB      $D1,$4D,$82,$C3,$01
                DEFB  $04,$C1,$3B,$83,$B0,$89,$D9
                DEFB      $B1,$3B,$94,$63,$98,$C6
                DEFB      $A1,$3B,$A3,$B0,$A9,$D9
                DEFB      $91,$3B,$B2,$C3,$B8,$C6
                DEFB      $81,$3B,$C2,$31,$00
                DEFB      $91,$3B,$D1,$D8,$01
                DEFB      $A1,$3B,$E2,$31,$01
                DEFB      $B1,$3B,$F2,$C3,$01
                DEFB  $06,$C1,$18,$F3,$B0,$88,$C6
                DEFB      $D1,$18,$E2,$C3,$97,$60
                DEFB      $E1,$18,$D2,$31,$A8,$C6
                DEFB      $F1,$18,$C1,$D8,$B7,$60
                DEFB      $E1,$18,$B2,$31,$00
                DEFB      $D1,$18,$A2,$C3,$01
                DEFB      $C1,$18,$93,$B0,$01
                DEFB      $B1,$18,$82,$C3,$01
                DEFB  $FF  ; End of Pattern

PAT2:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$81,$D8,$83,$B0
                DEFB      $01    ,$01    ,$97,$60
                DEFB      $01    ,$01    ,$A3,$B0
                DEFB      $01    ,$01    ,$B7,$60
                DEFB      $01    ,$01    ,$C3,$B0
                DEFB      $01    ,$01    ,$D7,$60
                DEFB      $01    ,$01    ,$E3,$B0
                DEFB      $01    ,$01    ,$F7,$60
                DEFB      $01    ,$01    ,$F3,$B0
                DEFB      $01    ,$01    ,$E7,$60
                DEFB      $01    ,$01    ,$D3,$B0
                DEFB      $01    ,$01    ,$C7,$60
                DEFB  $03,$80,$DE,$81,$BD,$B3,$7B
                DEFB      $01    ,$01    ,$A6,$F6
                DEFB      $01    ,$01    ,$93,$7B
                DEFB      $01    ,$01    ,$86,$F6
                DEFB      $01    ,$01    ,$83,$7B
                DEFB      $01    ,$01    ,$96,$F6
                DEFB      $01    ,$01    ,$A3,$7B
                DEFB      $01    ,$01    ,$B6,$F6
                DEFB      $01    ,$01    ,$C3,$7B
                DEFB      $01    ,$01    ,$D6,$F6
                DEFB      $01    ,$01    ,$E3,$7B
                DEFB      $01    ,$01    ,$F6,$F6
                DEFB  $04,$80,$D2,$81,$A4,$F3,$49
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$D3,$49
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $01    ,$01    ,$B3,$49
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$93,$49
                DEFB      $01    ,$01    ,$86,$92
                DEFB      $01    ,$01    ,$83,$49
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$A3,$49
                DEFB      $01    ,$01    ,$B6,$92
                DEFB  $05,$80,$B0,$81,$61,$C2,$C3
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $01    ,$01    ,$E2,$C3
                DEFB      $01    ,$01    ,$F5,$86
                DEFB      $01    ,$01    ,$F2,$C3
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $01    ,$01    ,$D2,$C3
                DEFB      $01    ,$01    ,$C5,$86
                DEFB      $01    ,$01    ,$B2,$C3
                DEFB      $01    ,$01    ,$A5,$86
                DEFB      $01    ,$01    ,$92,$C3
                DEFB      $01    ,$01    ,$85,$86
                DEFB  $06,$80,$A6,$81,$4D,$82,$9B
                DEFB      $01    ,$01    ,$95,$37
                DEFB      $01    ,$01    ,$A2,$9B
                DEFB      $01    ,$01    ,$B5,$37
                DEFB      $01    ,$01    ,$C2,$9B
                DEFB      $01    ,$01    ,$D5,$37
                DEFB      $01    ,$01    ,$E2,$9B
                DEFB      $01    ,$01    ,$F5,$37
                DEFB  $07,$80,$9D,$81,$3B,$F2,$76
                DEFB      $01    ,$01    ,$E4,$E7
                DEFB      $01    ,$01    ,$D2,$76
                DEFB      $01    ,$01    ,$C4,$E7
                DEFB      $01    ,$01    ,$B2,$76
                DEFB      $01    ,$01    ,$A4,$E7
                DEFB      $01    ,$01    ,$92,$76
                DEFB      $01    ,$01    ,$84,$E7
                DEFB  $FF  ; End of Pattern

PAT3:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$84,$63,$85,$86
                DEFB      $80,$EC,$93,$B0,$93,$B0
                DEFB      $80,$EC,$A4,$63,$A5,$86
                DEFB      $80,$EC,$B3,$B0,$B3,$B0
                DEFB      $80,$EC,$C4,$63,$C5,$86
                DEFB      $80,$EC,$D3,$B0,$D3,$B0
                DEFB      $80,$EC,$E4,$63,$E5,$86
                DEFB      $80,$EC,$F3,$B0,$F3,$B0
                DEFB  $06,$80,$EC,$F4,$63,$F5,$86
                DEFB      $80,$EC,$E3,$B0,$E3,$B0
                DEFB      $80,$EC,$D4,$63,$D5,$86
                DEFB      $80,$EC,$C3,$B0,$C3,$B0
                DEFB  $04,$81,$18,$B4,$63,$B5,$86
                DEFB      $81,$18,$A3,$B0,$A3,$B0
                DEFB      $81,$18,$94,$63,$95,$86
                DEFB      $81,$18,$83,$B0,$83,$B0
                DEFB      $81,$18,$84,$63,$85,$86
                DEFB      $81,$18,$93,$B0,$93,$B0
                DEFB      $81,$18,$A4,$63,$A5,$86
                DEFB      $81,$18,$B3,$B0,$B3,$B0
                DEFB  $06,$81,$18,$C4,$63,$C5,$86
                DEFB      $81,$18,$D3,$B0,$D3,$B0
                DEFB      $81,$18,$E4,$63,$E5,$86
                DEFB      $81,$18,$F3,$B0,$F3,$B0
                DEFB  $04,$81,$3B,$F4,$63,$F5,$86
                DEFB      $81,$3B,$E3,$B0,$E3,$B0
                DEFB      $81,$3B,$D4,$63,$D5,$86
                DEFB      $81,$3B,$C3,$B0,$C3,$B0
                DEFB      $81,$3B,$B4,$63,$B5,$86
                DEFB      $81,$3B,$A3,$B0,$A3,$B0
                DEFB      $81,$3B,$94,$63,$95,$86
                DEFB      $81,$3B,$83,$B0,$83,$B0
                DEFB  $06,$81,$3B,$84,$63,$85,$86
                DEFB      $81,$3B,$93,$B0,$93,$B0
                DEFB      $81,$3B,$A4,$63,$A5,$86
                DEFB      $81,$3B,$B3,$B0,$B3,$B0
                DEFB      $81,$3B,$C4,$63,$C5,$86
                DEFB      $81,$3B,$D3,$B0,$D3,$B0
                DEFB      $81,$3B,$E4,$63,$E5,$86
                DEFB      $81,$3B,$F3,$B0,$F3,$B0
                DEFB  $05,$81,$4D,$F4,$63,$F5,$86
                DEFB      $81,$4D,$E3,$B0,$E3,$B0
                DEFB      $81,$4D,$D4,$63,$D5,$86
                DEFB      $81,$4D,$C3,$B0,$C3,$B0
                DEFB      $81,$4D,$B4,$63,$B5,$86
                DEFB      $81,$4D,$A3,$B0,$A3,$B0
                DEFB      $81,$4D,$94,$63,$95,$86
                DEFB      $81,$4D,$83,$B0,$83,$B0
                DEFB  $04,$81,$3B,$84,$63,$85,$86
                DEFB      $81,$3B,$93,$B0,$93,$B0
                DEFB      $81,$3B,$A4,$63,$A5,$86
                DEFB      $81,$3B,$B3,$B0,$B3,$B0
                DEFB      $81,$3B,$C4,$63,$C5,$86
                DEFB      $81,$3B,$D3,$B0,$D3,$B0
                DEFB      $81,$3B,$E4,$63,$E5,$86
                DEFB      $81,$3B,$F3,$B0,$F3,$B0
                DEFB  $06,$81,$18,$F4,$63,$F5,$86
                DEFB      $81,$18,$E3,$B0,$E3,$B0
                DEFB      $81,$18,$D4,$63,$D5,$86
                DEFB      $81,$18,$C3,$B0,$C3,$B0
                DEFB      $81,$18,$B4,$63,$B5,$86
                DEFB      $81,$18,$A3,$B0,$A3,$B0
                DEFB      $81,$18,$94,$63,$95,$86
                DEFB      $81,$18,$83,$B0,$83,$B0
                DEFB  $FF  ; End of Pattern

PAT4:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$84,$63,$85,$DB
                DEFB      $80,$EC,$93,$B0,$93,$B0
                DEFB      $80,$EC,$A4,$63,$A5,$DB
                DEFB      $80,$EC,$B3,$B0,$B3,$B0
                DEFB      $80,$EC,$C4,$63,$C5,$DB
                DEFB      $80,$EC,$D3,$B0,$D3,$B0
                DEFB      $80,$EC,$E4,$63,$E5,$DB
                DEFB      $80,$EC,$F3,$B0,$F3,$B0
                DEFB  $06,$80,$EC,$F4,$63,$F5,$DB
                DEFB      $80,$EC,$E3,$B0,$E3,$B0
                DEFB      $80,$EC,$D4,$63,$D5,$DB
                DEFB      $80,$EC,$C3,$B0,$C3,$B0
                DEFB  $04,$81,$18,$B4,$63,$B5,$DB
                DEFB      $81,$18,$A3,$B0,$A3,$B0
                DEFB      $81,$18,$94,$63,$95,$DB
                DEFB      $81,$18,$83,$B0,$83,$B0
                DEFB      $81,$18,$84,$63,$85,$DB
                DEFB      $81,$18,$93,$B0,$93,$B0
                DEFB      $81,$18,$A4,$63,$A5,$DB
                DEFB      $81,$18,$B3,$B0,$B3,$B0
                DEFB  $06,$81,$18,$C4,$63,$C5,$DB
                DEFB      $81,$18,$D3,$B0,$D3,$B0
                DEFB      $81,$18,$E4,$63,$E5,$DB
                DEFB      $81,$18,$F3,$B0,$F3,$B0
                DEFB  $04,$81,$3B,$F4,$63,$F5,$DB
                DEFB      $81,$3B,$E3,$B0,$E3,$B0
                DEFB      $81,$3B,$D4,$63,$D5,$DB
                DEFB      $81,$3B,$C3,$B0,$C3,$B0
                DEFB      $81,$3B,$B4,$63,$B5,$DB
                DEFB      $81,$3B,$A3,$B0,$A3,$B0
                DEFB      $81,$3B,$94,$63,$95,$DB
                DEFB      $81,$3B,$83,$B0,$83,$B0
                DEFB  $06,$81,$3B,$84,$63,$85,$DB
                DEFB      $81,$3B,$93,$B0,$93,$B0
                DEFB      $81,$3B,$A4,$63,$A5,$DB
                DEFB      $81,$3B,$B3,$B0,$B3,$B0
                DEFB      $81,$3B,$C4,$63,$C5,$DB
                DEFB      $81,$3B,$D3,$B0,$D3,$B0
                DEFB      $81,$3B,$E4,$63,$E5,$DB
                DEFB      $81,$3B,$F3,$B0,$F3,$B0
                DEFB  $05,$81,$4D,$F4,$63,$F5,$DB
                DEFB      $81,$4D,$E3,$B0,$E3,$B0
                DEFB      $81,$4D,$D4,$63,$D5,$DB
                DEFB      $81,$4D,$C3,$B0,$C3,$B0
                DEFB      $81,$4D,$B4,$63,$B5,$DB
                DEFB      $81,$4D,$A3,$B0,$A3,$B0
                DEFB      $81,$4D,$94,$63,$95,$DB
                DEFB      $81,$4D,$83,$B0,$83,$B0
                DEFB  $04,$81,$3B,$84,$63,$85,$DB
                DEFB      $81,$3B,$93,$B0,$93,$B0
                DEFB      $81,$3B,$A4,$63,$A5,$DB
                DEFB      $81,$3B,$B3,$B0,$B3,$B0
                DEFB      $81,$3B,$C4,$63,$C5,$DB
                DEFB      $81,$3B,$D3,$B0,$D3,$B0
                DEFB      $81,$3B,$E4,$63,$E5,$DB
                DEFB      $81,$3B,$F3,$B0,$F3,$B0
                DEFB  $06,$81,$18,$F4,$63,$F5,$DB
                DEFB      $81,$18,$E3,$B0,$E3,$B0
                DEFB      $81,$18,$D4,$63,$D5,$DB
                DEFB      $81,$18,$C3,$B0,$C3,$B0
                DEFB      $81,$18,$B4,$63,$B5,$DB
                DEFB      $81,$18,$A3,$B0,$A3,$B0
                DEFB      $81,$18,$94,$63,$95,$DB
                DEFB      $81,$18,$83,$B0,$83,$B0
                DEFB  $FF  ; End of Pattern

PAT5:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$84,$63,$86,$34
                DEFB      $80,$EC,$93,$B0,$93,$B0
                DEFB      $80,$EC,$A4,$63,$A6,$34
                DEFB      $80,$EC,$B3,$B0,$B3,$B0
                DEFB      $80,$EC,$C4,$63,$C6,$34
                DEFB      $80,$EC,$D3,$B0,$D3,$B0
                DEFB      $80,$EC,$E4,$63,$E6,$34
                DEFB      $80,$EC,$F3,$B0,$F3,$B0
                DEFB  $06,$80,$EC,$F4,$63,$F6,$34
                DEFB      $80,$EC,$E3,$B0,$E3,$B0
                DEFB      $80,$EC,$D4,$63,$D6,$34
                DEFB      $80,$EC,$C3,$B0,$C3,$B0
                DEFB  $04,$81,$18,$B4,$63,$B6,$34
                DEFB      $81,$18,$A3,$B0,$A3,$B0
                DEFB      $81,$18,$94,$63,$96,$34
                DEFB      $81,$18,$83,$B0,$83,$B0
                DEFB      $81,$18,$84,$63,$86,$34
                DEFB      $81,$18,$93,$B0,$93,$B0
                DEFB      $81,$18,$A4,$63,$A6,$34
                DEFB      $81,$18,$B3,$B0,$B3,$B0
                DEFB  $06,$81,$18,$C4,$63,$C6,$34
                DEFB      $81,$18,$D3,$B0,$D3,$B0
                DEFB      $81,$18,$E4,$63,$E6,$34
                DEFB      $81,$18,$F3,$B0,$F3,$B0
                DEFB  $04,$81,$3B,$F4,$63,$F6,$34
                DEFB      $81,$3B,$E3,$B0,$E3,$B0
                DEFB      $81,$3B,$D4,$63,$D6,$34
                DEFB      $81,$3B,$C3,$B0,$C3,$B0
                DEFB      $81,$3B,$B4,$63,$B6,$34
                DEFB      $81,$3B,$A3,$B0,$A3,$B0
                DEFB      $81,$3B,$94,$63,$96,$34
                DEFB      $81,$3B,$83,$B0,$83,$B0
                DEFB  $06,$81,$3B,$84,$63,$86,$34
                DEFB      $81,$3B,$93,$B0,$93,$B0
                DEFB      $81,$3B,$A4,$63,$A6,$34
                DEFB      $81,$3B,$B3,$B0,$B3,$B0
                DEFB      $81,$3B,$C4,$63,$C6,$34
                DEFB      $81,$3B,$D3,$B0,$D3,$B0
                DEFB      $81,$3B,$E4,$63,$E6,$34
                DEFB      $81,$3B,$F3,$B0,$F3,$B0
                DEFB  $05,$81,$4D,$F4,$63,$F6,$34
                DEFB      $81,$4D,$E3,$B0,$E3,$B0
                DEFB      $81,$4D,$D4,$63,$D6,$34
                DEFB      $81,$4D,$C3,$B0,$C3,$B0
                DEFB      $81,$4D,$B4,$63,$B6,$34
                DEFB      $81,$4D,$A3,$B0,$A3,$B0
                DEFB      $81,$4D,$94,$63,$96,$34
                DEFB      $81,$4D,$83,$B0,$83,$B0
                DEFB  $04,$81,$3B,$84,$63,$86,$34
                DEFB      $81,$3B,$93,$B0,$93,$B0
                DEFB      $81,$3B,$A4,$63,$A6,$34
                DEFB      $81,$3B,$B3,$B0,$B3,$B0
                DEFB      $81,$3B,$C4,$63,$C6,$34
                DEFB      $81,$3B,$D3,$B0,$D3,$B0
                DEFB      $81,$3B,$E4,$63,$E6,$34
                DEFB      $81,$3B,$F3,$B0,$F3,$B0
                DEFB  $06,$81,$18,$F4,$63,$F6,$34
                DEFB      $81,$18,$E3,$B0,$E3,$B0
                DEFB      $81,$18,$D4,$63,$D6,$34
                DEFB      $81,$18,$C3,$B0,$C3,$B0
                DEFB      $81,$18,$B4,$63,$B6,$34
                DEFB      $81,$18,$A3,$B0,$A3,$B0
                DEFB      $81,$18,$94,$63,$96,$34
                DEFB      $81,$18,$83,$B0,$83,$B0
                DEFB  $FF  ; End of Pattern

PAT6:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$81,$D8,$87,$60
                DEFB      $01    ,$93,$B0,$96,$92
                DEFB      $01    ,$A1,$D8,$A7,$60
                DEFB      $01    ,$B3,$B0,$B6,$92
                DEFB      $01    ,$C1,$D8,$C7,$60
                DEFB      $01    ,$D3,$B0,$D6,$92
                DEFB      $01    ,$E1,$D8,$E7,$60
                DEFB      $01    ,$F3,$B0,$F6,$92
                DEFB      $01    ,$F1,$D8,$F7,$60
                DEFB      $01    ,$E3,$B0,$E6,$92
                DEFB      $01    ,$D1,$D8,$D7,$60
                DEFB      $01    ,$C3,$B0,$C6,$92
                DEFB  $03,$80,$DE,$B1,$BD,$B6,$F6
                DEFB      $01    ,$A3,$7B,$A6,$92
                DEFB      $01    ,$91,$BD,$96,$F6
                DEFB      $01    ,$83,$7B,$86,$92
                DEFB      $01    ,$81,$BD,$86,$F6
                DEFB      $01    ,$93,$7B,$96,$92
                DEFB      $01    ,$A1,$BD,$A6,$F6
                DEFB      $01    ,$B3,$7B,$B6,$92
                DEFB      $01    ,$C1,$BD,$C6,$F6
                DEFB      $01    ,$D3,$7B,$D6,$92
                DEFB      $01    ,$E1,$BD,$E6,$F6
                DEFB      $01    ,$F3,$7B,$F6,$92
                DEFB  $04,$80,$D2,$F1,$A4,$F6,$92
                DEFB      $01    ,$E3,$49,$E6,$C4
                DEFB      $01    ,$D1,$A4,$D6,$92
                DEFB      $01    ,$C3,$49,$C6,$60
                DEFB      $01    ,$B1,$A4,$B6,$92
                DEFB      $01    ,$A3,$49,$A6,$C4
                DEFB      $01    ,$91,$A4,$96,$92
                DEFB      $01    ,$83,$49,$86,$60
                DEFB      $01    ,$81,$A4,$86,$92
                DEFB      $01    ,$93,$49,$96,$C4
                DEFB      $01    ,$A1,$A4,$A6,$92
                DEFB      $01    ,$B3,$49,$B6,$60
                DEFB  $05,$80,$B0,$C1,$61,$C5,$86
                DEFB      $01    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$E5,$86
                DEFB      $01    ,$01    ,$F6,$92
                DEFB      $01    ,$01    ,$F5,$86
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$D5,$86
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $01    ,$01    ,$B5,$86
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$95,$86
                DEFB      $01    ,$01    ,$86,$92
                DEFB  $06,$80,$A6,$81,$4D,$85,$37
                DEFB      $01    ,$01    ,$96,$92
                DEFB      $01    ,$01    ,$A5,$37
                DEFB      $01    ,$01    ,$B6,$92
                DEFB      $01    ,$01    ,$C5,$37
                DEFB      $01    ,$01    ,$D6,$92
                DEFB      $01    ,$01    ,$E5,$37
                DEFB      $01    ,$01    ,$F6,$92
                DEFB  $07,$80,$9D,$F1,$3B,$F4,$E7
                DEFB      $01    ,$01    ,$E6,$92
                DEFB      $01    ,$01    ,$D4,$E7
                DEFB      $01    ,$01    ,$C6,$92
                DEFB      $01    ,$01    ,$B4,$E7
                DEFB      $01    ,$01    ,$A6,$92
                DEFB      $01    ,$01    ,$94,$E7
                DEFB      $01    ,$01    ,$86,$92
                DEFB  $FF  ; End of Pattern

PAT7:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$81,$D8,$8E,$C1
                DEFB      $80,$EC,$93,$B0,$97,$60
                DEFB      $80,$EC,$A1,$D8,$AE,$C1
                DEFB      $80,$EC,$B3,$B0,$B3,$B0
                DEFB      $80,$EC,$C1,$D8,$C3,$B0
                DEFB      $80,$EC,$D1,$D8,$D3,$B0
                DEFB      $80,$EC,$E1,$D8,$E3,$B0
                DEFB      $80,$EC,$F1,$D8,$F3,$B0
                DEFB  $06,$80,$EC,$F1,$D8,$FD,$25
                DEFB      $80,$EC,$E1,$D8,$E6,$92
                DEFB      $80,$EC,$D1,$D8,$DD,$25
                DEFB      $80,$EC,$C1,$D8,$C3,$B0
                DEFB  $04,$81,$18,$B2,$31,$BE,$C1
                DEFB      $81,$18,$A1,$D8,$A7,$60
                DEFB      $81,$18,$92,$31,$9E,$C1
                DEFB      $81,$18,$81,$D8,$83,$B0
                DEFB      $81,$18,$82,$31,$83,$B0
                DEFB      $81,$18,$91,$D8,$93,$B0
                DEFB      $81,$18,$A2,$31,$A3,$B0
                DEFB      $81,$18,$B1,$D8,$B3,$B0
                DEFB  $06,$81,$18,$C2,$31,$CD,$25
                DEFB      $81,$18,$D1,$D8,$D6,$92
                DEFB      $81,$18,$E2,$31,$ED,$25
                DEFB      $81,$18,$F1,$D8,$F3,$B0
                DEFB  $04,$81,$3B,$F2,$76,$FE,$C1
                DEFB      $81,$3B,$E1,$D8,$E7,$60
                DEFB      $81,$3B,$D2,$76,$DE,$C1
                DEFB      $81,$3B,$C1,$D8,$C3,$B0
                DEFB      $81,$3B,$B2,$76,$B3,$B0
                DEFB      $81,$3B,$A1,$D8,$A3,$B0
                DEFB      $81,$3B,$92,$76,$93,$B0
                DEFB      $81,$3B,$81,$D8,$83,$B0
                DEFB  $06,$81,$3B,$82,$76,$8E,$C1
                DEFB      $81,$3B,$91,$D8,$97,$60
                DEFB      $81,$3B,$A2,$76,$AE,$C1
                DEFB      $81,$3B,$B1,$D8,$B3,$B0
                DEFB      $81,$3B,$C2,$76,$CB,$0D
                DEFB      $81,$3B,$D1,$D8,$D5,$86
                DEFB      $81,$3B,$E2,$76,$EB,$0D
                DEFB      $81,$3B,$F1,$D8,$F3,$B0
                DEFB  $05,$81,$4D,$F2,$9B,$F7,$60
                DEFB      $81,$4D,$E1,$D8,$E3,$B0
                DEFB      $81,$4D,$D2,$9B,$D7,$60
                DEFB      $81,$4D,$C1,$D8,$C3,$B0
                DEFB      $81,$4D,$B2,$9B,$B3,$B0
                DEFB      $81,$4D,$A1,$D8,$A3,$B0
                DEFB      $81,$4D,$92,$9B,$93,$B0
                DEFB      $81,$4D,$81,$D8,$83,$B0
                DEFB  $04,$81,$3B,$82,$76,$83,$B0
                DEFB      $81,$3B,$91,$D8,$93,$B0
                DEFB      $81,$3B,$A2,$76,$A3,$B0
                DEFB      $81,$3B,$B1,$D8,$B3,$B0
                DEFB      $81,$3B,$C2,$76,$C3,$B0
                DEFB      $81,$3B,$D1,$D8,$D3,$B0
                DEFB      $81,$3B,$E2,$76,$E3,$B0
                DEFB      $81,$3B,$F1,$D8,$F3,$B0
                DEFB  $06,$81,$18,$F2,$31,$F3,$7B
                DEFB      $81,$18,$E1,$D8,$E3,$49
                DEFB      $81,$18,$D2,$31,$D3,$1A
                DEFB      $81,$18,$C1,$D8,$C2,$ED
                DEFB      $81,$18,$B2,$31,$B2,$C3
                DEFB      $81,$18,$A1,$D8,$A2,$9B
                DEFB      $81,$18,$92,$31,$92,$76
                DEFB      $81,$18,$81,$D8,$82,$52
                DEFB  $FF  ; End of Pattern

PAT8:
                DEFW  706  ;; was 900     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $06,$80,$EC,$81,$D8,$83,$B0
                DEFB      $80,$EC,$93,$B0,$93,$B0
                DEFB      $80,$EC,$A1,$D8,$A3,$B0
                DEFB      $80,$EC,$B3,$B0,$B3,$B0
                DEFB      $80,$EC,$C1,$D8,$C4,$63
                DEFB      $80,$EC,$D1,$D8,$D4,$63
                DEFB      $80,$EC,$E1,$D8,$E4,$63
                DEFB      $80,$EC,$F1,$D8,$F4,$63
                DEFB  $06,$80,$EC,$F1,$D8,$F4,$E7
                DEFB      $80,$EC,$E1,$D8,$E4,$E7
                DEFB      $80,$EC,$D1,$D8,$D4,$E7
                DEFB      $80,$EC,$C1,$D8,$C4,$E7
                DEFB  $04,$81,$18,$B2,$31,$B5,$37
                DEFB      $81,$18,$A1,$D8,$A5,$37
                DEFB      $81,$18,$92,$31,$95,$37
                DEFB      $81,$18,$81,$D8,$85,$37
                DEFB      $81,$18,$82,$31,$85,$37
                DEFB      $81,$18,$91,$D8,$95,$37
                DEFB      $81,$18,$A2,$31,$A5,$37
                DEFB      $81,$18,$B1,$D8,$B5,$37
                DEFB  $06,$81,$18,$C2,$31,$C5,$86
                DEFB      $81,$18,$D1,$D8,$D5,$86
                DEFB      $81,$18,$E2,$31,$E5,$86
                DEFB      $81,$18,$F1,$D8,$F5,$86
                DEFB  $04,$81,$3B,$F2,$76,$F6,$92
                DEFB      $81,$3B,$E1,$D8,$E6,$92
                DEFB      $81,$3B,$D2,$76,$D6,$92
                DEFB      $81,$3B,$C1,$D8,$C6,$92
                DEFB      $81,$3B,$B2,$76,$B7,$60
                DEFB      $81,$3B,$A1,$D8,$A7,$60
                DEFB      $81,$3B,$92,$76,$97,$60
                DEFB      $81,$3B,$81,$D8,$87,$60
                DEFB  $06,$81,$3B,$82,$76,$87,$60
                DEFB      $81,$3B,$91,$D8,$97,$60
                DEFB      $81,$3B,$A2,$76,$A7,$60
                DEFB      $81,$3B,$B1,$D8,$B7,$60
                DEFB      $81,$3B,$C2,$76,$C6,$92
                DEFB      $81,$3B,$D1,$D8,$D6,$92
                DEFB      $81,$3B,$E2,$76,$E6,$92
                DEFB      $81,$3B,$F1,$D8,$F6,$92
                DEFB  $05,$81,$4D,$F2,$9B,$F5,$86
                DEFB      $81,$4D,$E1,$D8,$E5,$86
                DEFB      $81,$4D,$D2,$9B,$D5,$86
                DEFB      $81,$4D,$C1,$D8,$C5,$86
                DEFB      $81,$4D,$B2,$9B,$B6,$92
                DEFB      $81,$4D,$A1,$D8,$A6,$92
                DEFB      $81,$4D,$92,$9B,$96,$92
                DEFB      $81,$4D,$81,$D8,$86,$92
                DEFB  $04,$81,$3B,$82,$76,$85,$86
                DEFB      $81,$3B,$91,$D8,$95,$86
                DEFB      $81,$3B,$A2,$76,$A5,$86
                DEFB      $81,$3B,$B1,$D8,$B5,$86
                DEFB      $81,$3B,$C2,$76,$C4,$E7
                DEFB      $81,$3B,$D1,$D8,$D4,$E7
                DEFB      $81,$3B,$E2,$76,$E4,$E7
                DEFB      $81,$3B,$F1,$D8,$F4,$E7
                DEFB  $06,$81,$18,$F2,$31,$F5,$37
                DEFB      $81,$18,$E1,$D8,$E5,$37
                DEFB      $81,$18,$D2,$31,$D4,$E7
                DEFB      $81,$18,$C1,$D8,$C4,$E7
                DEFB      $81,$18,$B2,$31,$B4,$63
                DEFB      $81,$18,$A1,$D8,$A4,$63
                DEFB      $81,$18,$92,$31,$94,$63
                DEFB      $81,$18,$81,$D8,$84,$63
                DEFB  $FF  ; End of Pattern

