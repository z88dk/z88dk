;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize - gbz80 normalisation
;-------------------------------------------------------------------------
;
;  unpacked: h==0 (discarded); mantissa=lde, sign in b, exponent in c
;  result packed IEEE DEHL (no af')
;
;  Same strategy as z80: A:HL residual loop (add hl,hl / adc a,a),
;  byte align first, pack with rla/rra through A only.

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize


.m32_fsnormalize
    push hl                    ; E = high, HL = mid:low
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
    ld d,0                      ; shift total

    ; ---------------------------------------------------------------
    ; Byte scan on E:HL and byte-alignment of it
    ; ---------------------------------------------------------------

    ; After HL↔DE: E = mant MSB, HL = mid:low.  No S flag on gbz80.
    ld a,e
    or a
    jr z,scan_h                     ; E == 0
    bit 7,a
    jr nz,normalised                ; already normalised (hot path)
    jr need_shift                   ; E nonzero, bit7 clear

.scan_h
    ld a,h
    or a
    jr z,scan_l
    ; lead in H → byte-align by 8; A holds H (ld below keep flags unused)
    ld h,l
    ld l,e                          ; A:HL shifted by 8 (l = 0)
    ld d,8
    bit 7,a
    jr nz,normalised
    jr need_shift

.scan_l
    ld a,l
    or a
    jr z,normzero                   ; all zeroes
    ; lead in L → byte-align by 16
    ld l,h                          ; A:HL shifted by 16 (hl = 0)
    ld d,16
    bit 7,a
    jr nz,normalised
    ; fall through to need_shift

    ; ---------------------------------------------------------------
    ; Normalization shifts of A:HL; D incremented by shifts (+1..7)
    ; A is 0x01..0x7F upon entry
    ; ---------------------------------------------------------------

.need_shift
    inc d                       ; ++shifts (to --exp)
    add hl,hl
    adc a,a                     ; A:HL << 1 and check for leading one
    bit 7,a
    jr z,need_shift             ; not leading yet, keep shifting

.normalised                     ; calculate final exp and prepare for packing
    ; A:HL = normalised 24b mant (A.7 = implicit 1); B = sign; C = exp
    add a,a                     ; drop implicit 1 → C, A = mant high << 1
    ld e,a
    ld a,c
    sub d                       ; a = final exp
    jr c,normzero

    ld d,a                      ; D = final exp (temp)
    ld a,b
    add a,a                     ; sign → C (B is 0 or 80h)
    ld a,d
    rra                         ; A = sign|exp
    ld d,a
    ld a,e
    rra                         ; last exp bit into E; mant bits without i1
    ld e,a
    ; DEHL: D = sign|exp, E = exp0|mant, H = mid, L = low
    ret

.normzero
    ld hl,0
    ld de,hl
    ret
