include(__link__.m4)

#ifndef _ARCH_H
#define _ARCH_H

// machine constants may go here

#ifdef __CPM
#include <arch/cpm.h>
#endif

#ifdef __SPECTRUM
#include <arch/zx.h>
#endif

#endif
