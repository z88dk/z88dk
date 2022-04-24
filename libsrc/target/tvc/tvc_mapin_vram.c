#include <tvc.h>

void __LIB__ tvc_mapin_vram(void) {
    char mapping = *((int *)0x0003);
    mapping &= ~MMAP_P2_U2;
    tvc_set_memorymap(mapping);
}