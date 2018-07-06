#include <arch/zxn/esxdos.h>
#include "globals.h"

// initial state

unsigned char cwd[ESX_PATHNAME_MAX];

// details on program being loaded

unsigned char fin = 0xff;                       // open file handle
unsigned char program_name[ESX_PATHNAME_MAX];   // full path to program
unsigned char *command_line;                    // command line to be passed to program

// path loaded from environment

unsigned char PATH[512];

// buffer space

unsigned char buf[64];
