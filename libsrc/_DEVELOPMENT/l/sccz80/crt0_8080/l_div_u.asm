
SECTION code_crt0_sccz80

PUBLIC l_div_u
; HL = DE / HL, DE = DE % HL
l_div_u:
	LD      b,h             ; store divisor to bc
        LD      c,l
        LD     HL,0             ; clear remainder
        XOR     a               ; clear carry
        LD      a,17            ; load loop counter
        PUSH    AF
ccduv1: LD      a,e             ; left shift dividend into carry
        RLA
        LD      e,a
        LD      a,d
        RLA
        LD      d,a
        JP      C,ccduv2          ; we have to keep carry -> calling else branch
        POP     AF             ; decrement loop counter
        DEC     a
        JP      Z,ccduv5
        PUSH    AF
        XOR     a               ; clear carry
        JP     ccduv3
ccduv2: POP     AF             ; decrement loop counter
        DEC     a
        JP      Z,ccduv5
        PUSH    AF
        SCF                     ; set carry
ccduv3: LD      a,l             ; left shift carry into remainder
        RLA
        LD      l,a
        LD      a,h
        RLA
        LD      h,a
        LD      a,l             ; substract divisor from remainder
        sub     c
        LD      l,a
        LD      a,h
        SBC     b
        LD      h,a
        JP      NC,ccduv4          ; if result negative, add back divisor, clear carry
        LD      a,l             ; add back divisor
        ADD     A,c
        LD      l,a
        LD      a,h
        ADC     A,b
        LD      h,a
        XOR     a               ; clear carry
        JP     ccduv1
ccduv4: SCF                     ; set carry
        JP     ccduv1
ccduv5: EX      DE,HL
        ret
