
SECTION code_fp_math32

PUBLIC ___fscmp

EXTERN m32_compare_callee

; xcc's three-way float compare. Its contract is NOT sdcc's — sdcc asks for
; ___fslt / ___fsgt / ___fseq and gets a boolean; xcc emits one ___fscmp and
; tests the result itself.
;
; Entry: dehl = a, with DE the LOW half and HL the HIGH half (xcc's order,
;               the opposite of math32's)
;        stack: ret, a_low_of_b .. i.e. float b pushed high word first, so it
;               sits little-endian at (sp+2)
;
; Exit:  de = -1 if a < b, 0 if a == b, +1 if a > b
;        b is removed from the stack — xcc emits the pushes in FRAMELESS
;        functions and never cleans up after the call, so the callee must.
;
; m32_compare_callee takes its RIGHT operand in dehl (DE high, HL low) and its
; LEFT operand on the stack under two return addresses, and it eats the left
; operand on the way out. That is this frame exactly once `call` has pushed the
; second return address, with a as the right and b as the left — so the sense
; of its carry is reversed here: C means b < a, which is a > b.
;
; Uses: af, bc, de, hl and the alternate bank (via m32_compare_callee).
;       ix and iy are untouched, which is what the caller's frame needs.

___fscmp:
    ex de,hl                    ; de = a high, hl = a low — math32's order
    call m32_compare_callee     ; z = equal, c = b < a
    ld de,0
    ret z
    jr c,fscmp_greater
    dec de                      ; a < b
    ret
fscmp_greater:
    inc de                      ; a > b
    ret
