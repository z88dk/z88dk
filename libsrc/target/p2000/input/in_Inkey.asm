
SECTION bss_clib

_kbd_snapshot:  defs 9      ; Buffer for Rows 0-8
_kbd_shift:     defs 1      ; Buffer for Shift Key (Row 9)

SECTION code_clib

PUBLIC in_Inkey
EXTERN in_keytranstbl

; =============================================================================
; FUNCTION: in_Inkey
; =============================================================================
; C Prototype:
;   uint in_Inkey(void);
;
; Description:
;   Scans the keyboard to detect a single keypress, applying Shift modifiers.
;
;   - Keyboard Geometry:
;       Rows 0-8: Standard Character Keys (Active Low)
;       Row 9   : Shift Key (Port 0x09)   (Active Low)
;   - Logic:
;       If Shift is pressed, we add 72 (9 * 8) to the key index to jump
;       to the upper half of the translation table.
;
; Output:
;   - Single Key:      HL = ASCII Code, Carry = 0
;   - Shift+Key:       HL = Shifted ASCII Code, Carry = 0
;   - No Keys/Shift:   HL = 0, Carry = 0
;   - Multi Keys:      HL = 0, Carry = 1
; =============================================================================

in_Inkey:
    ; =========================================================================
    ;  CRITICAL SECTION: SNAPSHOT
    ; =========================================================================
    di                          ; Block interrupts
    xor a                       ; Note: Carry = 0
    out ($10), a                ; KBIEN OFF: Unlock Matrix for reading

    ld hl, _kbd_snapshot
    ld bc, $09FF                ; B = 9 (Rows), C = 0 (Start Port)

_snap_loop:
    inc c                       ; Next Port Index. C becomes 0, 1..2..8 (Does not touch Carry)
    ini                         ; (HL)=(C), HL++, B--. (16 T-States)
    jr  nz, _snap_loop

    ; --- Capture Shift (Row 9) ---
    ; At this point, C = 8
    inc c                       ; Now we are looking at the shift port
    in  a, (c)                  ; Read Shift Port
    ld  (_kbd_shift), a         ; Store it

    ; --- Restore Hardware ---
    ld a, $40
    out ($10), a                ; KBIEN ON: Restore ROM/Jiffy
    ei                          ; Enable Interrupts


    ; --- Setup our snapshot ---
    ; We use D to keep track which row the key is in
    ; We use the fact that Carry = 0, if no row has been
    ; detected.
    ld hl, _kbd_snapshot
    ld bc, $0900                ; B = 9 (Rows), C = 0 (Start Port)
    ld d, $FF                   ; Initialize to "No Row Found" (Sentinel)

_scan_loop:
    ld   a, (hl)            ; Get the row from our snapshot, note that a 0 bit --> key down
    inc  a                  ; Check for Empty ($FF -> 0)
    jr   z, _next_row       ; If Empty, skip logic (Fast Path)

    ; --- Key Detected ---
    ; Note: this is the only instruction that impacts the C flag.
    ; this will not be executed if we have not found a row.
    neg                     ; Convert $FE -> $01 (Active High Mask)
   
    ; 1. Check Multi-Row Collision, we have 2 cases:
    ; D is $FF (Empty) or $00-$08 (Found).
    inc  d                      ; If D=$FF -> 0 (Z Set). If D=Row -> Non-Zero (Z Clear).
    jr   nz, _err_exit          ; If Z Clear, we already found a row previously.

    ; 2. Store Row & Mask
    ld   d, c                   ; Store Row Index
    ld   e, a                   ; Store Mask

    ; 3. Check Multi-Key Collision (in same row)
    ; If only one key is pressed the byte is a power of 2, so we 
    ; we can use https://graphics.stanford.edu/~seander/bithacks.html#DetermineIfPowerOf2
    ; to detect if multiple keys are pressed.
    dec  a
    and  e                      ; (Mask & (Mask-1))  (Resets Carry)
    jr   nz, _err_exit          ; If Non-Zero, multiple bits set.

_next_row:
    inc  c
    inc  hl                 ; Next Port
    djnz _scan_loop         ; Loop 9 times

    ; --- Scan Done. Check Results ---
    ; Valid Row: D = 0..8
    ; No Key:    D = $FF
    inc d
    jr   z, _exit_none         ; $FF + 1 == 0? No row found
    dec d                      ; Undo the addition, D = the actual row again

    ; =========================================================================
    ; CALCULATE & SHIFT CHECK
    ; =========================================================================
    ; D = Row, E = Mask.
   
    ld   a, (_kbd_shift)    ; Read Shift (Port 9)
    inc  a                  ; Check for $FF, this sets Z flag.
    jr   z, _calc_index     ; Shift not pressed (a == 0)

    ; Shift IS pressed: Add 72 to offset
    ld   a, 72

_calc_index:
    ex af, af'                ; Save Shift Offset (Need register for calculation)
                           
    ; At this point, B contains the bit index (0-7) 
    ; and D contains the port/row index (0-8).
    
    ; OPTIMIZATION NOTE: We use the ADD A, A sequence to compute (Row * 8).
    ; While a 256-byte sparse lookup table or a Bit-to-Index table would 
    ; eliminate this math and the _bit_loop below, the current 
    ; implementation is more memory-efficient for the P2000T's constraints.
    
    ; Calculate Base Index = (Row * 8)
    ld   a, d
    add  a, a
    add  a, a
    add  a, a
    ld   d, a

    ; Calculate Bit Offset
    ld   b, 0
_bit_loop:
    srl  e
    jr   c, _found_bit
    inc  b
    jr   _bit_loop

_found_bit:
    ld   a, d               ; Base Row
    add  a, b               ; + Bit Offset
    ld   l, a               ; Temporary Index

    ex   af, af'            ; Restore Shift Offset (0 or 72)
    add  a, l               ; Add Shift Offset

    ; Lookup ASCII
    ; Note, if the table is 256 bit aligned we could do 
    ; ld hl, in_keytranstbl
    ; add a, l     
    ; ld l, a      
    ; ld l, (hl)   
    ; and save a +/- 10 T states (4us).

    ld   e, a
    ld   d, 0
    ld   hl, in_keytranstbl 
    add  hl, de
    ld   l, (hl)
    ld   h, 0

    ; --- Clean Exit (Success) ---
    or a                    ; Clear Carry
    ret

_err_exit:
    scf                     ; Set Carry (Error)
    
_exit_none:
    ; Note: the carry flag is guaranteed to be 0.
    ; the jump to _exit_none implies that D = $FF, which in
    ; turn implies that `neg` was never executed.
    ; or   a                  ; Clear Carry (No keys found)

_null_ret:
    ld   hl, 0              ; Common: HL = 0
    ret