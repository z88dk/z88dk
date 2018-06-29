

#ifndef __ARCH_MULTI8_H__
#define __ARCH_MULTI8_H__

extern int __LIB__ tape_load();

// Load the palette
extern void __LIB__ load_palette(unsigned char *data, int index, int count) __smallc;

#endif
