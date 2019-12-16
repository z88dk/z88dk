#include <tvc.h>

extern void __LIB__ tvc_set_bordercolor(int c);

void tvc_set_border(enum colors c) {
    tvc_set_bordercolor(c<<1);
}
