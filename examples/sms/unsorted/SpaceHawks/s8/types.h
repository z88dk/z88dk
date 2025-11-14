#ifndef TYPES_H_
#define TYPES_H_

#include <stdbool.h> //for true/false
#include <stddef.h> //for null

typedef unsigned char u8;
typedef unsigned int u16;
typedef unsigned long u32;

typedef signed char s8;
typedef signed int s16;
typedef signed long s32;
typedef signed int fix16;

typedef void _voidCallback( );


//from SGDK, thanks Steph ;)
#define FIX16_INT_BITS              10
#define FIX16_FRAC_BITS             (16 - FIX16_INT_BITS)

#define FIX16_INT_MASK              (((1 << FIX16_INT_BITS) - 1) << FIX16_FRAC_BITS)
#define FIX16_FRAC_MASK             ((1 << FIX16_FRAC_BITS) - 1)

#define FIX16(value)                ((fix16) ((value) * (1 << FIX16_FRAC_BITS)))
#define intToFix16(value)           ((value) << FIX16_FRAC_BITS)
#define fix16ToInt(value)           ((value) >> FIX16_FRAC_BITS)
#define fix16Round(value)           (fix16Frac(value) > FIX16(0.5))?fix16Int(value + FIX16(1)) + 1:fix16Int(value)
#define fix16ToRoundedInt(value) 	(fix16Frac(value) > FIX16(0.5))?fix16ToInt(value) + 1:fix16ToInt(value)
#define fix16Frac(value)            ((value) & FIX16_FRAC_MASK)
#define fix16Int(value)             ((value) & FIX16_INT_MASK)
#define fix16Add(val1, val2)        ((val1) + (val2))
#define fix16Sub(val1, val2)        ((val1) - (val2))
#define fix16Neg(value)             (0 - (value))
#define fix16Mul(val1, val2)        (((val1) * (val2)) >> FIX16_FRAC_BITS)
#define fix16Div(val1, val2)        (((val1) << FIX16_FRAC_BITS) / (val2))


#endif /* TYPES_H_ */
