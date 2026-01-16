#ifndef _RECT_H
#define _RECT_H

/*
 * Points, Intervals and Rectangles
 * 05.2006 aralbrec
 *
 */
#include <sys/compiler.h>
#include <stdint.h>

/*
 * A library of routines that can check for and compute intersections amongst
 * points, intervals and rectangles.  8-bit and 16-bit coordinates are supported
 * by two sets of subroutines.  In both cases, the coordinate space wraps so
 * that, for example, an 8-bit interval beginning at coordinate 250 with width
 * 50 occupies the points [250,255]+[0,43] inclusive (ie 250 right through 43).
 *
 */

struct r_Ival8 {

   uint8_t coord;              // +0
   uint8_t width;              // +1

};

struct r_Ival16 {

   uint16_t coord;               // +0
   uint16_t width;               // +2
   
};

struct r_Rect8 {

   uint8_t x;                  // +0  struct r_Ival8
   uint8_t width;              // +1
   uint8_t y;                  // +2  struct r_Ival8
   uint8_t height;             // +3
   
};

struct r_Rect16 {

   uint16_t x;                   // +0  struct r_Ival16
   uint16_t width;               // +2
   uint16_t y;                   // +4  struct r_Ival16
   uint16_t height;              // +6
   
};

// Detect whether points, intervals and rectangles intersect

extern int __LIB__ r_IsPtInIval8(uint8_t x, struct r_Ival8 *i) __smallc;
extern int __LIB__ r_IsPtInRect8(uint8_t x, uint8_t y, struct r_Rect8 *r) __smallc;
extern int __LIB__ r_IsIvalInIval8(struct r_Ival8 *i1, struct r_Ival8 *i2) __smallc;
extern int __LIB__ r_IsRectInRect8(struct r_Rect8 *r1, struct r_Rect8 *r2) __smallc;

extern int __LIB__ r_IsPtInIval16(uint16_t x, struct r_Ival16 *i) __smallc;
extern int __LIB__ r_IsPtInRect16(uint16_t x, uint16_t y, struct r_Rect16 *r) __smallc;
extern int __LIB__ r_IsIvalInIval16(struct r_Ival16 *i1, struct r_Ival16 *i2) __smallc;
extern int __LIB__ r_IsRectInRect16(struct r_Rect16 *r1, struct r_Rect16 *r2) __smallc;

// Return the result of interval and rectangle intersections

extern int __LIB__ r_IntersectIval8(struct r_Ival8 *i1, struct r_Ival8 *i2, struct r_Ival8 *result) __smallc;
extern int __LIB__ r_IntersectRect8(struct r_Rect8 *r1, struct r_Rect8 *r2, struct r_Rect8 *result) __smallc;

extern int __LIB__ r_IntersectIval16(struct r_Ival16 *i1, struct r_Ival16 *i2, struct r_Ival16 *result) __smallc;
extern int __LIB__ r_IntersectRect16(struct r_Rect16 *r1, struct r_Rect16 *r2, struct r_Rect16 *result) __smallc;

#endif
