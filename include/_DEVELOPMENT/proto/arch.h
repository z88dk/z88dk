include(__link__.m4)

#ifndef _ARCH_H
#define _ARCH_H

// machine constants

#ifdef __SPECTRUM

   #ifndef __MODEL
      #define __MODEL 48
   #endif
   
   #if __MODEL = 48
   
      #ifndef __CPU_FREQ
         #define __CPU_FREQ 3500000
      #endif
   
   #endif

   #include <arch/spectrum.h>

#endif

#endif
