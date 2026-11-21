#include <arch/zxn.h>

/* Constant nextreg, register-in-A nextreg, and the port forms.
   Each one is a call in the compiler output and a longer sequence
   after the intrinsic rules. */
unsigned char shapes(unsigned char n, unsigned char v)
{
    ZXN_NEXTREG(0x07, 0x03);
    ZXN_NEXTREGA(0x07, v);
    ZXN_WRITE_REG(n, v);
    return ZXN_READ_REG(n);
}

/* The true arm is a straight run of ZXN_READ_REG calls. A jr chosen
   while those calls are still 3 bytes is out of range once each call
   becomes the port sequence. The branch has to stay jp, or be chosen
   after the expansion. */
unsigned char span(unsigned char sel)
{
    unsigned char a;

    if (sel) {
        a = ZXN_READ_REG(0);
        a += ZXN_READ_REG(1);
        a += ZXN_READ_REG(2);
        a += ZXN_READ_REG(3);
        a += ZXN_READ_REG(4);
        a += ZXN_READ_REG(5);
        a += ZXN_READ_REG(6);
        a += ZXN_READ_REG(7);
        a += ZXN_READ_REG(8);
        a += ZXN_READ_REG(9);
        a += ZXN_READ_REG(10);
        a += ZXN_READ_REG(11);
        a += ZXN_READ_REG(12);
        a += ZXN_READ_REG(13);
        a += ZXN_READ_REG(14);
        a += ZXN_READ_REG(15);
        a += ZXN_READ_REG(16);
        a += ZXN_READ_REG(17);
        a += ZXN_READ_REG(18);
        a += ZXN_READ_REG(19);
    } else {
        a = 0;
    }
    return a;
}
