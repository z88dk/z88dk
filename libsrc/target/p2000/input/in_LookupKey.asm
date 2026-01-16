SECTION code_clib

PUBLIC in_LookupKey
EXTERN in_keytranstbl

; -----------------------------------------------------------------------------
; uint in_LookupKey(uchar c) __z88dk_fastcall
;
; Converts an ASCII character into a 16-bit hardware scancode.
;
; Note: This will never include the <shift> key
;
; Input:
;   L = ASCII character to look up.
;
; Output:
;   HL = 16-bit scancode (H=Row, L=Mask).
;        Returns 0 if the character is not on the keyboard map.
;
; Implementation:
;   Performs a linear search through 'in_keytranstbl' to find the
;   matching ASCII code, then calculates the row and bitmask from its
;   index in the table.
; -----------------------------------------------------------------------------
in_LookupKey:
    ld   a, l               ; L contains the character (fastcall)
    ld   hl, in_keytranstbl
    ld   bc, 144
    cpir                    ; Linear Search
    jr   nz, _lk_fail       ; If not found, return 0

    ; --- 1. Calculate Index ---
    ; CPIR ends with HL = MatchAddr + 1.
    ; Index = HL - StartAddr - 1.
    ld   de, in_keytranstbl
    or   a                  ; Clear Carry
    sbc  hl, de             ; HL = Index + 1
    dec  hl                 ; HL = Index (0-143)

    ; --- 2. Normalize Index ---
    ; If Index >= 72, it's the shifted half of the keyboard.
    ld   a, l               ; Index is < 144, so L is sufficient
    cp   72
    jr   c, _lk_calc
    sub  72                 ; Normalize to 0-71 range
_lk_calc:
    ld   c, a               ; C = Normalized Index (0-71)

    ; --- 3. Calculate Row (H) ---
    ; Row = Index / 8
    srl  a
    srl  a
    srl  a                  ; A = Index >> 3 (same as Index / 8)
    ld   h, a               ; H = Row (0 to 8)

    ; --- 4. Calculate Mask (L) ---
    ld   a, c               ; Restore Index
    and  $07                ; A = bit position (0 to 7)
    ld   b, a               ; B = Shift Counter
    ld   a, 1               ; Start with Bit 0 set

    jr   z, _lk_done        ; If B was 0, skip shifting

_lk_shift:
    add  a, a               ; 1 << B
    djnz _lk_shift

_lk_done:
    ld   l, a               ; L = Bitmask
    ret

_lk_fail:
    ld   hl, 0              ; Return 0 (Not Found)
    ret
