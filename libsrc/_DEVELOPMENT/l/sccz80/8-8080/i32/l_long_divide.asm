;Copyright (c) 1987, 1990, 1993, 2005 Vrije Universiteit, Amsterdam, The Netherlands.
;All rights reserved.
;
;Redistribution and use of the Amsterdam Compiler Kit in source and
;binary forms, with or without modification, are permitted provided
;that the following conditions are met:
;
;   * Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;
;   * Redistributions in binary form must reproduce the above
;     copyright notice, this list of conditions and the following
;     disclaimer in the documentation and/or other materials provided
;     with the distribution.
;
;   * Neither the name of Vrije Universiteit nor the names of the
;     software authors or contributors may be used to endorse or
;     promote products derived from this software without specific
;     prior written permission.
;
;THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS, AUTHORS, AND
;CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
;INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
;MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
;IN NO EVENT SHALL VRIJE UNIVERSITEIT OR ANY AUTHORS OR CONTRIBUTORS BE
;LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
;BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
;OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
;EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_divide
EXTERN    error_divide_by_zero_mc
EXTERN __retloc, __math_block1, __math_block3, __math_block2

; 32 bits integer divide and remainder routine
; Bit 0 of a-reg is set iff quotient has to be delivered
; Bit 7 of a-reg is set iff the operands are signed, so:
; Expects in a-reg:    0 if called by rmu 4
;            1 if called by dvu 4
;            128 if called by rmi 4
;            129 if called by dvi 4
; Divisor = dehl
; Dividend = under one return address
; Returns: dehl = result (modulus or quotient)

divide_zero:
    ld      hl,(__retloc)
    push    hl
    ld      hl,0
    ld      de,hl
    jp      error_divide_by_zero_mc

l_long_divide:
    ld      (__div32_mode),A
    ld      (__math_block3),hl
    ld      a,h    ;0 divisor check
    or      l
    ex      de,hl
    ld      (__math_block3+2),hl
    or      h
    or      l

    pop     hl        ;return address
    ld      (__retloc),hl
    pop     hl            ; store dividend
    ld      (__math_block1),HL
    pop     hl
    ld      (__math_block1+2),HL
    jp      Z,divide_zero

    ld      hl, 0            ; store initial value of remainder
    ld      (__math_block2),hl
    ld      (__math_block2+2),hl


    ld      b,0
    ld      a,(__div32_mode)
    rla
    jp      NC,do_unsigned            ; jump if unsigned

    ; Considering signed values here
    ld      a,(__math_block1+3)        ;Check sign of dividend
    rla
    jp      NC,dividend_not_signed
    ld      b,129
    ld      hl, __math_block1
    call    compl        ; dividend is positive now

dividend_not_signed:
    ld      a,(__math_block3+3)
    rla
    jp      NC,do_unsigned    ;Just carry on
    inc     b
    ld      hl, __math_block3
    call    compl        ; divisor is positive now

do_unsigned:    
    push    bc            ; save b-reg
    ld      b,32

dv0:    
    ld      hl,__math_block1        ; left shift: __math_block2 <- __math_block1 <- 0
    xor     a
shift:
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    rla
    ld      (hl),a


    ld      hl,__math_block2+3        ; which is larger: divisor or remainder?
    ld      de,__math_block3+3
    ld      c,4
loop:
    ld      a,(de)
    cp      (hl)
    jp      Z,again
    jp      NC,continue
    jp      do_subtract

again:
    dec     de
    dec     hl
    dec     c
    jp      NZ,loop

do_subtract:
    ld      de,__math_block2        ; remainder is larger or equal: subtract divisor
    ld      hl,__math_block3
    xor     a
    ld      a,(de)
    sbc     (hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     (hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     (hl)
    ld      (de),a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     (hl)
    ld      (de),a
    ld      hl,__math_block1
    inc     (hl)

continue:
    dec     b
    jp      NZ,dv0            ; keep looping

    pop     bc
    ld      a,(__div32_mode)        ; quotient or remainder?
    rra
    jp      NC,return_modulus

; for dvi 4 and dvu 4 only:
    ld      a,b
    rra
    ld      hl, __math_block1        ; complement quotient if divisor
    call    C,compl        ; and dividend have different signs
    ld      a,b
    rla
    ld      hl, __math_block2
    call    C,compl        ; negate remainder if dividend was negative
    ld      hl,(__retloc)
    push    hl
    ld      hl, (__math_block1+2)        ; push quotient
    ex      de,hl
    ld      hl, (__math_block1)
    ret

; for rmi 4 and rmu 4 only:
return_modulus:
    ld      a,b
    rra
    ld      hl, __math_block1        ; complement quotient if divisor
    call    C,compl        ; and dividend have different signs
    ld      a,b
    rla
    ld      hl, __math_block2
    call    C,compl        ; negate remainder if dividend was negative
    ld      hl,(__retloc)
    push    hl
    ld      hl, (__math_block2+2)
    ex      de,hl
    ld      hl, (__math_block2)
    ret

; make 2's complement of 4 bytes pointed to by hl.
compl:    
    push    bc
    ld      c,4
    xor     a
compl1:    
    ld      a,0
    sbc     (hl)
    ld      (hl),a
    inc     hl
    dec     c
    jp      NZ,compl1
    pop     bc
    ret

    SECTION     bss_crt

__div32_mode:    defb    0
