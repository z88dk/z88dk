SECTION code_clib

PUBLIC in_JoyKeyboard

; =============================================================================
; FUNCTION: in_JoyKeyboard
; =============================================================================
; C Prototype:
;   uint in_JoyKeyboard(struct in_UDK *u) __z88dk_fastcall;
;
; Description:
;   Simulates a joystick by reading specific keyboard keys defined in a
;   user-provided structure.
;
; Note: This will never check the <shift> key
;
; Input (Fastcall Convention):
;   HL = Pointer to 'struct in_UDK'
;        Structure Layout in memory (5 entries, 2 bytes each):
;        1. FIRE  (Mask, Port)
;        2. RIGHT (Mask, Port)
;        3. LEFT  (Mask, Port)
;        4. DOWN  (Mask, Port)
;        5. UP    (Mask, Port)
;
; Output:
;   HL = Joystick State in LSB (Format: F000RLDU)
;        Bit 7: Fire
;        Bit 3: Right
;        Bit 2: Left
;        Bit 1: Down
;        Bit 0: Up
;        (Active High: 1 = Pressed)
;
; Hardware Constraints & Hazards:
;   1. INTERRUPTS: Must be disabled (DI) to prevent ISR interference while
;      the hardware matrix is unlocked.
;   2. KBIEN ($10): Writing 0 to port $10 is required to unlock the raw
;      keyboard matrix. Writing $40 restores normal Monitor/ROM functions.
;
; Implementation Strategy:
;   1. Process FIRE (Bit 7) first. Save the result on the STACK (PUSH AF).
;      This frees up registers so the main loop can run without stack overhead.
;   2. Loop 4 times for directions (RLDU). Accumulate bits into Register E.
;   3. POP FIRE from stack, combine with E, and return.
; =============================================================================

in_JoyKeyboard:
    di                      ; CRITICAL: Block interrupts
    xor  a
    out  ($10), a           ; KBIEN OFF: Unlock hardware keyboard matrix

    ; -------------------------------------------------------------------------
    ; STEP 1: Process FIRE (Bit 7)
    ; -------------------------------------------------------------------------
    ; We handle Fire separately because it is Bit 7, while directions are 0-3.
    ; We use B and C as temporary registers here since the loop hasn't started.

    ld   b, (hl)            ; Load Fire Mask
    inc  hl
    ld   c, (hl)            ; Load Fire Port
    inc  hl                 ; Advance HL to point to 'Right' entry

    in   a, (c)             ; Read Hardware (must use A, not B)
    cpl                     ; Invert (Active Low -> Active High)
    and  b                  ; Apply Mask
    add  a,$FF              ; If (A & Mask) > 0, Carry Flag = 1

    sbc  a, a               ; If Carry=1 -> A=0xFF. If Carry=0 -> A=0x00.
    and  $80                ; Isolate Bit 7 (F0000000)

    ex   af,af'             ; This frees up registers DE/BC for the loop below.

    ; -------------------------------------------------------------------------
    ; STEP 2: Process Directions Loop (Right, Left, Down, Up)
    ; -------------------------------------------------------------------------
    ld   b, 4               ; Loop Counter (4 Directions)
    ld   e, 0               ; Accumulator (Will hold 0000RLDU)

JoyLoop:
    ld   d, (hl)            ; Load Mask into D (Safe: Fire is on stack)
    inc  hl
    ld   c, (hl)            ; Load Port into C
    inc  hl

    in   a, (c)             ; Read Hardware
    cpl                     ; Invert to Active High
    and  d                  ; Apply Mask
    add  a, $FF             ; Set Carry Flag if Pressed

    rl   e                  ; ROTATE LEFT: Shifts previous bits left and
                            ; moves current Carry Flag into Bit 0.
                            ; 1. Right -> .......R
                            ; 2. Left  -> ......RL
                            ; 3. Down  -> .....RLD
                            ; 4. Up    -> ....RLDU

    djnz JoyLoop            ; Decrement B, Loop if not 0

    ; -------------------------------------------------------------------------
    ; STEP 3: Combine and Return
    ; -------------------------------------------------------------------------
    ex   af, af'            ; RESTORE FIRE from Stack (A = F0000000)
    or   e                  ; Merge with Directions   (A = F000RLDU)

    ld   l, a               ; Set Return Value Low Byte
    ld   h, 0               ; Set Return Value High Byte

    ld   a, $40
    out  ($10), a           ; KBIEN ON: Restore Monitor/ROM state
    ei                      ; Restore Interrupts
    ret
