/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Returns the Y coordinate of the pen position. Returns valid result
 *  only if U0 is mapped to P0.
 *
 */

int __LIB__ gety() {
    return 959 - *((int *)0x0B7E);
}