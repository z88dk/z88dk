/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "hist.h"

#define VERSION     "2.8.5"
#define COPYRIGHT   "InterLogic 1993-2009, Paulo Custodio 2011-2017"

#ifdef QDOS
#include <qdos.h>

char _prog_name[] = "Z80asm";
char _version[] = VERSION;
char _copyright[] = "\x7f " COPYRIGHT;

void consetup_title();
void ( *_consetup )() = consetup_title;
int ( *_readkbd )( chanid_t, timeout_t, char * ) = readkbd_move;
struct WINDOWDEF _condetails =
{2, 1, 0, 7, 484, 256, 0, 0};
#endif

#ifdef AMIGA
char amiver[] = "$VER: z80asm " VERSION ", (c) " COPYRIGHT;
#endif

char copyrightmsg[] = "Z80 Module Assembler " VERSION ", (c) " COPYRIGHT;
