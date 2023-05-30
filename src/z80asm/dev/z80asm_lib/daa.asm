;------------------------------------------------------------------------------
; Z88DK Z80 Macro Assembler
;
; DAA emulation for Rabbit - based on the Fuse implementation
;
; Copyright (C) Paulo Custodio, 2011-2023
; License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
; Repository: https://github.com/z88dk/z88dk
;------------------------------------------------------------------------------


  IF    __CPU_RABBIT__
        SECTION code_l_sccz80
        PUBLIC  __z80asm__daa

__z80asm__daa:
        push    bc
        push    af
        ex      (sp), hl                ; H is A, L is F

; libspectrum_byte add = 0, carry = ( F & FLAG_C );
        ld      bc, 0                   ; B = add
        rl      c                       ; C = 1 if carry, 0 otherwise

; if( ( F & FLAG_H ) || ( ( A & 0x0f ) > 9 ) ) add = 6;
        bit     4, l                    ; check H
        jr      nz, t1_true

        ld      a, h
        and     $0F
        cp      9+1                     ; A >= 10 -> no carry
        jr      c, t1_cont

t1_true:
        ld      b, 6                    ; add = 6

t1_cont:

; if( carry || ( A > 0x99 ) ) add |= 0x60;
        bit     0, c                    ; check carry
        jr      nz, t2_true

        ld      a, h
        cp      0x99+1
        jr      c, t2_cont

t2_true:
        ld      a, 0x60
        or      b
        ld      b, a

t2_cont:

; if( A > 0x99 ) carry = FLAG_C;
        ld      a, h
        cp      0x99+1
        jr      c, t3_cont

t3_true:
        set     0, c                    ; store carry=1 in C

t3_cont:

; if( F & FLAG_N ) { SUB(add); } else { ADD(add); }
        bit     1, l                    ; check N

        ld      a, h                    ; prepare to add/subtract
        jr      z, t4_zero

t4_one:
        sub     b
        jr      t4_cont

t4_zero:
        add     a, b

t4_cont:
        ld      h, a

; F = ( F & ~( FLAG_C | FLAG_P ) ) | carry | parity_table[A];
        ld      a, l
        and     ~$01                    ; clear C
        or      $04                     ; set P/V (even = 1, odd = 0)
        or      c                       ; | carry
        ld      l, a

        ld      b, $80
parity_loop:
        ld      a, h
        and     b                       ; check each bit
        jr      z, bit0

        ld      a, l
        xor     $04                     ; invert parity bit
        ld      l, a
bit0:
        rr      b
        jr      nc, parity_loop

; set zero flag
        ld      a, h
        and     a
        jr      nz, not_z

        set     6, l                    ; set Z flag
not_z:

; set sign flag
        bit     7, h
        jr      z, positive

        set     7, l                    ; set S flag
positive:

; return
        ex      (sp), hl
        pop     af
        pop     bc
        ret
  ENDIF
