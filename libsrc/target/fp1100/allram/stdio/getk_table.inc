; The key matrix rows 2 to 12 (bits 0 to 6) as ASCII, from MAME's src/mame/casio/fp1100.cpp (0: no ASCII value; DEL is 127, which getk returns as 12 like BS).  Letters are lower case unshifted
; and upper case shifted (CAPS swaps them); the pad keys give their characters; the yen key is 92; the cursor keys are the z88dk codes 8 (left), 9 (right), 10 (down), 11 (up) and BS is 12.  Generated, 7 bytes a row.

keymap_plain:
    defb    $61, $00, $2D, $71, $7A, $2A, $0D   ; row 2
    defb    $73, $31, $2B, $77, $78, $2F, $2C   ; row 3
    defb    $64, $32, $33, $65, $63, $7F, $2E   ; row 4
    defb    $66, $33, $36, $72, $76, $09, $30   ; row 5
    defb    $67, $34, $39, $74, $62, $00, $20   ; row 6
    defb    $68, $35, $38, $79, $6E, $0A, $30   ; row 7
    defb    $6A, $36, $35, $75, $6D, $0B, $32   ; row 8
    defb    $6B, $37, $34, $69, $2C, $00, $31   ; row 9
    defb    $6C, $38, $37, $6F, $2E, $08, $5D   ; row 10
    defb    $3B, $39, $0D, $70, $2F, $0C, $5B   ; row 11
    defb    $3A, $30, $5E, $5F, $40, $5C, $2D   ; row 12
keymap_shift:
    defb    $41, $00, $2D, $51, $5A, $2A, $0D   ; row 2
    defb    $53, $21, $2B, $57, $58, $2F, $2C   ; row 3
    defb    $44, $22, $33, $45, $43, $7F, $2E   ; row 4
    defb    $46, $23, $36, $52, $56, $09, $30   ; row 5
    defb    $47, $24, $39, $54, $42, $00, $20   ; row 6
    defb    $48, $25, $38, $59, $4E, $0A, $30   ; row 7
    defb    $4A, $26, $35, $55, $4D, $0B, $32   ; row 8
    defb    $4B, $27, $34, $49, $3C, $00, $31   ; row 9
    defb    $4C, $28, $37, $4F, $3E, $08, $7D   ; row 10
    defb    $2B, $29, $0D, $50, $3F, $0C, $7B   ; row 11
    defb    $2A, $30, $7E, $5F, $60, $7C, $3D   ; row 12
