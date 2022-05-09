
#ifndef _SP1_H
#define _SP1_H

///////////////////////////////////////////////////////////
//                  SPRITE PACK v3.0                     //
//         Timex Sinclair 2068 Hi-Res Version            //
//                 aralbrec - Jan 2008                   //
//        ported from sinclair spectrum version          //
///////////////////////////////////////////////////////////
//                                                       //
//       See the wiki for documentation details          //
//             http://www.z88dk.org/wiki                 //
//                                                       //
///////////////////////////////////////////////////////////

#include <rect.h>
#include <sys/types.h>

///////////////////////////////////////////////////////////
//                  DATA STRUCTURES                      //
///////////////////////////////////////////////////////////

struct sp1_Rect {

   uchar row;
   uchar col;
   uchar width;
   uchar height;

};

struct sp1_update;
struct sp1_ss;
struct sp1_cs;

struct sp1_update {                   // "update structs" - 9 bytes - Every tile in the display area managed by SP1 is described by one of these

   uchar              nload;          // +0 bit 7 = 1 for invalidated, bit 6 = 1 for removed, bits 5:0 = number of occluding sprites present + 1
   uint               tile;           // +1 background 16-bit tile code (if MSB != 0 taken as address of graphic, else lookup in tile array)
   struct sp1_cs     *slist;          // +3 BIG ENDIAN ; list of sprites occupying this tile (MSB = 0 if none) points at struct sp1_cs.ss_draw
   struct sp1_update *ulist;          // +5 BIG ENDIAN ; next update struct in list of update structs queued for draw (MSB = 0 if none)
   uchar             *screen;         // +7 address in display file where this tile is drawn

};

struct sp1_ss {                       // "sprite structs" - 20 bytes - Every sprite is described by one of these

   uchar              row;            // +0  current y tile-coordinate
   uchar              col;            // +1  current x tile-coordinate
   uchar              width;          // +2  width of sprite in tiles
   uchar              height;         // +3  height of sprite in tiles

   uchar              vrot;           // +4  bit 7 = 1 for 2-byte graphical definition else 1-byte, bits 2:0 = current vertical rotation (0..7)
   uchar              hrot;           // +5  current horizontal rotation (0..7)

   uchar             *frame;          // +6  current sprite frame address added to graphic pointers

   uchar              res0;           // +8  "LD A,n" opcode
   uchar              e_hrot;         // +9  effective horizontal rotation = MSB of rotation table to use
   uchar              res1;           // +10 "LD BC,nn" opcode
   uint               e_offset;       // +11 effective offset to add to graphic pointers, equals result of vertical rotation + frame addr
   uchar              res2;           // +13 "EX DE,HL" opcode
   uchar              res3;           // +14 "JP (HL)" opcode

   struct sp1_cs     *first;          // +15 BIG ENDIAN ; first struct sp1_cs of this sprite

   uchar              xthresh;        // +17 hrot must be at least this number of pixels for last column of sprite to be drawn (1 default)
   uchar              ythresh;        // +18 vrot must be at least this number of pixels for last row of sprite to be drawn (1 default)
   uchar              nactive;        // +19 number of struct sp1_cs cells on display (written by sp1_MoveSpr*)

};

struct sp1_cs {                       // "char structs" - 22 bytes - Every sprite is broken into pieces fitting into a tile, each of which is described by one of these

   struct sp1_cs     *next_in_spr;    // +0  BIG ENDIAN ; next sprite char within same sprite in row major order (MSB = 0 if none)

   struct sp1_update *update;         // +2  BIG ENDIAN ; tile this sprite char currently occupies (MSB = 0 if none)

   uchar              plane;          // +4  plane sprite occupies, 0 = closest to viewer
   uchar              type;           // +5  bit 7 = 1 occluding, bit 6 = 1 last column, bit 5 = 1 last row, bit 4 = 1 clear pixelbuffer

   void              *ss_draw;        // +6  struct sp1_ss + 8 bytes ; points at code embedded in sprite struct sp1_ss

   uchar              res0;           // +8  typically "LD HL,nn" opcode
   uchar             *def;            // +9  graphic definition pointer
   uchar              res1;           // +11 typically "LD IX,nn" opcode
   uchar              res2;           // +12
   uchar             *l_def;          // +13 graphic definition pointer for sprite character to left of this one
   uchar              res3;           // +15 typically "CALL nn" opcode
   void              *draw;           // +16 & draw function for this sprite char

   struct sp1_cs     *next_in_upd;    // +18 BIG ENDIAN ; & sp1_cs.ss_draw of next sprite occupying the same tile (MSB = 0 if none)
   struct sp1_cs     *prev_in_upd;    // +20 BIG ENDIAN ; & sp1_cs.next_in_upd of previous sprite occupying the same tile

};

struct sp1_tp {                       // "tile list" - 2 bytes - A struct to hold a 16-bit tile code
   uint               tile;           // +0 tile code
};

struct sp1_pss {                      // "print string struct" - 9 bytes - A struct holding print state information

   struct sp1_Rect   *bounds;         // +0 rectangular boundary within which printing will be allowed
   uchar              flags;          // +2 bit 0=invalidate?, 1=xwrap?, 2=yinc?, 3=ywrap?
   uchar              x;              // +3 current x coordinate of cursor with respect to top left corner of bounds
   uchar              y;              // +4 current y coordinate of cursor with respect to top left corner of bounds
   struct sp1_update *pos;            // +5 RESERVED struct sp1_update associated with current cursor coordinates
   void              *visit;          // +7 void (*visit)(struct sp1_update *) function, set to 0 for none
   
};

///////////////////////////////////////////////////////////
//                      SPRITES                          //
///////////////////////////////////////////////////////////

// sprite type bits

#define SP1_TYPE_OCCLUDE   0x80       // background and sprites underneath will not be drawn
#define SP1_TYPE_BGNDCLR   0x10       // for occluding sprites, copy background tile into pixel buffer before draw

#define SP1_TYPE_2BYTE     0x40       // sprite graphic consists of (mask,graph) pairs, valid only in sp1_CreateSpr()
#define SP1_TYPE_1BYTE     0x00       // sprite graphic consists of graph only, valid only in sp1_CreateSpr()

// prototype struct_sp1_ss and struct_sp1_cs that can be used to initialize empty structures

extern struct sp1_cs  sp1_struct_cs_prototype;
extern struct sp1_ss  sp1_struct_ss_prototype;

// draw functions for sprites with two-byte graphical definitions, ie (mask,graphic) pairs

extern void  __LIB__  SP1_DRAW_MASK2(void);        // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation will use MASK2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_MASK2NR(void);      // masked sprite 2-byte definition (mask,graph) pairs ; no rotation applied, graphic always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_MASK2LB(void);      // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation as MASK2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_MASK2RB(void);      // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation as MASK2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_LOAD2(void);        // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use LOAD2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_LOAD2NR(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_LOAD2LB(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_LOAD2RB(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_OR2(void);          // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use OR2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_OR2NR(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_OR2LB(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as OR2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_OR2RB(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as OR2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_XOR2(void);         // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use XOR2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_XOR2NR(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_XOR2LB(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as XOR2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_XOR2RB(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as XOR2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_LOAD2LBIM(void);    // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for left boundary of sprite w/ implied mask
extern void  __LIB__  SP1_DRAW_LOAD2RBIM(void);    // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for right boundary of sprite w/ implied mask

// draw functions for sprites with one-byte graphical definitions, ie no mask just graphics

extern void  __LIB__  SP1_DRAW_LOAD1(void);        // load sprite 1-byte definition graph only no mask; sw rotation will use LOAD1_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_LOAD1NR(void);      // load sprite 1-byte definition graph only no mask; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_LOAD1LB(void);      // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_LOAD1RB(void);      // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_OR1(void);          // or sprite 1-byte definition graph only no mask; sw rotation will use OR1_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_OR1NR(void);        // or sprite 1-byte definition graph only no mask; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_OR1LB(void);        // or sprite 1-byte definition graph only no mask; sw rotation as OR1 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_OR1RB(void);        // or sprite 1-byte definition graph only no mask; sw rotation as OR1 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_XOR1(void);         // xor sprite 1-byte definition graph only no mask; sw rotation will use XOR1_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_XOR1NR(void);       // xor sprite 1-byte definition graph only no mask; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_XOR1LB(void);       // xor sprite 1-byte definition graph only no mask; sw rotation as XOR1 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_XOR1RB(void);       // xor sprite 1-byte definition graph only no mask; sw rotation as XOR1 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_LOAD1LBIM(void);    // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for left boundary of sprite with implied mask
extern void  __LIB__  SP1_DRAW_LOAD1RBIM(void);    // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for right boundary of sprite with implied mask

// void *hook1  <->  void [ __FASTCALL__ ] (*hook1)(uint count, struct sp1_cs *c)      // if __FASTCALL__ only struct sp1_cs* passed
// void *hook2  <->  void [ __FASTCALL__ ] (*hook2)(uint count, struct sp1_update *u)  // if __FASTCALL__ only struct sp1_update* passed
//
// void *drawf  <->  void (*drawf)(void)     // sprite draw function containing draw code and data for struct_sp1_cs

extern struct sp1_ss      __LIB__  *sp1_CreateSpr(void *drawf, uchar type, uchar height, int graphic, uchar plane);
extern uint               __LIB__   sp1_AddColSpr(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane);
extern void               __LIB__   sp1_ChangeSprType(struct sp1_cs *c, void *drawf);
extern void  __FASTCALL__ __LIB__   sp1_DeleteSpr(struct sp1_ss *s);   // only call after sprite is moved off screen

extern void               __LIB__   sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uchar row, uchar col, uchar vrot, uchar hrot);
extern void               __LIB__   sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot);
extern void               __LIB__   sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uint x, uint y);

extern void               __LIB__   sp1_IterateSprChar(struct sp1_ss *s, void *hook1);
extern void               __LIB__   sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2);

extern void               __LIB__  *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift);

// some functions for displaying independent struct_sp1_cs not connected with any sprites; useful as foreground elements
// if not using a no-rotate (NR) type sprite draw function, must manually init the sp1_cs.ldef member after calling sp1_InitCharStruct()

extern void               __LIB__   sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane);
extern void               __LIB__   sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs);
extern void  __FASTCALL__ __LIB__   sp1_RemoveCharStruct(struct sp1_cs *cs);


/* CALLEE LINKAGE */

extern struct sp1_ss __CALLEE__ __LIB__ *sp1_CreateSpr_callee(void *drawf, uchar type, uchar height, int graphic, uchar plane);
extern uint          __CALLEE__ __LIB__  sp1_AddColSpr_callee(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane);
extern void          __CALLEE__ __LIB__  sp1_MoveSprAbs_callee(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uchar row, uchar col, uchar vrot, uchar hrot);
extern void          __CALLEE__ __LIB__  sp1_MoveSprRel_callee(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot);
extern void          __CALLEE__ __LIB__  sp1_MoveSprPix_callee(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uint x, uint y);
extern void          __CALLEE__ __LIB__  sp1_IterateSprChar_callee(struct sp1_ss *s, void *hook1);
extern void          __CALLEE__ __LIB__  sp1_IterateUpdateSpr_callee(struct sp1_ss *s, void *hook2);
extern void          __CALLEE__ __LIB__  sp1_ChangeSprType_callee(struct sp1_cs *c, void *drawf);
extern void          __CALLEE__ __LIB__ *sp1_PreShiftSpr_callee(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift);
extern void          __CALLEE__ __LIB__  sp1_InitCharStruct_callee(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane);
extern void          __CALLEE__ __LIB__  sp1_InsertCharStruct_callee(struct sp1_update *u, struct sp1_cs *cs);

#define sp1_CreateSpr(a,b,c,d,e)       sp1_CreateSpr_callee(a,b,c,d,e)
#define sp1_AddColSpr(a,b,c,d,e)       sp1_AddColSpr_callee(a,b,c,d,e)
#define sp1_MoveSprAbs(a,b,c,d,e,f,g)  sp1_MoveSprAbs_callee(a,b,c,d,e,f,g)
#define sp1_MoveSprRel(a,b,c,d,e,f,g)  sp1_MoveSprRel_callee(a,b,c,d,e,f,g)
#define sp1_MoveSprPix(a,b,c,d,e)      sp1_MoveSprPix_callee(a,b,c,d,e)
#define sp1_IterateSprChar(a,b)        sp1_IterateSprChar_callee(a,b)
#define sp1_IterateUpdateSpr(a,b)      sp1_IterateUpdateSpr_callee(a,b)
#define sp1_ChangeSprType(a,b)         sp1_ChangeSprType_callee(a,b)
#define sp1_PreShiftSpr(a,b,c,d,e,f)   sp1_PreShiftSpr_callee(a,b,c,d,e,f)
#define sp1_InitCharStruct(a,b,c,d,e)  sp1_InitCharStruct_callee(a,b,c,d,e)
#define sp1_InsertCharStruct(a,b)      sp1_InsertCharStruct_callee(a,b)


///////////////////////////////////////////////////////////
//                COLLISION DETECTION                    //
///////////////////////////////////////////////////////////

// BEING REVIEWED FOR CHANGES

///////////////////////////////////////////////////////////
//                       TILES                           //
///////////////////////////////////////////////////////////

#define SP1_RFLAG_TILE          0x01
#define SP1_RFLAG_SPRITE        0x04

#define SP1_PSSFLAG_INVALIDATE  0x01
#define SP1_PSSFLAG_XWRAP       0x02
#define SP1_PSSFLAG_YINC        0x04
#define SP1_PSSFLAG_YWRAP       0x08

extern void  __LIB__  *sp1_TileEntry(uchar c, void *def);

extern void  __LIB__   sp1_PrintAt(uchar row, uchar col, uint tile);
extern void  __LIB__   sp1_PrintAtInv(uchar row, uchar col, uint tile);
extern uint  __LIB__   sp1_ScreenStr(uchar row, uchar col);

extern void  __LIB__   sp1_PrintString(struct sp1_pss *ps, uchar *s);
extern void  __LIB__   sp1_SetPrintPos(struct sp1_pss *ps, uchar row, uchar col);

extern void  __LIB__   sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest);
extern void  __LIB__   sp1_PutTiles(struct sp1_Rect *r, struct sp1_tp *src);
extern void  __LIB__   sp1_PutTilesInv(struct sp1_Rect *r, struct sp1_tp *src);

extern void  __LIB__   sp1_ClearRect(struct sp1_Rect *r, uchar tile, uchar rflag);
extern void  __LIB__   sp1_ClearRectInv(struct sp1_Rect *r, uchar tile, uchar rflag);

/* CALLEE LINKAGE */

extern void  __CALLEE__ __LIB__  *sp1_TileEntry_callee(uchar c, void *def);
extern void  __CALLEE__ __LIB__   sp1_PrintAt_callee(uchar row, uchar col, uint tile);
extern void  __CALLEE__ __LIB__   sp1_PrintAtInv_callee(uchar row, uchar col, uint tile);
extern uint  __CALLEE__ __LIB__   sp1_ScreenStr_callee(uchar row, uchar col);
extern void  __CALLEE__ __LIB__   sp1_PrintString_callee(struct sp1_pss *ps, uchar *s);
extern void  __CALLEE__ __LIB__   sp1_SetPrintPos_callee(struct sp1_pss *ps, uchar row, uchar col);
extern void  __CALLEE__ __LIB__   sp1_GetTiles_callee(struct sp1_Rect *r, struct sp1_tp *dest);
extern void  __CALLEE__ __LIB__   sp1_PutTiles_callee(struct sp1_Rect *r, struct sp1_tp *src);
extern void  __CALLEE__ __LIB__   sp1_PutTilesInv_callee(struct sp1_Rect *r, struct sp1_tp *src);
extern void  __CALLEE__ __LIB__   sp1_ClearRect_callee(struct sp1_Rect *r, uchar tile, uchar rflag);
extern void  __CALLEE__ __LIB__   sp1_ClearRectInv_callee(struct sp1_Rect *r, uchar tile, uchar rflag);

#define sp1_TileEntry(a,b)         sp1_TileEntry_callee(a,b)
#define sp1_PrintAt(a,b,c)         sp1_PrintAt_callee(a,b,c)
#define sp1_PrintAtInv(a,b,c)      sp1_PrintAtInv_callee(a,b,c)
#define sp1_ScreenStr(a,b)         sp1_ScreenStr_callee(a,b)
#define sp1_PrintString(a,b)       sp1_PrintString_callee(a,b)
#define sp1_SetPrintPos(a,b,c)     sp1_SetPrintPos_callee(a,b,c)
#define sp1_GetTiles(a,b)          sp1_GetTiles_callee(a,b)
#define sp1_PutTiles(a,b)          sp1_PutTiles_callee(a,b)
#define sp1_PutTilesInv(a,b)       sp1_PutTilesInv_callee(a,b)
#define sp1_ClearRect(a,b,c)       sp1_ClearRect_callee(a,b,c)
#define sp1_ClearRectInv(a,b,c)    sp1_ClearRectInv_callee(a,b,c)


///////////////////////////////////////////////////////////
//                      UPDATER                          //
///////////////////////////////////////////////////////////

#define SP1_IFLAG_MAKE_ROTTBL      0x01
#define SP1_IFLAG_OVERWRITE_TILES  0x02
#define SP1_IFLAG_OVERWRITE_DFILE  0x04

// void *hook  <->  void [ __FASTCALL__ ] (*hook)(struct sp1_update *u)

extern void               __LIB__   sp1_Initialize(uchar iflag, uchar tile);
extern void               __LIB__   sp1_UpdateNow(void);

extern struct sp1_update  __LIB__  *sp1_GetUpdateStruct(uchar row, uchar col);
extern void               __LIB__   sp1_IterateUpdateArr(struct sp1_update **ua, void *hook);  // zero terminated array
extern void               __LIB__   sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook);

extern void __FASTCALL__  __LIB__   sp1_InvUpdateStruct(struct sp1_update *u);
extern void __FASTCALL__  __LIB__   sp1_ValUpdateStruct(struct sp1_update *u);

extern void __FASTCALL__  __LIB__   sp1_DrawUpdateStructIfInv(struct sp1_update *u);
extern void __FASTCALL__  __LIB__   sp1_DrawUpdateStructIfVal(struct sp1_update *u);
extern void __FASTCALL__  __LIB__   sp1_DrawUpdateStructIfNotRem(struct sp1_update *u);
extern void __FASTCALL__  __LIB__   sp1_DrawUpdateStructAlways(struct sp1_update *u);

extern void __FASTCALL__  __LIB__   sp1_RemoveUpdateStruct(struct sp1_update *u);
extern void __FASTCALL__  __LIB__   sp1_RestoreUpdateStruct(struct sp1_update *u);

extern void __FASTCALL__  __LIB__   sp1_Invalidate(struct sp1_Rect *r);
extern void __FASTCALL__  __LIB__   sp1_Validate(struct sp1_Rect *r);

/* CALLEE LINKAGE */

extern void              __CALLEE__ __LIB__   sp1_Initialize_callee(uchar iflag, uchar tile);
extern struct sp1_update __CALLEE__ __LIB__  *sp1_GetUpdateStruct_callee(uchar row, uchar col);
extern void              __CALLEE__ __LIB__   sp1_IterateUpdateArr_callee(struct sp1_update **ua, void *hook);
extern void              __CALLEE__ __LIB__   sp1_IterateUpdateRect_callee(struct sp1_Rect *r, void *hook);


#define sp1_Initialize(a,b)         sp1_Initialize_callee(a,b)
#define sp1_GetUpdateStruct(a,b)    sp1_GetUpdateStruct_callee(a,b)
#define sp1_IterateUpdateArr(a,b)   sp1_IterateUpdateArr_callee(a,b)
#define sp1_IterateUpdateRect(a,b)  sp1_IterateUpdateRect_callee(a,b)


#endif
