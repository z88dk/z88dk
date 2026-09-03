;
;  feilipu, 2026 August
;  ped7g, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize - z80 / z180 / z80n normalisation
;-------------------------------------------------------------------------
;
;  unpacked: h==0 (discarded); mantissa=lde, sign in b, exponent in c
;
;  ex de,hl → E:HL; D = total left-shift count (byte align + residual).
;  Sign stays in B (no push).  Residual: jp m tree, add hl,hl / rl e.
;  Pack on E:HL like mul/sqr (sla e / rl b / rra / ld d,a / rr e).
;
;  af' unused for control flow.  Exit: ex af,af; ret (F' → public F).
;  Note: jr m/p do not exist; sign/parity branches stay jp.

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize


.m32_fsnormalize
    ex de,hl                    ; E = high, HL = mid:low
    ld d,0                      ; shift total

    ; ---------------------------------------------------------------
    ; Byte scan on E:HL and byte-alignment of it
    ; ---------------------------------------------------------------

    ld a,e
    or a
    jp m,normalised             ; already normalised (hot path)
    jr nz,need_shift            ; non-zero lead in E, D = 0, A:HL ready
    or h
    jr nz,need8                 ; non-zero lead in H, align by byte first
    or l
    jr z,normzero               ; all zeroes (no lead), return zero float

; .need16 ; A == L ; leading non zero is in L → exp -16
    ld l,h                      ; A:HL shifted by 16 (hl = 0)
    ld d,16
    jr bitshift_check           ; process byte-aligned non-zero lead

.need8
    ; A == H ; leading non zero is in H → exp -8
    ld h,l
    ld l,e                      ; A:HL shifted by 8 (l = 0)
    ld d,8
.bitshift_check                 ; check SF set by last `or` instruction
    jp m,normalised             ; normalised by 8/16 shift, pack it
    ; fall through to need_shift ; process byte-aligned non-zero lead

    ; ---------------------------------------------------------------
    ; Normalization shifts of A:HL; D incremented by shifts (+1..7)
    ; A is 0x01..0x7F upon entry (0x80+ → normalised, 0x00 → normzero)
    ; ---------------------------------------------------------------

.need_shift
    inc d                       ; ++shifts (to --exp)
    add hl,hl
    adc a,a                     ; A:HL << 1 and check for leading one
    jp p,need_shift             ; not leading yet, keep shifting

.normalised                     ; calculate final exp and prepare for packing
    add a,a                     ; drop implicit 1 (preparing mant for pack)
    ld e,a
    ; A = C − D (final exp); B = sign; E:HL = normalised mant
    ld a,c
    sub d                       ; a = final exp
    jr c,normzero
    jr z,normzero               ; FTZ: exp==0 is signed zero, not a denormal

; pack IEEE DEHL (mul/sqr style on E high)
    ; sla e ; implicit 1 was already dropped above
    rl b                        ; sign → C
    rra                         ; A = sign|exp
    ld d,a
    rr e                        ; last exp bit into E; mant bits without implicit 1
    ex af,af
    ret                         ; DEHL

.normzero
    ld hl,0                     ; signed zero (sign in B)
    ld e,l
    ld a,b
    and 080h
    ld d,a
    ex af,af
    ret
