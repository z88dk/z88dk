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

SECTION code_crt0_sccz80
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
IF __CPU_GBZ80__
        ld    hl,__retloc
        ld    a,(hl+)
        ld    h,(hl)
        ld    l,a
ELSE
        ld    hl,(__retloc)
ENDIF
    push  hl
    ld    hl,0
    ld    de,0
    jp    error_divide_by_zero_mc

l_long_divide:
    ld    (__div32_mode),A
IF __CPU_GBZ80__
        ld    b,h
        ld    a,l
        ld    hl,__math_block3
        ld    (hl+),a
        ld    a,b
        ld    (hl+),a
        ld    a,e
        ld    (hl+),a
        ld    a,d
        ld    (hl+),a
ELSE
        ld    (__math_block3),hl
        ex    de,hl
        ld    (__math_block3+2),hl
ENDIF
IF __CPU_GBZ80__
        pop    de
        ld    hl,__retloc
        ld    a,e
        ld    (hl+),a
        ld    a,d
        ld    (hl+),a
        pop    de        ;store divisor
        ld    hl,__math_block1
        ld    a,e
        ld    (hl+),a
        ld    a,d
        ld    (hl+),a
        pop    de
        ld    a,e
        ld    (hl+),a
        ld    a,d
        ld    (hl+),a
ELSE
        pop   hl        ;return address
        ld    (__retloc),hl
        pop   hl            ; store divisor
        ld    (__math_block1),HL
        pop   hl
        ld    (__math_block1+2),HL
ENDIF
    ld    hl,__math_block3
IF __CPU_GBZ80__
        ld    a,(hl+)
ELSE
        ld    a,(hl)
        inc   hl
ENDIF
    or    (hl)
    inc   hl
    or    (hl)
    inc   hl
    or    (hl)
    jp    z,divide_zero
IF __CPU_GBZ80__
    ld    hl,__math_block2
    xor   a
    ld    (hl+),a
    ld    (hl+),a
    ld    (hl+),a
    ld    (hl+),a
ELSE
    ld    hl, 0            ; store initial value of remainder
    ld    (__math_block2),hl
    ld    (__math_block2+2),hl
ENDIF

    ld    b,0
    ld    a,(__div32_mode)
    rla
    jp    nc,do_unsigned            ; jump if unsigned

    ; Considering signed values here
    ld    a,(__math_block1+3)        ;Check sign of dividend
    rla
    jp    nc,dividend_not_signed
    ld    b,129
    ld    hl, __math_block1
    call  compl        ; dividend is positive now

dividend_not_signed:
    ld    a,(__math_block3+3)
    rla
    jp    nc,do_unsigned    ;Just carry on
    inc   b
    ld    hl, __math_block3
    call  compl        ; divisor is positive now

do_unsigned:    
    push  bc            ; save b-reg
    ld    b,32

dv0:    
    ld    hl,__math_block1        ; left shift: __math_block2 <- __math_block1 <- 0
    ld    c,2
    xor   a
shift:
IF __CPU_GBZ80__
        rl    (hl)
        inc   hl
        rl    (hl)
        inc   hl
        rl    (hl)
        inc   hl
        rl    (hl)
        inc   hl
ELSE
        ld    a,(hl)
        rla
        ld    (hl),a
        inc   hl
        ld    a,(hl)
        rla
        ld    (hl),a
        inc   hl
        ld    a,(hl)
        rla
        ld    (hl),a
        inc   hl
        ld    a,(hl)
        rla
        ld    (hl),a
        inc   hl
ENDIF
    dec   c
    jp    nz,shift


    ld    hl,__math_block2+3        ; which is larger: divisor or remainder?
    ld    de,__math_block3+3
    ld    c,4
loop:
    ld    a,(de)
    cp    (hl)
    jp    z,again
    jp    nc,continue
    jp    do_subtract
again:    
    dec   de
    dec   hl
    dec   c
    jp    nz,loop

do_subtract:
    ld    de,__math_block2        ; remainder is larger or equal: subtract divisor
    ld    hl,__math_block3
    ld    c,2
    xor   a
loop2:    
    ld    a,(de)
    sbc   (hl)
    ld    (de),a
    inc   de
    inc   hl
    ld    a,(de)
    sbc   (hl)
    ld    (de),a
    inc   de
    inc   hl
    dec   c
    jp    nz,loop2    
    ld    hl,__math_block1
    inc   (hl)

continue:
    dec   b
    jp    nz,dv0            ; keep looping

    pop   bc
    ld    a,(__div32_mode)        ; quotient or remainder?
    rra
    jp    nc,return_modulus

; for dvi 4 and dvu 4 only:
    ld    a,b
    rra
    ld    hl, __math_block1        ; complement quotient if divisor
    call  c,compl        ; and dividend have different signs
;    ld    a,b
;    rla
;    ld    hl, __math_block2
;    call  C,compl        ; negate remainder if dividend was negative
IF __CPU_GBZ80__
    ld    hl,__retloc
    ld    a,(hl+)
    ld    h,(hl)
    ld    l,a
    push  hl
    ld    hl,__math_block1+3
    ld    a,(hl-)
    ld    d,a
    ld    a,(hl-)
    ld    e,a
    ld    a,(hl-)
    ld    l,(hl)
    ld    h,a
ELSE
    ld    hl,(__retloc)
    push  hl
    ld    hl, (__math_block1+2)        ; push quotient
    ex    de,hl
    ld    hl, (__math_block1)
ENDIF
    ret

; for rmi 4 and rmu 4 only:
return_modulus:
;    ld    a,b
;    rra
;    ld    hl, __math_block1        ; complement quotient if divisor
;    call  c,compl        ; and dividend have different signs
    ld    a,b
    rla
    ld    hl, __math_block2
    call  c,compl        ; negate remainder if dividend was negative
IF __CPU_GBZ80__
    ld    hl,__retloc
    ld    a,(hl+)
    ld    h,(hl)
    ld    l,a
    push  hl
    ld    hl,__math_block2+3
    ld    a,(hl-)
    ld    d,a
    ld    a,(hl-)
    ld    e,a
    ld    a,(hl-)
    ld    l,(hl)
    ld    h,a
ELSE
    ld    hl,(__retloc)
    push  hl
    ld    hl, (__math_block2+2)
    ex    de,hl
    ld    hl, (__math_block2)
ENDIF
    ret

; make 2's complement of 4 bytes pointed to by hl.
compl:    
    push  bc
    ld    c,4
    xor   a
compl1:    
    ld    a,0
    sbc   (HL)
    ld    (HL),a
    inc   HL
    dec   c
    jp    nz,compl1
    pop   bc
    ret

    SECTION     bss_crt

__div32_mode:    defb    0
