; Console on port 1, and the ticks iotimer read on port 2.
; __z88dk_fastcall leaves the argument in L.
; z180 and zxn newlib do not link z80_outp.

    SECTION code_compiler

    PUBLIC _bench_putc
    PUBLIC _bench_putc_fastcall
    PUBLIC _bench_in2
    PUBLIC _bench_in2_fastcall

_bench_putc:
_bench_putc_fastcall:
    ld      a,l
    out     (1),a
    ret

_bench_in2:
_bench_in2_fastcall:
    in      a,(2)
    ld      l,a
    ld      h,0
    ret
