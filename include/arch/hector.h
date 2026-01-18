/* Header for Hector specific functions */
#ifndef ARCH_HECTOR_H
#define ARCH_HECTOR_H

#include <sys/compiler.h>

typedef enum {
    HECTOR_BLACK = 0,
    HECTOR_RED,
    HECTOR_GREEN,
    HECTOR_YELLOW,
    HECTOR_BLUE,
    HECTOR_MAGENTA,
    HECTOR_CYAN,
    HECTOR_WHITE,
    HECTOR_BRIGHT = 8, // Only on HR machines, and only for colour 2
} hector_colour_t;


/** \brief Set the palette for the 4 pens
 * 
 * \param p0
 * \param p1
 * \param p2 - Can be modified with HECTOR_BRIGHT to set the bright bit
 * \param p3
 * 
 * The Hector supports 8 colours which can be mapped into anyone of the 4 available pens.
 */
extern void __LIB__ hector_set_palette(hector_colour_t p0, hector_colour_t p1, hector_colour_t p2, hector_colour_t p3) __smallc;





#endif
