SECTION code_clib

PUBLIC in_KeyPressed

; -----------------------------------------------------------------------------
; uint in_KeyPressed(uint scancode) __z88dk_fastcall
;
; Checks if a specific key is currently pressed by performing a direct,
; safe hardware read of the specific row required.
;
; Note: This will never check the <shift> key
;
; Input:
;   L = Key Mask (bitmask for the key within its row)
;   The assumption is that "L is a power of 2" and 
;   only a single key is selected
;   H = Row Index (0-8)
;
; Output:
;   HL = 1 if the key is pressed, 0 otherwise.
;   Carry flag is set if pressed, not set if not pressed.
;
; Implementation:
;   Performs a fast, interrupt-safe read of a single keyboard row.
; -----------------------------------------------------------------------------
in_KeyPressed:
    ; We must disable interrupts and toggle Port $10 (KBIEN) to
    ; prevent the Monitor ROM from interfering with our I/O read.
    di
    xor  a                  ; A = 0
    out  ($10), a           ; KBIEN OFF: We want to read individual rows.

    ld   c, h               ; C = Port address (Rows are mapped to ports 0-8)
    in   a, (c)             ; PHYSICAL READ: State of the keyboard row

    ld   bc, $4010           ; B = $40 (KBIEN ON value), C = $10 (Port)
    out  (c), b              ; KBIEN ON, expected by the rom.
    ei

    ; Hardware returns 0 for 'pressed' (active low). We want 1 for 'pressed'.
    and  l                  ; Isolate the specific key bit.
                            ; Result A is now:
                            ;   0   (Key Pressed / Active Low)
                            ;   L   (Key Released / Active High)

    ; LOGIC: Map 0 -> 1 and L -> 0 without jumping.
    add  a, $FF             ; Step 1: Generate Carry based on Zero/Non-Zero
                            ;   If A=0 (Pressed):  0 + 255 = 255. Carry = 0.
                            ;   If A=L (Released): L + 255 > 255. Carry = 1.

    sbc  a, a               ; Step 2: Broadcast Carry to all bits (0 - Carry)
                            ;   If Carry=0: 0 - 0 = $00
                            ;   If Carry=1: 0 - 1 = $FF (-1)

    inc  a                  ; Step 3: Shift Result to 0/1
                            ;   If A=$00 (Pressed):  0 + 1 = 1.
                            ;   If A=$FF (Released): 255 + 1 = 0 (Overflows).
    ld   l, a
    ld   h, 0
    
    add  a, $FF             ; Restore Carry flag for Caller (1=Pressed, 0=Released)
    ret