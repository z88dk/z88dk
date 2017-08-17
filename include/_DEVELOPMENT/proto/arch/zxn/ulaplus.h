include(__link__.m4)

#ifndef _ULAPLUS_H

#include <arch/zx/ulaplus.h>

// ULA+ Colour <-> Layer 2 Colour

#ifndef ULAP_COLOR_FROM_LAYER2
#define ULAP_COLOR_FROM_LAYER2(C)  ULAP_COLOR_RGB332(C)
#endif

#ifndef LAYER2_COLOR_FROM_ULAP
#define LAYER2_COLOR_FROM_ULAP(C)  ULAP_COLOR_RGB332(C)
#endif

#endif
