# ADR 0121 — Signed constants sign-extend on conversion

Status: **Accepted**. A correctness fix, so it is **not gated**.

## Context

On this target `int` is 16 bits and `long` is 32 bits. Two constant-fold
rules disagreed with ISO C, and the two compilers disagreed with each other.

An unsuffixed decimal such as `32768`, `40000`, or `65535` was kept as
`int`. Hex `0x8000` is the constant that stays `unsigned int`. A fitted
folded long was then pushed as 16 bits, so `%ld` of `32768` read the next
stack word. `65536 - (16384 * 2)` was reported as 32768.

Signed overflow was stored two ways. sccz80 zero-extended when the type
widened, so `1L + (3 - 5)` was 65535 and `(long)(16384 * 2)` was 32768.
80cc sign-extended in a cast and zero-extended in addition, so
`(long)(16384 * 2)` was -32768 while `65536 - (16384 * 2)` was 32768.

## Decision

Follow the integer conversion rules. The same rules apply in both front ends.

- An unsuffixed decimal constant has type `int` if it fits in signed `int`,
  otherwise `long`. `32768` is `long`. `32768U` fits in `unsigned int` and
  stays there. A hex, octal, or binary constant that fits in `unsigned int`
  stays `unsigned int`, so `0x8000` is 32768 and `(long)0x8000` is 32768.
- The operation is done in the result type. Signed overflow wraps two's
  complement in that type. `16384 * 2` and `32767 + 1` are -32768.
  `-(16384 * 2)` wraps again and is still -32768.
- A conversion then widens. A signed source sign-extends. An unsigned source
  zero-extends. `(long)(16384 * 2)` is -32768. `65536 - (16384 * 2)` is
  98304. `1L + (3 - 5)` is -1. `1L + (int)-1` is 0.
  `(signed char)200` is -56, and `1L + (signed char)200` is -55.
- A right shift of a negative signed value is the existing arithmetic shift.
  `(16384 * 2) >> 1` is -16384. The count's type does not change that, so
  `(16384 * 2) >> 1u` is also -16384.
- `/` and `%` convert both operands to the result type before the operation.
  `(-1) / 2u` is 32767. `(-1L) / 0x8000` is 0. A `char` promotes to `int`
  first, so `(unsigned char)200 / (signed char)-2` is -100.
- Unary `~` and unary `-` promote a `char` to `int` before the operation.
  `(long)~(unsigned char)0` is -1. `(long)-(unsigned char)200` is -200.
  `&&` and `||` yield `int`.
- A pointer difference counts elements. `(int *)10 - (int *)4` is 3.
  `(char *)10 - (char *)4` is 6.
- Default argument promotions do not narrow a `long`. `printf("%ld", 32768)`
  pushes four bytes. A prototype still converts: `unsigned int` keeps the
  low 16 bits of 98304, which are 32768.

Two results are refused. Copying the old sccz80 value `1L + (3 - 5) == 65535`
keeps a zero-extend of a negative. Narrowing a fitted long so that `%u` prints
32768 makes `%ld` of that same long undefined. `%u` of a `long` is a format
mismatch. The unsigned result is `(unsigned)(65536 - (16384 * 2))`.

`-compiler=multi` stitches one value per function. The two front ends must
agree on these constants.

## Consequences

`test/suites/sccz80/constpush.c` runs for sccz80 and for 80cc. It checks the
values above, the 32-bit push of a decimal long, the unsigned-int cast, a
prototype conversion, a fastcall long, mixed `/` and `%`, a `char` promotion,
and a signed right shift whose count is unsigned.
