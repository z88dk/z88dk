Generates the floating point library "math32" bridging to math32.
On the compile line "-lmath32" will connect the compilers to math32.

Products match the classic math32 CPU libraries: math32.lib (z80),
math32_z80n.lib, math32_r2ka.lib, math32_r4k.lib, math32_r6k.lib.
z80asm pulls only members whose CPU matches -m. Newlib zcc maps
-lmath32 to math32_<cpu> for those CPUs.
