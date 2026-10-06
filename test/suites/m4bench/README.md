# M4 FORTH benchmark kernels

This suite contains small C adaptations of selected kernels from
[DW0RKiN/M4_FORTH_Benchmark](https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark).

Original benchmark repository and copyright:

```text
Copyright (c) 2024 DW0RKiN
https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark
```

The original repository is released under the MIT License. The kernels here
are adapted for the z88dk test framework: they use bounded workloads and
host-verified assertions instead of the original console output and timing
harness.

The first import covers these individual benchmark rows:

- GCD
- bitcount
- Josephus
- Kadane
- 100 doors
- memory access
- VCFe 24.0 arithmetic, logic, and nesting
- the portable pangram kernel

The large 64-bit, long-running constant-division, and ZX-specific
inline-assembly variants remain outside this suite for now.

The original license text is:

```text
MIT License

Copyright (c) 2024 DW0RKiN

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
