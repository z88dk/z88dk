#ifndef DISASSEMBLER_H
#define DISASSEMBLER_H

#include <stddef.h>

extern int disassemble2(int pc, char *buf, size_t buflen, int compact);

extern int c_autolabel;

#endif