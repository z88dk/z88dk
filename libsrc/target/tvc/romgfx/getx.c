/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Returns the X coordinate of the pen position. Returns valid result
 *  only if U0 is mapped to P0.
 *
 */

int __LIB__ getx() {
    return *((int *)0x0B7C);
}