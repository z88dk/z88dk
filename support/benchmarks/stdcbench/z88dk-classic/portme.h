/* A portme.h for z88dk +test.
   Same role as examples/portme.h.SDCC-Z80 and examples/portme.h.SDCC-R2K:
   clock type, tick rate, and which modules are built.

   +test has no board tick interrupt and no Rabbit RTC. The normal run
   times one iteration with TIMER labels (see portme.c). STDCBENCH_IOTIMER
   reads the ticks cycle counter instead, at 100000 counts per second
   when the CPU is taken as 4 MHz. */

#ifndef PORTME_H
#define PORTME_H

typedef unsigned long stdcbench_clock_t;

#ifdef STDCBENCH_IOTIMER
/* T-states / 40. 1000 * SECONDS then fits in a 32-bit long. */
#define STDCBENCH_CLOCKS_PER_SEC 100000ul
#else
#define STDCBENCH_CLOCKS_PER_SEC 100ul
#endif

/* 1 = c90base, 2 = c90lib, 3 = both. TIMER allows only one module. */
#ifndef STDCBENCH_WHICH
#define STDCBENCH_WHICH 3
#endif

#if (STDCBENCH_WHICH & 1)
#define C90BASE
#endif

#if (STDCBENCH_WHICH & 2)
/* Classic 8080, 8085, gbz80 and vm1 clibs do not provide qsort. */
#if !defined(__8080) && !defined(__8080__) && !defined(__8085) && !defined(__8085__) \
    && !defined(__GBZ80) && !defined(__GBZ80__) && !defined(__VM1) && !defined(__VM1__)
#define C90LIB
#endif
#endif

#undef C90FLOAT
#undef C90DOUBLE

#endif
