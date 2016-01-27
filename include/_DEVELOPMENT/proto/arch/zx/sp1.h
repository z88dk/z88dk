include(__link__.m4)

#ifndef _SP1_ZX_H
#define _SP1_ZX_H

///////////////////////////////////////////////////////////
//                  SPRITE PACK v3.0                     //
//             Sinclair Spectrum Version                 //
//            aralbrec - April / May 2006                //
///////////////////////////////////////////////////////////
//                                                       //
//    Software sprite engine for bitmapped displays      //
//                                                       //
//    * Differential screen update                       //
//    * Any number and any size of sprites               //
//    * Clipping to character cell boundaries            //
//    * Background tile animation                        //
//                                                       //
//       See the wiki for documentation details          //
//             http://www.z88dk.org/wiki                 //
//                                                       //
///////////////////////////////////////////////////////////

#include <stdint.h>

///////////////////////////////////////////////////////////
//                  DATA STRUCTURES                      //
///////////////////////////////////////////////////////////

struct sp1_Rect {

   uint8_t row;
   uint8_t col;
   uint8_t width;
   uint8_t height;

};

struct sp1_update;
struct sp1_ss;
struct sp1_cs;

struct sp1_update {                   // "update structs" - 10 bytes - Every tile in the display area managed by SP1 is described by one of these

   uint8_t              nload;          // +0 bit 7 = 1 for invalidated, bit 6 = 1 for removed, bits 5:0 = number of occluding sprites present + 1
   uint8_t              colour;         // +1 background tile attribute
   uint16_t               tile;           // +2 background 16-bit tile code (if MSB != 0 taken as address of graphic, else lookup in tile array)
   struct sp1_cs     *slist;          // +4 BIG ENDIAN ; list of sprites occupying this tile (MSB = 0 if none) points at struct sp1_cs.attr_mask
   struct sp1_update *ulist;          // +6 BIG ENDIAN ; next update struct in list of update structs queued for draw (MSB = 0 if none)
   uint8_t             *screen;         // +8 address in display file where this tile is drawn

};

struct sp1_ss {                       // "sprite structs" - 20 bytes - Every sprite is described by one of these

   uint8_t              row;            // +0  current y tile-coordinate
   uint8_t              col;            // +1  current x tile-coordinate
   uint8_t              width;          // +2  width of sprite in tiles
   uint8_t              height;         // +3  height of sprite in tiles

   uint8_t              vrot;           // +4  bit 7 = 1 for 2-byte graphical definition else 1-byte, bits 2:0 = current vertical rotation (0..7)
   uint8_t              hrot;           // +5  current horizontal rotation (0..7)

   uint8_t             *frame;          // +6  current sprite frame address added to graphic pointers

   uint8_t              res0;           // +8  "LD A,n" opcode
   uint8_t              e_hrot;         // +9  effective horizontal rotation = MSB of rotation table to use
   uint8_t              res1;           // +10 "LD BC,nn" opcode
   uint16_t               e_offset;       // +11 effective offset to add to graphic pointers, equals result of vertical rotation + frame addr
   uint8_t              res2;           // +13 "EX DE,HL" opcode
   uint8_t              res3;           // +14 "JP (HL)" opcode

   struct sp1_cs     *first;          // +15 BIG ENDIAN ; first struct sp1_cs of this sprite

   uint8_t              xthresh;        // +17 hrot must be at least this number of pixels for last column of sprite to be drawn (1 default)
   uint8_t              ythresh;        // +18 vrot must be at least this number of pixels for last row of sprite to be drawn (1 default)
   uint8_t              nactive;        // +19 number of struct sp1_cs cells on display (written by sp1_MoveSpr*)

};

struct sp1_cs {                       // "char structs" - 24 bytes - Every sprite is broken into pieces fitting into a tile, each of which is described by one of these

   struct sp1_cs     *next_in_spr;    // +0  BIG ENDIAN ; next sprite char within same sprite in row major order (MSB = 0 if none)

   struct sp1_update *update;         // +2  BIG ENDIAN ; tile this sprite char currently occupies (MSB = 0 if none)

   uint8_t              plane;          // +4  plane sprite occupies, 0 = closest to viewer
   uint8_t              type;           // +5  bit 7 = 1 occluding, bit 6 = 1 last column, bit 5 = 1 last row, bit 4 = 1 clear pixelbuffer
   uint8_t              attr_mask;      // +6  attribute mask logically ANDed with underlying attribute, default = 0xff for transparent
   uint8_t              attr;           // +7  sprite colour, logically ORed to form final colour, default = 0 for transparent

   void              *ss_draw;        // +8  struct sp1_ss + 8 bytes ; points at code embedded in sprite struct sp1_ss

   uint8_t              res0;           // +10 typically "LD HL,nn" opcode
   uint8_t             *def;            // +11 graphic definition pointer
   uint8_t              res1;           // +13 typically "LD IX,nn" opcode
   uint8_t              res2;           // +14
   uint8_t             *l_def;          // +15 graphic definition pointer for sprite character to left of this one
   uint8_t              res3;           // +17 typically "CALL nn" opcode
   void              *draw;           // +18 & draw function for this sprite char

   struct sp1_cs     *next_in_upd;    // +20 BIG ENDIAN ; & sp1_cs.attr_mask of next sprite occupying the same tile (MSB = 0 if none)
   struct sp1_cs     *prev_in_upd;    // +22 BIG ENDIAN ; & sp1_cs.next_in_upd of previous sprite occupying the same tile

};

struct sp1_ap {                       // "attribute pairs" - 2 bytes - A struct to hold sprite attribute and mask pairs

   uint8_t              attr_mask;      // +0 attribute mask logically ANDed with underlying attribute = 0xff for transparent
   uint8_t              attr;           // +1 sprite colour, logically ORed to form final colour = 0 for transparent

};

struct sp1_tp {                       // "tile pairs" - 3 bytes - A struct to hold background colour and tile pairs

   uint8_t              attr;           // +0 colour
   uint16_t             tile;           // +1 tile code

};

struct sp1_pss {                      // "print string struct" - 11 bytes - A struct holding print state information

   struct sp1_Rect   *bounds;         // +0 rectangular boundary within which printing will be allowed
   uint8_t              flags;          // +2 bit 0=invalidate?, 1=xwrap?, 2=yinc?, 3=ywrap?
   uint8_t              x;              // +3 current x coordinate of cursor with respect to top left corner of bounds
   uint8_t              y;              // +4 current y coordinate of cursor with respect to top left corner of bounds
   uint8_t              attr_mask;      // +5 current attribute mask
   uint8_t              attr;           // +6 current attribute
   struct sp1_update *pos;            // +7 RESERVED struct sp1_update associated with current cursor coordinates
   void              *visit;          // +9 void (*visit)(struct sp1_update *) function, set to 0 for none
   
};

///////////////////////////////////////////////////////////
//                      SPRITES                          //
///////////////////////////////////////////////////////////

// sprite type bits

#define SP1_TYPE_OCCLUDE   0x80       // background and sprites underneath will not be drawn
#define SP1_TYPE_BGNDCLR   0x10       // for occluding sprites, copy background tile into pixel buffer before draw

#define SP1_TYPE_2BYTE     0x40       // sprite graphic consists of (mask,graph) pairs, valid only in sp1_CreateSpr()
#define SP1_TYPE_1BYTE     0x00       // sprite graphic consists of graph only, valid only in sp1_CreateSpr()

#define SP1_AMASK_TRANS    0xff       // attribute mask for a transparent-colour sprite
#define SP1_AMASK_INK      0xf8       // attribute mask for an ink-only sprite
#define SP1_AMASK_PAPER    0xc7       // attribute mask for a paper-only sprite
#define SP1_AMASK_NOFLASH  0x7f       // attribute mask for no-flash
#define SP1_AMASK_NOBRIGHT 0xbf       // attribute mask for no-bright
#define SP1_ATTR_TRANS     0x00       // attribute for a transparent-colour sprite

extern struct sp1_cs  sp1_struct_cs_prototype;
extern struct sp1_ss  sp1_struct_ss_prototype;

extern void    SP1_DRAW_MASK2(void);        // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation will use MASK2_NR if no rotation necessary
extern void    SP1_DRAW_MASK2NR(void);      // masked sprite 2-byte definition (mask,graph) pairs ; no rotation applied, graphic always drawn at exact tile boundary
extern void    SP1_DRAW_MASK2LB(void);      // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation as MASK2 but for left boundary of sprite only
extern void    SP1_DRAW_MASK2RB(void);      // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation as MASK2 but for right boundary of sprite only

extern void    SP1_DRAW_LOAD2(void);        // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use LOAD2_NR if no rotation necessary
extern void    SP1_DRAW_LOAD2NR(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void    SP1_DRAW_LOAD2LB(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for left boundary of sprite only
extern void    SP1_DRAW_LOAD2RB(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for right boundary of sprite only

extern void    SP1_DRAW_OR2(void);          // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use OR2_NR if no rotation necessary
extern void    SP1_DRAW_OR2NR(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void    SP1_DRAW_OR2LB(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as OR2 but for left boundary of sprite only
extern void    SP1_DRAW_OR2RB(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as OR2 but for right boundary of sprite only

extern void    SP1_DRAW_XOR2(void);         // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use XOR2_NR if no rotation necessary
extern void    SP1_DRAW_XOR2NR(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void    SP1_DRAW_XOR2LB(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as XOR2 but for left boundary of sprite only
extern void    SP1_DRAW_XOR2RB(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as XOR2 but for right boundary of sprite only

extern void    SP1_DRAW_LOAD2LBIM(void);    // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for left boundary of sprite w/ implied mask
extern void    SP1_DRAW_LOAD2RBIM(void);    // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for right boundary of sprite w/ implied mask

extern void    SP1_DRAW_ATTR(void);         // pixels are not drawn, only attributes


__DPROTO(,,struct sp1_ss,*,sp1_CreateSpr,void *drawf,uint16_t type,uint16_t height,int graphic,uint16_t plane)
__DPROTO(,,uint16_t,,sp1_AddColSpr,struct sp1_ss *s,void *drawf,uint16_t type,int graphic,uint16_t plane)
__DPROTO(,,void,,sp1_ChangeSprType,struct sp1_cs *c,void *drawf)
__DPROTO(,,void,,sp1_DeleteSpr,struct sp1_ss *s)// only call after sprite is removed from screen

__DPROTO(,,void,,sp1_MoveSprAbs,struct sp1_ss *s,struct sp1_Rect *clip,void *frame,uint16_t row,uint16_t col,uint16_t vrot,uint16_t hrot)
__DPROTO(,,void,,sp1_MoveSprRel,struct sp1_ss *s,struct sp1_Rect *clip,void *frame,int rel_row,int rel_col,int rel_vrot,int rel_hrot)
__DPROTO(,,void,,sp1_MoveSprPix,struct sp1_ss *s,struct sp1_Rect *clip,void *frame,uint16_t x,uint16_t y)

__DPROTO(,,void,,sp1_IterateSprChar,struct sp1_ss *s,void *hook1)
__DPROTO(,,void,,sp1_IterateUpdateSpr,struct sp1_ss *s,void *hook2)

__DPROTO(,,void,,sp1_GetSprClrAddr,struct sp1_ss *s,uint8_t **sprdest)
__DPROTO(,,void,,sp1_PutSprClr,uint8_t **sprdest,struct sp1_ap *src,uint16_t n)
__DPROTO(,,void,,sp1_GetSprClr,uint8_t **sprsrc,struct sp1_ap *dest,uint16_t n)

__DPROTO(,,void,*,sp1_PreShiftSpr,uint16_t flag,uint16_t height,uint16_t width,void *srcframe,void *destframe,uint16_t rshift)

__DPROTO(,,void,,sp1_InitCharStruct,struct sp1_cs *cs,void *drawf,uint16_t type,void *graphic,uint16_t plane)
__DPROTO(,,void,,sp1_InsertCharStruct,struct sp1_update *u,struct sp1_cs *cs)
__DPROTO(,,void,,sp1_RemoveCharStruct,struct sp1_cs *cs)

///////////////////////////////////////////////////////////
//                       TILES                           //
///////////////////////////////////////////////////////////

#define SP1_RFLAG_TILE          0x01
#define SP1_RFLAG_COLOUR        0x02
#define SP1_RFLAG_SPRITE        0x04

#define SP1_PSSFLAG_INVALIDATE  0x01
#define SP1_PSSFLAG_XWRAP       0x02
#define SP1_PSSFLAG_YINC        0x04
#define SP1_PSSFLAG_YWRAP       0x08

__DPROTO(,,void,*,sp1_TileEntry,uint16_t c,void *def)

__DPROTO(,,void,,sp1_PrintAt,uint16_t row,uint16_t col,uint16_t colour,uint16_t tile)
__DPROTO(,,void,,sp1_PrintAtInv,uint16_t row,uint16_t col,uint16_t colour,uint16_t tile)
__DPROTO(`b,c',`b,c',uint16_t,,sp1_ScreenStr,uint16_t row,uint16_t col)
__DPROTO(`b,c',`b,c',uint16_t,,sp1_ScreenAttr,uint16_t row,uint16_t col)

__DPROTO(,,void,,sp1_PrintString,struct sp1_pss *ps,uint8_t *s)
__DPROTO(,,void,,sp1_SetPrintPos,struct sp1_pss *ps,uint16_t row,uint16_t col)

__DPROTO(,,void,,sp1_GetTiles,struct sp1_Rect *r,struct sp1_tp *dest)
__DPROTO(,,void,,sp1_PutTiles,struct sp1_Rect *r,struct sp1_tp *src)
__DPROTO(,,void,,sp1_PutTilesInv,struct sp1_Rect *r,struct sp1_tp *src)

__DPROTO(,,void,,sp1_ClearRect,struct sp1_Rect *r,uint16_t colour,uint16_t tile,uint16_t rflag)
__DPROTO(,,void,,sp1_ClearRectInv,struct sp1_Rect *r,uint16_t colour,uint16_t tile,uint16_t rflag)

///////////////////////////////////////////////////////////
//                      UPDATER                          //
///////////////////////////////////////////////////////////

#define SP1_IFLAG_MAKE_ROTTBL      0x01
#define SP1_IFLAG_OVERWRITE_TILES  0x02
#define SP1_IFLAG_OVERWRITE_DFILE  0x04

// void *hook  <->  void [ __FASTCALL__ ] (*hook)(struct sp1_update *u)

__DPROTO(,,void,,sp1_Initialize,uint16_t iflag,uint16_t colour,uint16_t tile)
__OPROTO(,,void,,sp1_UpdateNow,void)

__DPROTO(`b,c',`b,c',struct sp1_update,*,sp1_GetUpdateStruct,uint16_t row,uint16_t col)
__DPROTO(,,void,,sp1_IterateUpdateArr,struct sp1_update **ua,void *hook)// zero terminated array
__DPROTO(,,void,,sp1_IterateUpdateRect,struct sp1_Rect *r,void *hook)

__DPROTO(,,void,,sp1_InvUpdateStruct,struct sp1_update *u)
__DPROTO(`a,b,c,d,e,h,l',`b,c,d,e',void,,sp1_ValUpdateStruct,struct sp1_update *u)

__DPROTO(,,void,,sp1_DrawUpdateStructIfInv,struct sp1_update *u)
__DPROTO(,,void,,sp1_DrawUpdateStructIfVal,struct sp1_update *u)
__DPROTO(,,void,,sp1_DrawUpdateStructIfNotRem,struct sp1_update *u)
__DPROTO(,,void,,sp1_DrawUpdateStructAlways,struct sp1_update *u)

__DPROTO(`b,c',`b,c',void,,sp1_RemoveUpdateStruct,struct sp1_update *u)
__DPROTO(`a,b,c,d,e,h,l',`b,c,d,e',void,,sp1_RestoreUpdateStruct,struct sp1_update *u)

__DPROTO(,,void,,sp1_Invalidate,struct sp1_Rect *r)
__DPROTO(,,void,,sp1_Validate,struct sp1_Rect *r)

#endif
