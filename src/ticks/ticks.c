#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ticks.h"
#include "cpu.h"
#include "debugger.h"
#include "backend.h"
#include "profiler.h"


// kc160 adds 1 for 0xdd, 0xfd bytes

// fr = zero, ff&256 = carry, ff&128 = s/p


#define ALUr_TICKS     (isez80() ? 1 :                    israbbit() ? 2 : isr800() ? 1 : iskc160() ? 1 : isgbz80() ? 4 : 4)
#define ALURxy_TICKS   (isez80() ? 1 :                                     isr800() ? 2 :                                 4)
#define ALUiHL_TICKS   (isez80() ? 2 :                    israbbit() ? 5 : isr800() ? 2 : iskc160() ? 3 : isgbz80() ? 8 : 7)
// The 0xdd,0xfd prefix has already been added here
#define ALUiXY_TICKS   (isez80() ? 3 : israbbit4k() ? 9 : israbbit() ? 7 : isr800() ? 5 : iskc160() ? 4 :                 15)
#define ALUn_TICKS     (isez80() ? 2 :                    israbbit() ? 4 : isr800() ? 2 : iskc160() ? 1 : isgbz80() ? 8 :  7)

#define LDrr_TICKS     (isez80() ? 1                    : israbbit() ? 2 : isr800() ? 1 : iskc160() ? 1 : isgbz80() ? 4 : is8080() ? 5 : 4 )

#define CBr_TICKS      (isez80() ? 2                    : israbbit() ? 4 : isr800() ? 2 : iskc160() ? 2 : isz180() ? 7 : 8)

#define LDRIM(r,r_) do { \
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 6 : isgbz80() ? 8 : isr800() ? 2 :  iskc160() ? 1 : 7; \
          if (altd) {               \
            r_= get_memory_inst(pc++); \
          } else {                  \
            r= get_memory_inst(pc++); \
          }                         \
        } while (0)

#define LDRRIM(a, b) do {           \
          st += isez80() ? 3 : israbbit() ? 6 : isz180() ? 9 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 2 : 10, \
          b= get_memory_inst(pc++), \
          a= get_memory_inst(pc++); \
        } while (0)
 

 // ld a,(de) ld a,(bc) ld a,(de)
#define LDRP(a, b, r) do {         \
          st += isez80() ? 2 : israbbit() ? (&a == &h) ? 5 : 6 : isgbz80() ? 8 : isz180() ? 6 : isr800() ? 2 : iskc160() ? 2 : 7, \
          r= get_memory_data(mp= b|a<<8),   \
          ++mp; \
        } while (0)

// ld r,(ix+d)
#define LDRPI(a, b, r) do {         \
          st += isez80() ? 3 : israbbit() ? 7 : isz180() ? 11 : isr800() ? 5 : iskc160() ? 3 : 15, \
          r= get_memory_data(((get_memory_inst(pc++)^128)-128+(b|a<<8))&65535); \
        } while (0)

// ld (bc),a ld (de),a ld (hl),a
#define LDPR(a, b, r)           \
          st += isez80() ? 2 : israbbit() ? (&a == &h) ? 6 : 7 : isgbz80() ? 8 : isr800() ? 2 : iskc160() ? 2 : 7, \
          put_memory(b|a<<8,r),       \
          mp= b+1&255 | a<<8

#define LDPRI(a, b, r)          \
          st += isez80() ? 3 : israbbit() ? 8 : isz180() ? 12 : isr800() ? 5 :iskc160() ? 3 : 15, \
          put_memory(((get_memory_inst(pc++)^128)-128+(b|a<<8))&65535,r)

// ld r,r'
#define LDRR(dr, sr, dr_, n) do {          \
            st+= n;               \
            if ( altd ) dr_ = sr; \
            else dr = sr; \
          } while(0)

// ld (nn),rr
#define LDPNNRR(a, b, n)        \
          st+= n,               \
          t= get_memory_inst(pc++),         \
          put_memory(t|= get_memory_inst(pc++)<<8, b), \
          put_memory(mp= t+1,a)

#define LDPIN(a, b)             \
          st+= isez80() ? 4 : israbbit() ? 9 : isz180() ? 12 : isr800() ? 5 : iskc160() ? 3 : 15,              \
          t= get_memory_inst(pc++),         \
          put_memory(((t^128)-128+(b|a<<8))&65535, get_memory_inst(pc++))

#define INCW(a, b)              \
          st += isez80() ? 1 : israbbit() ? 2 : isgbz80() ? 8 : is8080() ? 5 : isr800() ? 2 : iskc160() ? 1 : 6, \
          ++b || a++, \
          fk = (a|b) == 0 ? 1 : 0

#define DECW(a, b)              \
          st += isez80() ? 1 : israbbit() ? 2 : isgbz80() ? 8 : is8080() ? 5 : isr800() ? 2 : iskc160() ? 1 : 6, \
          b-- || a--, \
          fk = (a&b) == 0xff ? 1 : 0

#define INC(r,r_) do {               \
          st +=isez80() ? 1 : israbbit() ? 2 : is8080() ? 5 : isr800() ? 1  : iskc160() ? 1 : 4; \
          if (altd) {             \
            ff_= ff_&256            \
                | (fr_= r_= (fa_= r_)+(fb_= 1)), fk = 0; \
          } else {                \
            ff= ff&256            \
                | (fr= r= (fa= r)+(fb= 1)), fk = 0; \
          }                       \
        } while (0)

#define DEC(r,r_) do {                \
          st +=isez80() ? 1 : israbbit() ? 2 : is8080() ? 5 : isr800() ? 1 : iskc160() ? 1 : 4; \
          if (altd) {          \
            ff_= ff_&256           \
                | (fr_= r_= (fa_= r_)+(fb_= -1)), fk = 0; \
          } else {             \
            ff= ff&256           \
                | (fr= r= (fa= r)+(fb= -1)), fk = 0; \
          }                    \
        } while (0)

#define INCPI(a, b) do {            \
          st +=isez80() ? 5 : israbbit() ? 12 : isr800() ? 7 : iskc160() ? 6 : 19; \
          if (altd) {           \
            fa_= get_memory_data(t= (get_memory_inst(pc++)^128)-128+(b|a<<8)), \
            ff_= ff_&256          \
                | (fr_= put_memory(t,fa_+(fb_=1))), fk = 0; \
          } else {              \
            fa= get_memory_data(t= (get_memory_inst(pc++)^128)-128+(b|a<<8)), \
            ff= ff&256          \
                | (fr= put_memory(t,fa+(fb=1))), fk = 0; \
          }                      \
        } while(0)

#define DECPI(a, b) do {        \
          st +=isez80() ? 5 : israbbit() ? 12 : isr800() ? 7 : iskc160() ? 6 : 19; \
          if (altd) {           \
            fa_= get_memory_data(t= (get_memory_inst(pc++)^128)-128+(b|a<<8)), \
            ff_= ff_&256          \
                | (fr_= put_memory(t,fa_+(fb_=-1))), fk = 0; \
          } else {              \
            fa= get_memory_data(t= (get_memory_inst(pc++)^128)-128+(b|a<<8)), \
            ff= ff&256          \
                | (fr= put_memory(t,fa+(fb=-1))), fk = 0; \
          }                     \
        } while (0)

#define ADDRRRR(a, b, c, d)     \
          st+= isez80() ? 1 :israbbit() ? 2 : is808x() ? 10 : isgbz80() ? 8 : isr800() ?  1 : iskc160() ? 1 : 11,              \
          v= b+d+               \
           ( (a+c) << 8 ),        \
          ff= (ff    & 128)       \
            | (v>>8  & 296),      \
          fb= (fb&128)            \
            | ((v>>8^a^c^fr^fa)&16),  \
          mp= b+1+( a<<8 ),     \
          a= v>>8,              \
          b= v

#define ADDRRRR_ALTD(a, b, c, d, dh, dl)     \
          st+= israbbit() ? 2 :11,              \
          v= b+d+               \
           ( (a+c) << 8 ),        \
          ff_= (ff_    & 128)       \
            | ((v>>8)  & 296),      \
          fb_= (fb_&128)            \
            | ((v>>8^a^c^fr_^fa_)&16),  \
          mp= b+1+( a<<8 ),     \
          dh= v>>8,              \
          dl= v

#define JRCI(c)                 \
          if(c)                 \
            st+= isez80() ? 3 : isgbz80() ? 8 : isz180() ? 8 : isr800() ? 3 : iskc160() ? 3 : 12,            \
            pc+= (get_memory_inst(pc)^128)-127; \
          else                  \
            st+= isez80() ? 2 : isgbz80() ? 8 : isz180() ? 6 : isr800() ? 2 : iskc160() ? 2 : 7,             \
            pc++

#define JRC(c)                  \
          if(c)                 \
            st+= isez80() ? 2 : isgbz80() ? 8 : isz180() ? 6 : isr800() ? 2 : iskc160() ? 2 : 7,             \
            pc++;               \
          else                  \
            st+= isez80() ? 3 : isgbz80() ? 8 : isz180() ? 8 : isr800() ? 3 : iskc160() ? 3 : 12,            \
            pc+= (get_memory_inst(pc)^128)-127

// ld rr,(nn)
#define LDRRPNN(a, b, n)        \
          st+= n,               \
          t= get_memory_inst(pc++),         \
          b= get_memory_data(t|= get_memory_inst(pc++)<<8), \
          a= get_memory_data(mp= t+1)

#define ADDISP(a, b)            \
          st+= isez80() ? 1 : is808x() ? 10 : isgbz80() ? 8 : isr800() ? 1 : iskc160() ? 1 :  11,              \
          v= sp+(b|a<<8),       \
          ff= ff  &128          \
            | v>>8&296,         \
          fb= fb&128            \
            | (v>>8^sp>>8^a^fr^fa)&16, \
          mp= b+1+(a<<8),       \
          a= v>>8,              \
          b= v

#define ADDISP_ALTD(a, b, dh, dl)            \
          st+= 11,              \
          v= sp+(b|a<<8),       \
          ff_= ff_  &128          \
            | v>>8&296,         \
          fb_= fb_&128            \
            | (v>>8^sp>>8^a^fr_^fa_)&16, \
          mp= b+1+(a<<8),       \
          dh= v>>8,              \
          dl= v

#define ADD(b, n)  do {        \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= b)); \
          else fr= a= (ff= (fa= a)+(fb= b)); \
          fk = 0; \
      } while (0)

#define ADC(b, n)  do {         \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= b)+(ff_>>8&1)); \
          fr= a= (ff= (fa= a)+(fb= b)+(ff>>8&1)); \
          fk = 0; \
        } while (0)

#define SUB(b, n)  do {         \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= ~b)+1); \
          else fr= a= (ff= (fa= a)+(fb= ~b)+1); \
          fk = 0; \
        } while (0)

#define SBC(b, n) do {             \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= ~b)+(ff_>>8&1^1)); \
          else fr= a= (ff= (fa= a)+(fb= ~b)+(ff>>8&1^1)); \
          fk = 0; \
        } while (0)

#define AND(b, n) do {          \
          st+= n;               \
          if ( altd ) { fa_= ~(a_= ff_= fr_= a&b); fb_= 0;} \
          else { fa= ~(a= ff= fr= a&b);  fb= 0; } \
          fk = 0; \
      } while (0)



#define XOR(b, n) do {               \
          st+= n;                    \
          if ( altd ) {              \
            fa_= 256                 \
              | (ff_= fr_= a_= a^b); \
            fb_= 0;                  \
          } else {                   \
            fa= 256                  \
              | (ff= fr= a^= b);     \
            fb= 0;                   \
          }                          \
          fk = 0; \
        } while (0)

#define OR(b, n) do {                  \
          st += n;                     \
          if ( altd ) {                \
            fa_= 256                   \
              | (ff_= fr_= a_ = a|b);  \
            fb_= 0;                    \
          } else {                     \
            fa= 256                    \
              | (ff= fr= a|= b);       \
            fb= 0;                     \
          } \
          fk = 0; \
        } while (0)



#define CP(b, n) do {           \
          st+= n;               \
          if (altd) {           \
            fr_= (fa_= a)-b;    \
            fb_= ~b;            \
            ff_= fr_  & -41     \
                | b   &  40;    \
            fr_&= 255;          \
          } else {              \
            fr= (fa= a)-b;      \
            fb= ~b;             \
            ff= fr  & -41       \
                | b   &  40;    \
            fr&= 255;           \
          }                     \
        } while (0)

#define RET(n) do {             \
          ioi=ioe=0;            \
          st+= (n),             \
          mp= get_memory_data(sp++), \
          pc= mp|= get_memory_data(sp++)<<8; \
        } while (0)

#define RETC(c) do {            \
          ioi=ioe=0;            \
          if(c)                 \
            st+= isez80() ? 2 : israbbit() ? 2 : is8080() ?  5 : is8085() ?  6 : isgbz80() ? 8 : isr800() ? 1 :  iskc160() ? 2 : 5;             \
          else                  \
            st+= isez80() ? 6 : israbbit() ? 8 : is8080() ? 11 : is8085() ? 12 : isgbz80() ? 8 : isz180() ? 10 : isr800() ? 3 : iskc160() ? 5 : 11,            \
            mp= get_memory_data(sp++),      \
            pc= mp|= get_memory_data(sp++)<<8; \
        } while (0) 

#define RETCI(c) do {           \
          ioi=ioe=0;            \
          if(c)                 \
            st+= isez80() ? 6 : israbbit() ? 8 : is8080() ? 11 : is8085() ? 12 : isgbz80() ? 8 : isz180() ? 10 : isr800() ? 3 : iskc160() ? 5 : 11,            \
            mp= get_memory_data(sp++),      \
            pc= mp|= get_memory_data(sp++)<<8; \
          else                  \
            st+= isez80() ? 2 : israbbit() ? 2 : is8080() ?  5 : is8085() ?  6 : isgbz80() ? 8 : isr800() ? 1 : iskc160() ? 2 : 5; \
        } while (0)

#define PUSH(a, b) do {         \
          ioi=ioe=0;            \
          st+= isez80() ? 3 :israbbit() ? 10 : is8085() ? 12 : isgbz80() ? 16 : isr800() ? 4 : iskc160() ? 3 : 11,              \
          put_memory(--sp,a),   \
          put_memory(--sp,b);   \
        } while (0)

#define POP(a, b, a_, b_) do {          \
          ioi=ioe=0;            \
          st+= isez80() ? 3 : israbbit() ? 7 : isz180() ? 9 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 2 : 10;              \
          if (altd) b_= get_memory_data(sp++); else b= get_memory_data(sp++); \
          if (altd) a_= get_memory_data(sp++); else a= get_memory_data(sp++); \
        } while (0)

#define JPC(c) do {             \
          ioi=ioe=0;            \
          st+= isez80() ? 3 : israbbit() ? 7 : isz180() ? 6 : is8085() ? 7 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 2 :  10;              \
          if(c)                 \
            pc+= 2;             \
          else                  \
            st += isez80() ? 1 : isz180() ? 3 : is8085() ? 3 : isr800() ? 2 : iskc160() ? 1 : 0,  \
            pc= get_memory_inst(pc) | get_memory_inst(pc+1)<<8; \
        } while (0)

#define JPCI(c) do {            \
          ioi=ioe=0;            \
          st+= isez80() ? 3 : israbbit() ? 7 : isz180() ? 6 : is8085() ? 7 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 2 : 10;              \
          if(c)                 \
            st += isez80() ? 1 : isz180() ? 3 : is8085() ? 3 : isr800() ? 2 : iskc160() ? 1 : 0,  \
            pc= get_memory_inst(pc) | get_memory_inst(pc+1)<<8; \
          else                  \
            pc+= 2;             \
        } while(0)

#define CALLC(c)  do  {         \
          ioi=ioe=0;            \
          if(c)                 \
            st+= isez80() ? 3 : isz180() ? 6 : is8085() ? 9 : is8080() ? 11 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 3 : 10,            \
            pc+= 2;             \
          else                  \
            st+= isez80() ? 6 : isz180() ? 16 : is8085() ? 18 : isgbz80() ? 12 : isr800() ? 5 : iskc160() ? 6 : 17,            \
            t= pc+2,            \
            mp= pc= get_memory_inst(pc) | get_memory_inst(pc+1)<<8, \
            put_memory(--sp,t>>8),    \
            put_memory(--sp,t); \
        } while (0)

#define CALLCI(c) do {          \
          ioi=ioe=0;            \
          if(c)                 \
            st+= isez80() ? 6 : isz180() ? 16 : is8085() ? 18 : isgbz80() ? 12 : isr800() ? 5 : iskc160() ? 6 : 17,            \
            t= pc+2,            \
            mp= pc= get_memory_inst(pc) | get_memory_inst(pc+1)<<8, \
            put_memory(--sp,t>>8),    \
            put_memory(--sp,t);    \
          else                  \
            st+= isez80() ? 3 : isz180() ? 6 : is8085() ? 9 : is8080() ? 11 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 3 : 10,            \
            pc+= 2;              \
        } while (0)

#define RST(n) do {                   \
          ioi=ioe=0;                  \
          st+= isez80() ? 5 :israbbit() ? 8 : is8085() ? 12 : isgbz80() ? 16 : iskc160() ? 7 : 11,              \
          put_memory(--sp,pc>>8),     \
          put_memory(--sp,pc),        \
          mp= pc= n;                  \
        } while (0)

#define EXSPI(a, b) do {        \
          ioi=ioe=0;            \
          st+= isez80() ? 5 : israbbit() ? 13 : isz180() ? 16 : is8080() ? 18 : is8085() ? 16 : isr800() ? 4 : iskc160() ? 5 : 19, \
          t= get_memory_data(sp),    \
          put_memory(sp++,b),   \
          b= t,                 \
          t= get_memory_data(sp),    \
          put_memory(sp--,a),   \
          a= t,                 \
          mp= b | a<<8;         \
        } while (0)

#define RLC(r,r_) do  {         \
          st+= CBr_TICKS;               \
          if (altd) {           \
            ff_= r_*257>>7,     \
            fa_= 256            \
              | (fr_= r_= ff_), \
            fb_= 0;             \
          } else {              \
            ff= r*257>>7,       \
            fa= 256             \
              | (fr= r= ff),    \
            fb= 0;              \
          }                     \
        } while (0)

#define RRC(r,r_) do {               \
          st+= CBr_TICKS;               \
          if ( altd ) {              \
            ff_=  r_ >> 1            \
                | ((r_&1)+1 ^ 1)<<7, \
            fa= 256                  \
                | (fr_= r_= ff_),    \
            fb_= 0;                  \
          } else {                   \
            ff=  r >> 1              \
                | ((r&1)+1 ^ 1)<<7,  \
            fa= 256                  \
                | (fr= r= ff),       \
            fb= 0;                   \
          }                          \
        } while (0)

#define RL(r,r_)  do {            \
          st+= CBr_TICKS;               \
          if ( altd ) {           \
            ff_= r_ << 1          \
                | ff_  >> 8 & 1,  \
            fa_= 256              \
                | (fr_= r_= ff_), \
            fb_= 0;               \
          } else {                \
            ff= r << 1            \
                | ff  >> 8 & 1,   \
            fa= 256               \
                | (fr= r= ff),    \
            fb= 0;                \
          }                       \
        } while (0)

#define RR(r,r_) do {           \
          st+=CBr_TICKS;               \
          if ( altd ) {         \
            ff_= (r_*513 | ff_&256)>>1, \
            fa_= 256            \
                | (fr_= r_= ff_),  \
            fb_= 0;             \
          } else {              \
            ff= (r*513 | ff&256)>>1, \
            fa= 256             \
                | (fr= r= ff),  \
            fb= 0;              \
          }                     \
        } while (0)

#define SLA(r,r_) do {          \
          st+=CBr_TICKS;   \
          if (altd) {           \
            ff_= r_<<1,           \
            fa_= 256             \
                | (fr_= r_= ff_),  \
            fb_= 0;              \
          } else {              \
            ff= r<<1,           \
            fa= 256             \
                | (fr= r= ff),  \
            fb= 0;              \
          }                     \
        } while (0) 

#define SRA(r,r_) do {          \
          st+=CBr_TICKS; \
          if (altd) {           \
            ff_= (r_*513+128^128)>>1, \
            fa_= 256            \
                | (fr_= r_= ff_),  \
            fb_= 0;             \
          } else {              \
            ff= (r*513+128^128)>>1, \
            fa= 256             \
                | (fr= r= ff),  \
            fb= 0;              \
          }                     \
        } while (0)

#define SLL(r) do {             \
          if ( cansll() )       \
            st+= 8,             \
            ff= r<<1 | 1,       \
            fa= 256             \
              | (fr= r= ff),    \
            fb= 0;              \
        } while (0)

#define SWAP(r) do {            \
          r = (( r & 0xf0) >> 4) | (( r & 0x0f) << 4);  \
          st += 8;              \
        } while (0)

#define SRL(r,r_) do {          \
          st+=CBr_TICKS; \
          if (altd) {           \
            ff_= r_*513 >> 1,   \
            fa_= 256            \
                | (fr_= r_= ff_),  \
            fb_= 0;             \
          } else {              \
            ff= r*513 >> 1,     \
            fa= 256             \
                | (fr= r= ff),  \
            fb= 0;              \
          }                     \
        } while (0)

#define BIT(n, r) do {          \
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 6 : isr800() ? 2 : 8; \
          if (altd) {           \
            ff_= ff_  & -256    \
                | r   &   40    \
                | (fr_= r & n), \
            fa_= ~fr_,          \
            fb_= 0;             \
          } else {              \
            ff= ff  & -256      \
                | r   &   40    \
                | (fr= r & n),  \
            fa= ~fr,            \
            fb= 0;              \
          }                     \
        } while (0)

#define BITHL(n)                \
          st += isez80() ? 3 : israbbit() ? 7 : isz180() ? 9 : isgbz80() ? 16 : isr800() ? 3 : iskc160() ? 4 : 12, \
          t = get_memory_data(l | h<<8),     \
          ff= ff    & -256      \
            | mp>>8 &   40      \
            | -41   & (t&= n),  \
          fa= ~(fr= t),         \
          fb= 0

// 11T has already been added + index flag
#define BITI(n) do {               \
          st += isez80() ? -7 :israbbit() ? -1 : isz180() ? 4 : isr800() ? -6 : iskc160() ? - 7 : 5; \
          if ( altd ) {           \
            ff_= ff_    & -256    \
              | mp>>8 &   40      \
              | -41   & (t&= n);  \
            fa_= ~(fr_= t);       \
            fb_= 0;               \
          } else {                \
            ff= ff    & -256      \
              | mp>>8 &   40      \
              | -41   & (t&= n);  \
            fa= ~(fr= t);         \
            fb= 0;                \
          }                       \
        } while ( 0 )

#define RES(n, r)               \
          st += CBr_TICKS, \
          r&= n

#define RESHL(n)                \
          st += isez80() ? 3 : israbbit() ? 10 : isz180() ? 13 : isgbz80() ? 16 : isr800() ? 5 : iskc160() ? 6 : 15, \
          t = l|h<<8, \
          put_memory(t, get_memory_data(t) & n)

#define SET(n, r)               \
          st += CBr_TICKS, \
          r|= n

#define SETHL(n)                \
          st += isez80() ? 3 : israbbit() ? 10 : isz180() ? 13 : isgbz80() ? 16 :  isr800() ? 5 : iskc160() ? 6 : 15, \
          t = l|h<<8, \
          put_memory(t, get_memory_data(t) | n)

#define INR(r)                  \
          st+= isr800() ? 3 : 12,              \
          r= in(mp= b<<8 | c),  \
          ++mp,                 \
          ff= ff & -256         \
            | (fr= r),          \
          fa= r | 256,          \
          fb= 0

#define OUTR(r)                 \
          st+= isr800() ? 3 : 12,              \
          out(mp= c | b<<8, r), \
          ++mp

#define SBCHLRR(a, b)           \
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 10 : isr800() ? 2 : iskc160() ? 2 : 15, \
          v= l-b+((h-a)<<8)-(ff>>8&1),\
          mp= l+1+(h<<8),       \
          ff= v>>8,             \
          fa= h,                \
          fb= ~a,               \
          h= ff,                \
          l= v,                 \
          fr= h|l<<8

#define SUBHLRR(a, b) do {      \
          if (altd) {           \
            mp= l_+1+(h_<<8);   \
            v= l_-b+((h_-a)<<8),\
            ff_= v>>8,          \
            fa_= h,             \
            fb_= ~a,            \
            h= ff_,             \
            l= v,               \
            fr_= h_|l_<<8;          \
          } else {              \
            mp= l+1+(h<<8);     \
            v= l-b+((h-a)<<8),  \
            ff= v>>8,           \
            fa= h,              \
            fb= ~a,             \
            h= ff,              \
            l= v,               \
            fr= h|l<<8;         \
          }                     \
        } while(0)

#define ADCHLRR(a, b) do {      \
          st += isez80() ? 2 :israbbit() ? 4 : isz180() ? 10 : isr800() ? 2 : iskc160() ? 2 : 15; \
          v= l+b+((h+a)<<8)+(ff>>8&1);\
          mp= l+1+(h<<8);       \
          ff= v>>8;             \
          fa= h;                \
          fb= a;                \
          h= ff;                \
          l= v;                 \
          fr= h|l<<8;           \
        } while (0)


#define UNDOCUMENTED_NEG() do { \
        st+= 8;                 \
        fr= a= (ff= (fb= ~a)+1);\
        fa= 0;                  \
    } while (0)

#define UNDOCUMENTED_IM0() do { \
        st += 8; im = 0;        \
    } while (0)

#define UNDOCUMENTED_IM1() do { \
        st += 8; im = 1;        \
    } while (0)

#define UNDOCUMENTED_IM2() do { \
        st += 8; im = 2;        \
    } while (0)

#define UNDOCUMENTED_RETN() do { \
        RET(israbbit() ? 12 : isz180() ? 12 : 14);  \
    } while (0)

#define TEST(v, ticks) do {  \
      uint8_t olda = a;        \
      AND(v, 0);\
      a = olda;                \
      st += ticks;             \
    } while (0)

#define RABBIT4k_UNDEFINED() do { \
    fprintf(stderr, "Invalid R4K opcode at %04x", pc-1); \
} while(0)


#define RABBIT_UNDEFINED(addr,inst, t) do { \
    fprintf(stderr, "Invalid Rabbit opcode at %04x opcode=%x %s", pc-1,addr,inst); \
    st += t; \
} while(0)

// Get back the instruction prefix from ih and iy
#define PREFIX(ih,iy) (ih ? 0x00 : iy ? 0xfd : 0xdd)

FILE * ft;
unsigned char * tapbuf;

int     v
      , wavpos= 0
      , wavlen= 0
      , mues
      ;

unsigned short
        pc= 0
      , sp= 0
      , mp= 0
      , t= 0
      , u= 0
      , ff= 0
      , ff_= 0
      , fa= 0
      , fa_= 0
      , fb= 0
      , fb_= 0
      , fr= 0
      , fr_= 0
      , fk = 0
      ;
long long
        st= 0
      , sttap
      , stint
      , counter= 1e8
      ;
unsigned char
        a= 0
      , b= 0
      , c= 0
      , d= 0
      , e= 0
      , h= 0
      , l= 0
      , j=0
      , k=0
      , a_= 0
      , b_= 0
      , c_= 0
      , d_= 0
      , e_= 0
      , h_= 0
      , l_= 0
      , j_=0
      , k_=0
      , xl= 0
      , xh= 0
      , yl= 0
      , yh= 0
      , i= 0
      , r= 0
      , r7= 0
      , ih= 1
      , iy= 0
      , iff= 0
      , im= 0
      , w= 0
      , ear= 255
      , halted= 0
      , altd = 0
      , ioi = 0
      , ioe = 0
      ;


static void handle_r4k_7f_page(void);
static void handle_ed_page(void);
static void handle_cb_page(void);

char   cmd_arguments[255];
int    cmd_arguments_len = 0;

int    ioport = -1;
int    rom_size = 0;
int    rc2014_mode = 0;
int    c_autolabel = 0;
int    break_required = 0;



void exit_log(int code, char *fmt, ...)
{
    va_list  ap;

    va_start(ap, fmt);
    if ( fmt != NULL ) {
       fprintf(stderr, "ticks: ");
       vfprintf(stderr, fmt, ap);
    }

    va_end(ap);
    exit(code);
}

long tapcycles(void){
  mues= 1;
  wavpos!=0x20000 && (ear^= 64);
  if( wavpos>0x1f000 ) {
    fseek( ft, wavpos-0x20000, SEEK_CUR );
    wavlen-= wavpos;
    wavpos= 0;
    if (0x20000 != fread(tapbuf, 1, 0x20000, ft)) { fclose(ft); exit_log(1, "Routine tapcycles could not read required data\n"); }
  }
  while( (tapbuf[++wavpos]^ear<<1)&0x80 && wavpos<0x20000 )
    mues+= 81;  // correct value must be 79.365, adjusted to simulate contention in Alkatraz
  if( wavlen<=wavpos )
    return 0;
  else
    return mues;
}

int in(int port){
  int val;

  if ( (val = hook_console_in(port)) != -1 ) return val;
  if ( (val = apu_in(port)) != -1 ) return val;
  if ( (val = acia_in(port)) != -1 ) return val;

  return port&1 ? 255 : ear;
}

void out(int port, int value){
  if ( hook_console_out(port,value) == 0 ) return;
  if ( apu_out(port,value) == 0 ) return;
  if ( acia_out(port, value) == 0 ) return;

  memory_handle_paging(port, value);
}

int israbbit4k(void)
{
    return ((c_cpu & CPU_R4K) && rabbit_get_ioi_reg(RABBIT_EDMR) == 0xc0);
}

// In this file, use a macro for inlining
#define israbbit4k() ((c_cpu & CPU_R4K) && rabbit_get_ioi_reg(RABBIT_EDMR) == 0xc0)

int f(void){
    if ( is8085() ) {
        int pv = (fa & -256
                ? 154020 >> ((fr ^ fr >> 4) & 15)
                : ((fr ^ fa) & (fr ^ fb)) >> 5) & 4;

        // bit 0 = carry
        // bit 1 = V
        // bit 2 = parity
        // bit 3 = 0
        // bit 4 = half carry
        // bit 5 = K
        // bit 6 = zero
        // bit 7 = S
        return  ff & 128  // S bit 7
            | ff >> 8 & 1 // C bit 0, so value 256
            | !fr << 6    // Z, bit 6
            | fk << 5     // K, bit 5
            | (fr ^ fa ^ fb ^ fb >> 8) & 16 // H (half carry) bit 4
            | pv            // bit 2 parity
            | pv >> 1       // bit 1 v (cheat)
            ;
    } else {
        // bit 0 = carry
        // bit 1 = N (subtract flag)
        // bit 2 = P/V
        // bit 3 = copy of A
        // bit 4 = H half carry
        // bit 5 = copy of A
        // bit 6 = Z
        // bit 7 = S sign flag
      return  ff & 168  // S, 5, 3: bits 7, 5, 3
            | ff >> 8 & 1 // C bit 0, so value 256
            | !fr << 6    // Z, bit 6
            | fb >> 8 & 2 // N (subtract flag) bit 1, value 512
            | (fr ^ fa ^ fb ^ fb >> 8) & 16 // H (half carry) bit 4
            | (fa & -256
                ? 154020 >> ((fr ^ fr >> 4) & 15)
                : ((fr ^ fa) & (fr ^ fb)) >> 5) & 4; // P/V bit 2
                ;
    }
}

int f_(void){
  return  ff_ & 168
        | ff_ >> 8 & 1
        | !fr_ << 6
        | fb_ >> 8 & 2
        | (fr_ ^ fa_ ^ fb_ ^ fb_ >> 8) & 16
        | (fa_ & -256
            ? 154020 >> ((fr_ ^ fr_ >> 4) & 15)
            : ((fr_ ^ fa_) & (fr_ ^ fb_)) >> 5) & 4;
}

void setf(int a){
  fr= ~a & 64;
  ff= a|= a<<8;
  fa= 255 & (fb= a & -129 | (a&4)<<5);
  fk= (a&0x20)>>5;  // 8085 flag
}

// get each of the flags as bools, pass f() or f_() as argument
#define F_C(f)		(((f) & 1) == 1)
#define F_V(f)		(is8085() ? (((f) & 2) == 2) : (((f) & 4) == 4))
#define F_Z(f)		(((f) & 0x40) == 0x40)
#define F_S(f)		(((f) & 0x80) == 0x80)
#define F_GT(f)		((F_Z(f) | (F_S(f) ^ F_V(f))) == 0)
#define F_LT(f)		((F_S(f) ^ F_V(f)) == 1)
#define F_GTU(f)	(((F_C(f) == 0) && (F_Z(f)) == 0))

extern backend_t ticks_debugger_backend;

int main (int argc, char **argv){
  int size= 0, start= 0, end= 0, intr= 0, tap= 0, alarmtime = 0, load_address = 0, symbol_addr = -1;
  uint8_t opc;
  char * output= NULL;
  char  *memory_model = "standard";
  FILE * fh;

  hook_init();
  set_backend(ticks_debugger_backend);
  apu_reset();

  tapbuf= (unsigned char *) malloc (0x20000);
  if( argc==1 )
    printf("z88dk-ticks is derived from a silent Z80 emulator by Antonio Villena (v0.14c beta)\n\n"),
    printf("  z88dk-ticks [-x <file>] [-pc X] [-start X] [-end X] [-counter X] [-output <file>] <input_file>\n\n"),
    printf("  <input_file>   File between 1 and 65536 bytes with Z80 machine code\n"),
    printf("  -tape <file>   emulates ZX tape in port $FE from a .WAV file\n"),
    printf("  -trace         outputs register values and disassembly while executing\n"),
    printf("  -pc X          X in hexadecimal is the initial PC value\n"),
    printf("  -start X       X in hexadecimal is the PC condition to start the counter\n"),
    printf("  -end X         X in hexadecimal is the PC condition to exit\n"),
    printf("  -counter X     X in decimal is another condition to exit\n"),
    printf("  -int X         X in decimal are number of cycles for periodic interrupts\n"),
    printf("  -d             Enable debugger\n"),
    printf("  -v             Verbose logging\n"),
    printf("  -l X           Load file to address\n"),
    printf("  -b <model>     Memory model (zxn/zx/z180)\n"),
    printf("  -m8080         Emulate an 8080\n"),
    printf("  -m8085         Emulate an 8085 (mostly)\n"),
    printf("  -mgbz80        Emulate a gbz80 (mostly)\n"),
    printf("  -mz80          Emulate a z80\n"),
    printf("  -mz80_strict   Emulate a z80\n"),
    printf("  -mz180         Emulate a z180\n"),
    printf("  -mr2ka         Emulate a Rabbit 2000\n"),
    printf("  -mr3k          Emulate a Rabbit 3000\n"),
    printf("  -mr4k          Emulate a Rabbit 4000\n"),
    printf("  -mr5k          Emulate a Rabbit 5000\n"),
    printf("  -mz80n         Emulate a Spectrum Next z80n\n"),
    printf("  -mez80_z80     Emulate an ez80 (z80 mode)\n"),
    printf("  -mr800         Emulate a r800 (ticks may not be accurate)\n"),
    printf("  -mkc160        Emulate a kc160\n"),
    printf("  -mkc160_z80    Emulate a kc160 (z80 mode)\n"),
    printf("  -ide0 <file>   Set file to be ide device 0\n"),
    printf("  -ide1 <file>   Set file to be ide device 1\n"),
    printf("  -iochar X      Set port X to be character input/output\n"),
    printf("  -output <file> dumps the RAM content to a 64K file\n"),
    printf("  -rom X         write-protect memory, X in hexadecimal is first RAM address\n"),
    printf("  -w X           Maximum amount of running time (400000000 cycles per unit)\n"),
    printf("  -x <file>      Symbol or map file to read\n"),
	printf("  -script <file> Script file to run at the console\n"),
    printf("                 Use before -pc,-start,-end to enable symbols\n\n"),
    printf("  Default values for -pc, -start and -end are 0000 if omitted.\n"),
    printf("  When the program exits, it'll show the number of cycles between start and end trigger in decimal\n\n"),
    exit(EXIT_SUCCESS);
  while (argc > 1){
    if( argv[1][0] == '-' && argv[2] )
      switch (argc--, argv++[1][1]){
        case 'w':
          alarmtime = strtol(argv[1], NULL, 10);
          counter = 400000000LL * alarmtime;
          break;
        case 'b':
          memory_model = argv[1];
          break;
        case 'p':
          symbol_addr= symbol_resolve(argv[1], NULL);
          pc= (-1 == symbol_addr) ? strtol(argv[1], NULL, 16) : symbol_addr;
          break;
        case 's':
			if (strcmp(&argv[0][1], "start") == 0) {
				symbol_addr = symbol_resolve(argv[1], NULL);
				start = (-1 == symbol_addr) ? strtol(argv[1], NULL, 16) : symbol_addr;
			}
			else if (strcmp(&argv[0][1], "script") == 0) {
				script_file = argv[1];
			}
          break;
        case 'e':
          symbol_addr= symbol_resolve(argv[1], NULL);
          end= (-1 == symbol_addr) ? strtol(argv[1], NULL, 16) : symbol_addr;
          break;
        case 'r':
          rom_size= strtol(argv[1], NULL, 16);
          break;
        case 'i':
          if ( strcmp(&argv[0][1], "ide0") == 0 ) {
            hook_io_set_ide_device(0, argv[1]);
          } else if ( strcmp(&argv[0][1], "ide1") == 0 ) {
            hook_io_set_ide_device(1, argv[1]);
          } else if ( strcmp(&argv[0][1], "iochar") == 0 ) {
            ioport = strtol(argv[1], NULL, 10);
          } else {
            intr= strtol(argv[1], NULL, 10);
          }
          break;
        case 'l':
          load_address = pc = strtol(argv[1], NULL, 0);
          break;
        case 'c':
          sscanf(argv[1], "%llu", &counter);
          counter<0 && (counter= 9e18);
          break;
        case 'd':
          debugger_active = 1;
          debugger_init();
          argv--;
          argc++;
          break;
        case 'v':
          verbose = 1;
          argv--;
          argc++;
          break;
        case 'x':
          read_symbol_file(argv[1]);
          break;
        case 'm':
          if ( strcmp(&argv[0][1],"mz80") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"mz80_strict") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"m8080") == 0 ) {
            c_cpu = CPU_8080;
          } else if ( strcmp(&argv[0][1],"m8085") == 0 ) {
            c_cpu = CPU_8085;
          } else if ( strcmp(&argv[0][1],"mz180") == 0 ) {
            c_cpu = CPU_Z180;
          } else if ( strcmp(&argv[0][1],"mz80n") == 0 ) {
            c_cpu = CPU_Z80N;
            memory_model = "zxn";
          } else if ( strcmp(&argv[0][1],"mr2ka") == 0 ) {
            c_cpu = CPU_R2KA;
          } else if ( strcmp(&argv[0][1],"mr3k") == 0 ) {
            c_cpu = CPU_R3K;
          } else if ( strcmp(&argv[0][1],"mr4k") == 0 ) {
            c_cpu = CPU_R4K;
          } else if ( strcmp(&argv[0][1],"mr5k") == 0 ) {
            c_cpu = CPU_R4K;
          } else if ( strcmp(&argv[0][1],"mez80_z80") == 0 ) {
            c_cpu = CPU_EZ80;
          } else if ( strcmp(&argv[0][1],"mgbz80") == 0 ) {
            c_cpu = CPU_GBZ80;
          } else if ( strcmp(&argv[0][1],"mr800") == 0 ) {
            c_cpu = CPU_R800;
          } else if ( strcmp(&argv[0][1],"mkc160") == 0 ) {
            c_cpu = CPU_KC160;
          } else if ( strcmp(&argv[0][1],"mkc160_z80") == 0 ) {
            c_cpu = CPU_KC160_Z80;
          } else {
            fprintf(stderr, "\nUnknown CPU: %s\n",&argv[0][1]);
            exit(EXIT_FAILURE);
          }
          argv--;
          argc++;
          break;
        case 'o':
          output= argv[1];
          break;
        case 't':
          if (strcmp(&argv[0][1], "tape") == 0) {
            ft= fopen(argv[1], "rb");
            if( !ft )
              fprintf(stderr, "\nTape file not found: %s\n", argv[1]),
              exit(EXIT_FAILURE);
            if (0x20000 != fread(tapbuf, 1, 0x20000, ft)) { fclose(ft); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
            memcpy(&wavlen, tapbuf+4, 4);
            wavlen+= 8;
            if( *(int*) tapbuf != 0x46464952 )
              fprintf(stderr, "\nInvalid WAV header\n"),
              exit(EXIT_FAILURE);
            if( *(int*)(tapbuf+16) != 16 )
              fprintf(stderr, "\nInvalid subchunk size\n"),
              exit(EXIT_FAILURE);
            if( *(int*)(tapbuf+20) != 0x10001 )
              fprintf(stderr, "\nInvalid number of channels or compression (only Mono and PCM allowed)\n"),
              exit(EXIT_FAILURE);
            if( *(int*)(tapbuf+24) != 44100 )
              fprintf(stderr, "\nInvalid sample rate (only 44100Hz allowed)\n"),
              exit(EXIT_FAILURE);
            if( *(int*)(tapbuf+32) != 0x80001 )
              fprintf(stderr, "\nInvalid align or bits per sample (only 8-bits samples allowed)\n"),
              exit(EXIT_FAILURE);
            if( *(int*)(tapbuf+40)+44 != wavlen )
              fprintf(stderr, "\nInvalid header size\n"),
              exit(EXIT_FAILURE);
            wavpos= 44;
          }
          else if (strcmp(&argv[0][1], "trace") == 0) {
            debugger_active = 0;
            trace = 1;
            argv--;
            argc++;
          }
          else {
            fprintf(stderr, "\nWrong Argument: %s\n", argv[0]);
            exit(EXIT_FAILURE);
          }
          break;
		case '-':
          while ( argc > 1 ) {
            // I think windows is now comformant with snprintf? Either way, we can't grow the arugment buffer...
            cmd_arguments_len += snprintf(cmd_arguments + cmd_arguments_len, sizeof(cmd_arguments) - cmd_arguments_len, "%s%s",cmd_arguments_len > 0 ? " " : "", argv[1]);
            argc--;
            argv++;
          }
          if ( pc == 256 ) {
            put_memory(0x80,cmd_arguments_len % 256);
            memcpy(get_memory_addr(0x81,MEM_TYPE_DATA), cmd_arguments, cmd_arguments_len % 256);
          } else {
            put_memory(65280,cmd_arguments_len % 256);
            memcpy(get_memory_addr(65281, MEM_TYPE_DATA), cmd_arguments, cmd_arguments_len % 256);
          }
          break;
        default:
          fprintf(stderr, "\nWrong Argument: %s\n", argv[0]);
          exit(EXIT_FAILURE);
      }
    else{
      if ( israbbit() )
        memory_model = "rabbit";
      memory_init(memory_model);

      fh= fopen(argv[1], "rb");
      if( !fh )
        fprintf(stderr, "\nFile not found: %s\n", argv[1]),
        exit(EXIT_FAILURE);
      fseek(fh, 0, SEEK_END);
      size= ftell(fh);
      rewind(fh);
      if( size>65536 && size!=65574 )
        fprintf(stderr, "\nIncorrect length: %d\n", size),
        exit(EXIT_FAILURE);
      else if( strstr(argv[1], "rc2014") != NULL ) {
        *get_memory_addr(0x08, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(0x09, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(0x0a, MEM_TYPE_INST) = 0xC9;
        *get_memory_addr(0x10, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(0x11, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(0x12, MEM_TYPE_INST) = 0xC9;
        *get_memory_addr(0x18, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(0x19, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(0x1a, MEM_TYPE_INST) = 0xC9;
        rc2014_mode = 1;
        if (1 != fread(get_memory_addr(pc, MEM_TYPE_INST), size, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      } else if( !strcasecmp(strchr(argv[1], '.'), ".com" ) ){
        *get_memory_addr(5, MEM_TYPE_INST) = 0xED;
        *get_memory_addr(6, MEM_TYPE_INST) = 0xFE;
        *get_memory_addr(7, MEM_TYPE_INST) = 0xC9;
        pc = 256;
        // CP/M emulator
        if (1 != fread(get_memory_addr(256, MEM_TYPE_INST), size, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      } else if( !strcasecmp(strchr(argv[1], '.'), ".sna" ) && size==49179 ){
        FILE *fk= fopen("48.rom", "rb");
        if( !fk )
          fprintf(stderr, "\nZX Spectrum ROM file not found: 48.rom\n"),
          exit(EXIT_FAILURE);
        if (16384 != fread(get_memory_addr(0, MEM_TYPE_INST), 1, 16384, fk)) { fclose(fk); exit_log(1, "Could not read required data from <48.rom>\n"); }
        fclose(fk);
        if (1 != fread(&i,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&l_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&h_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&e_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&d_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&c_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&b_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&w,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        setf(w);
        ff_= ff;
        fr_= fr;
        fa_= fa;
        fb_= fb;
        if (1 != fread(&a_,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&l,   1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&h,   1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&e,   1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&d,   1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&c,   1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&b,   1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&yl,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&yh,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&xl,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&xh,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&iff, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        iff>>= 2;
        if (1 != fread(&r, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        r7= r;
        if (1 != fread(&w,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        setf(w);
        if (1 != fread(&a,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&sp, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&im, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&w,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (0xc000 != fread(get_memory_addr(0x4000, MEM_TYPE_INST), 1, 0xc000, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        RET(0);
      }
      else if( size==65574 ) {
        if (65536 != fread(get_memory_addr(0, MEM_TYPE_INST), 1, 65536, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }

        if (1 != fread(&w, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        u= w;
        if (1 != fread(&a,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&c,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&b,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&l,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&h,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&pc, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&sp, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&i,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&r,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        r7= r;
        if (1 != fread(&e,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&d,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&c_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&b_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&e_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&d_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&l_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&h_, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&w,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        setf(w);
        ff_= ff;
        fr_= fr;
        fa_= fa;
        fb_= fb;
        setf(u);
        if (1 != fread(&a_,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&yl,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&yh,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&xl,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&xh,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&iff, 1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&im,  1, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
        if (1 != fread(&mp,  2, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
      }
      else {
        int l;
        for ( l = 0; l < size; l++ ) {
          *get_memory_addr(load_address+l, MEM_TYPE_INST) = fgetc(fh);
        }
      }
    }
    ++argv;
    --argc;
  }
  if( size==65574 ){
    if (1 != fread(&wavpos, 4, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
    ear= wavpos<<6 | 191;
    wavpos>>= 1;
    if( wavpos && ft ) {
      fseek(ft, wavlen-wavpos, SEEK_SET);
      wavlen= wavpos;
      wavpos= 0;
      if (0x20000 != fread(tapbuf, 1, 0x20000, ft)) { fclose(ft); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
    }
    if (1 != fread(&sttap, 4, 1, fh)) { fclose(fh); exit_log(1, "Could not read required data from <%s>\n", argv[1]); }
    tap= sttap;
  }
  else
    sttap= tap= tapcycles();
  fclose(fh);
  if (!size) {
    fprintf(stderr, "\nFile not specified or zero length\n");
    exit(EXIT_FAILURE);
  }
  stint= intr;


  do{
    if ( ih ) {
        if (break_required) {
            break_required = 0;
            debugger_request_a_break();
        }
        debugger();
    }
    if( pc==start )
      st= 0,
      stint= intr,
      sttap= tap;
    if( intr && st>stint && ih ){
      stint= st+intr;
      if( iff ){
        halted && (pc++, halted= 0);
        iff= 0;
        put_memory(--sp,pc>>8);
        put_memory(--sp,pc);
        r++;
        switch( im ){
          case 1:
            st++;
          case 0:
            pc= 56;
            st+= 12;
            break;
          default:
            pc= get_memory_data(t= 255 | i << 8);
            pc|= get_memory_data(++t) << 8;
            st+= 19;
        }
      }
    }
    if( tap && st>sttap )
      sttap= st+( tap= tapcycles() );
    r++;
    switch( (opc = get_memory_inst(pc++)) ){
      case 0x00: // NOP
        st+= israbbit() ? 2 : isz180() ? 3 : iskc160() ? 1 : isr800() ? 1 : 4;
        ih=1;altd=0;ioi=0;ioe=0;break;
        break;
      case 0x40: // LD B,B
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if ( altd ) { b_ = b; st += 2; ih=1;altd=0;ioi=0;ioe=0;break; }
      case 0x49: // LD C,C
        if (israbbit4k() && ih == 0) r4k_rlc_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if ( altd ) { c_ = c; st += 2; ih=1;altd=0;ioi=0;ioe=0;break; }
      case 0x52: // LD D,D
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if ( altd ) { d_ = d; st += 2; ih=1;altd=0;ioi=0;ioe=0;break; }
      case 0x5b: // LD E,E
        if ( altd ) { e_ = e; st += 2; ih=1;altd=0;ioi=0;ioe=0;break; }
      case 0x64: // LD H,H // (RCM) LDP (XY),HL
        if ( israbbit() && ih==0) rxk_ldp_irr_hl(opc, PREFIX(ih, iy));
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if ( altd ) { h_ = h; st += 2; ih=1;altd=0;ioi=0;ioe=0;break; }
      case 0x6d: // LD L,L // (RCM) LDP IXY,(nm) // 6d page
        if ( israbbit() && ih==0) rxk_ldp_rr_inm(opc, PREFIX(ih, iy));
        else if ( israbbit4k() ) { // 0x6d page
            r4k_handle_6d_page();
            ih=1;altd=0;ioi=0;ioe=0;break; 
        } else if ( altd ) { l_ = l; st += 2; ih=1;altd=0;ioi=0;ioe=0;break; }
      case 0x7f: // LD A,A
        if ( israbbit4k() ) { // 0x7f page
            if (ih==0) r4k_rrb_a_r32(opc, iy);
            else handle_r4k_7f_page();
        } else {
          if ( altd ) { a_ = a; st += 2; break; }
          st+= LDrr_TICKS;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x76: // HALT
        if ( israbbit() ) { // ALTD
          altd = 1;
          st += 2;
        } else {
          st+= is8080() ? 7 : is8085() ? 5 : isz180() ? 3 : iskc160() ? 2 : 4;
          halted= 1;
          pc--;
          altd=0;ioi=0;ioe=0;
        }
        ih=1;
        break;
      case 0x01: // LD BC,nn
        if ( altd ) LDRRIM(b_,c_);
        else LDRRIM(b, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x11: // LD DE,nn
        if ( altd ) LDRRIM(d_,e_);
        else LDRRIM(d, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x21: // LD HL,nn // LD IX,nn // LD IY,nn
        if( ih ) {
          if ( altd ) LDRRIM(h_,l_);
          else LDRRIM(h, l);
        } else if( iy )
          LDRRIM(yh, yl);
        else
          LDRRIM(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x31: // LD SP,nn / (EZ80) ld iy,(ix+d)
        if ( isez80() && ih == 0 ) ez80_ld_xy_ixyd(opc, PREFIX(ih,iy)); // LD IY,(ix+d)
        else {
            st+= israbbit() ? 6 : isgbz80() ? 12 : isz180() ? 9 : isez80() ? 3 : isr800() ? 3 : iskc160() ? 2 : 10;
            sp= get_memory_inst(pc++);
            sp|= get_memory_inst(pc++)<<8;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x02: // LD (BC),A
        LDPR(b, c, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x12: // LD (DE),A
        LDPR(d, e, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0a: // LD A,(BC) // (R4K) LDF BCDE,(lmn) LDF JKH L,(lmn)
        if (israbbit4k() && ih==0) r4k_ldf_r32_ilmn(opc, iy);
        else if ( altd ) LDRP(b, c, a_);
        else LDRP(b, c, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1a: // LD A,(DE) // (R4K) LD BCDE,(HL), LD JKHL,(HL)
        if ( israbbit4k() && ih== 0) r4k_ld_r32_ihl(opc,iy);
        else if ( altd ) LDRP(d, e, a_);
        else LDRP(d, e, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x22: // LD (nn),HL // LD (nn),IX // LD (nn),IY
        if ( isgbz80() ) { // ld (hl+),a
          long long save = st;
          LDPR(h, l, a);
          INCW(h,l);
          st = save + 8;
          break;
        } else if (ih) {
          LDPNNRR(h, l,isez80() ? 5 : israbbit() ? 13 : iskc160() ? 3 : 16);
        } else if( iy )
          LDPNNRR(yh, yl,isez80() ? 5 : israbbit() ? 13 : iskc160() ? 4 : 16);
        else
          LDPNNRR(xh, xl, isez80() ? 5 :israbbit() ? 13 : iskc160() ? 4 : 16);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x32: // LD (nn),A
        if ( isgbz80() ) { // ld (hl-),a
          long long save = st;
          LDPR(h, l, a);
          DECW(h,l);
          st = save + 8;
        } else {
            st+= isez80() ? 4 : israbbit() ? 10 : isr800() ? 4 : iskc160() ? 3 :13;
            t= get_memory_inst(pc++);
            put_memory(t|= get_memory_inst(pc++)<<8,a);
            mp= t+1 & 255
                | a<<8;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2a: // LD HL,(nn) // LD IX,(nn) // LD IY,(nn)
        if ( isgbz80() ) { // ld a,(hl+)
          long long save = st;
          LDRP(h, l, a);
          INCW(h,l);
          st = save + 8;
          break;
        } else if( ih ) {
          if ( altd ) LDRRPNN(h_, l_, 11);
          else LDRRPNN(h, l, isez80() ? 5 : israbbit() ? 11 : isz180() ? 15 : isr800() ? 5 : iskc160() ? 3 : 16);
        } else if( iy )
          LDRRPNN(yh, yl, isez80() ? 6: israbbit() ? 11 : isz180() ? 15 :isr800() ? 5 : iskc160() ? 4 : 16);
        else
          LDRRPNN(xh, xl, isez80() ? 6 : israbbit() ? 11 : isz180() ? 15 :isr800() ? 5 : iskc160() ? 5 : 16);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3a: // LD A,(nn)
        if ( isgbz80() ) { // ld a,(hl-)
          long long save = st;
          LDRP(h, l, a);
          DECW(h,l);
          st = save + 8;
        } else {
            st+= isez80() ? 4 : israbbit() ? 9 : isz180() ? 12 : isr800() ? 4 : iskc160() ? 3 : 13;
            mp= get_memory_inst(pc++);
            if ( altd ) a_ = get_memory_data(mp|= get_memory_inst(pc++)<<8);
            else a= get_memory_data(mp|= get_memory_inst(pc++)<<8);
            ++mp;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x03: // INC BC
        if ( altd ) INCW(b_,c_);
        else INCW(b, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
        break;
      case 0x13: // INC DE
        if ( altd ) INCW(d_,e_);
        else INCW(d, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x23: // INC HL // INC IX // INC IY
        if( ih ) {
          if ( altd ) INCW(h_,l_);
          else INCW(h, l);
        } else if( iy )
          INCW(yh, yl);
        else
          INCW(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x33: // INC SP
        st+= isez80() ? 1 : isgbz80() ? 8 : is8080() ? 5 : isr800() ? 1 : iskc160() ? 1 : 6;
        sp++;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0b: // DEC BC / (R4K) LDF (lmn),BCDE LDF (lmn),JKHL
        if (israbbit4k() && ih==0) r4k_ldf_ilmn_r32(opc, iy);
        else if ( altd ) DECW(b_,c_);
        else DECW(b, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1b: // DEC DE // (R4k) LD (HL),BCDE, LD (HL),JKHL
        if (israbbit4k() && ih==0) r4k_ld_ihl_r32(opc, iy);
        else if ( altd ) DECW(d_,e_);
        else DECW(d, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2b: // DEC HL // DEC IX // DEC IY
        if( ih ) {
          if ( altd ) DECW(h_,l_);
          else DECW(h, l);
        } else if( iy )
          DECW(yh, yl);
        else
          DECW(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3b: // DEC SP
        st+= isez80() ? 1 : israbbit() ? 2 : isgbz80() ? 8 : is8080() ? 5 : isr800() ? 1 : iskc160() ? 1 : 6;
        sp--;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x04: // INC B
        INC(b,b_);
        ih=1;altd=0;ioi=0;ioe=0;break;
        break;
      case 0x0c: // INC C // (R4K) LD BCDE,(PW+HL), LD JKHL(PW+HL)
        if (israbbit4k() && ih==0) r4k_ld_r32_ipshl(opc,iy);
        else INC(c,c_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x14: // INC D
        INC(d,d_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1c: // INC E // (R4K) LD BCDE,(PX+HL), LD JKHL(PX+HL)
        if (israbbit4k() && ih==0) r4k_ld_r32_ipshl(opc,iy);
        else INC(e,e_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x24: // INC H // INC IXh // INC IYh
        if( ih ) {
          INC(h,h_);
        } else if( iy && canixh() )
          INC(yh,yh);
        else if ( canixh() )
          INC(xh,xh);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2c: // INC L // INC IXl // INC IYl // (R4K) LD BCDE,(PY+HL), LD JKHL(PY+HL)
        if (israbbit4k() && ih==0) r4k_ld_r32_ipshl(opc,iy);
        else if( ih ) {
          INC(l,l_);
        } else if( iy && canixh() )
          INC(yl,yl);
        else if ( canixh() )
          INC(xl,xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x34: // INC (HL) // INC (IX+d) // INC (IY+d)
        SUSPECT_IMPL("altd should affect flags")
        if( ih )
          st+=isez80() ? 4 : israbbit() ? 8 : is808x() ? 10 : isgbz80() ? 12 : isr800() ? 4 : iskc160() ? 5 : 11,
          fa= get_memory_data(t= l | h<<8),
          ff= ff&256
            | (fr= put_memory(t,fa+(fb=+1)));
        else if( iy )
          { INCPI(yh, yl); st += iskc160() ? 1 : 0; }
        else
          { INCPI(xh, xl); st += iskc160() ? 1 : 0; }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3c: // INC A // (R4K) LD BCDE,(PZ+HL), LD JKHL(PZ+HL)
        if (israbbit4k() && ih==0) r4k_ld_r32_ipshl(opc,iy);
        else INC(a,a_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x05: // DEC B
        DEC(b,b_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0d: // DEC C // (R4K) LD (PW+HL), BCDE, LD (PW+HL),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdhl_r32(opc, iy);
        else DEC(c,c_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x15: // DEC D
        DEC(d,d_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1d: // DEC E // (R4K) LD (PX+HL), BCDE, LD (PX+HL),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdhl_r32(opc, iy);
        else DEC(e,e_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x25: // DEC H // DEC IXh // DEC IYh
        if( ih )
          DEC(h,h_);
        else if( iy && canixh())
          DEC(yh,yh);
        else if ( canixh())
          DEC(xh,xh);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2d: // DEC L // DEC IXl // DEC IYl // (R4K) LD (PY+HL), BCDE, LD (PY+HL),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdhl_r32(opc, iy);
        else if( ih )
          DEC(l,l_);
        else if( iy && canixh())
          DEC(yl,yl);
        else
          DEC(xl,xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x35: // DEC (HL) // DEC (IX+d) // DEC (IY+d)
        SUSPECT_IMPL("altd should affect flags")
        if( ih )
          st+=isez80() ? 4 : israbbit() ? 8 : is808x() ? 10 : isgbz80() ? 12 : isr800() ? 4 : iskc160() ? 5 : 11,
          fa= get_memory_data(t= l | h<<8),
          ff= ff&256
            | (fr= put_memory(t,fa+(fb=-1)));
        else if( iy )
          { DECPI(yh, yl); st += iskc160() ? 1 : 0; }
        else
          { DECPI(xh, xl); st += iskc160() ? 1 : 0; }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3d: // DEC A // (R4K) LD (PZ+HL), BCDE, LD (PZ+HL),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdhl_r32(opc, iy);
        else DEC(a,a_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x06: // LD B,n // (R4K) LD A,(IXY+A)
        if ( israbbit4k() && ih==0 && iy==1) r4k_ld_a_ixya(opc, yl, yh);
        else if ( israbbit4k() && ih==0 && iy==0) r4k_ld_a_ixya(opc, xl, xh);
        else LDRIM(b,b_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0e: // LD C,n // (R4K) LD BCDE,(PW+d), LD JKHL,(PW+d)
        if ( israbbit4k() && ih==0) r4k_ld_r32_ipsd(opc,iy);
        else LDRIM(c,c_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x16: // LD D,n
        LDRIM(d,d_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1e: // LD E,n // (R4K) LD BCDE,(PX+d), LD JKHL,(PX+d)
        if ( israbbit4k() && ih==0) r4k_ld_r32_ipsd(opc,iy);
        else LDRIM(e,e_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x26: // LD H,n // LD IXh,n // LD IYh,n
        if( ih ) {
          LDRIM(h,h_);
        } else if( iy && canixh() )
          LDRIM(yh,yh);
        else if ( canixh() )
          LDRIM(xh,xh);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2e: // LD L,n // LD IXl,n // LD IYl,n // (R4K) LD BCDE,(PY+d), LD JKHL,(PY+d)
        if ( israbbit4k() && ih==0) r4k_ld_r32_ipsd(opc,iy);
        else if( ih ) {
          LDRIM(l,l_);
        } else if( iy && canixh() )
          LDRIM(yl,yl);
        else if ( canixh() )
          LDRIM(xl,xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x36: // LD (HL),n // LD (IX+d),n // LD (IY+d),n
        if( ih )
          st+= israbbit() ? 7 : isgbz80() ? 12 : isz180() ? 9 : isr800() ? 3 : iskc160() ? 3 : 10,
          put_memory(l|h<<8,get_memory_inst(pc++));
        else if( iy )
          LDPIN(yh, yl);
        else
          LDPIN(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3e: // LD A,n / (EZ80) ld (ix+d),iy (prefixed) // (R4K) LD BCDE,(PZ+d), LD JKHL,(PZ+d)
        if ( israbbit4k() && ih==0) r4k_ld_r32_ipsd(opc,iy);
        else if ( isez80() && ih == 0 ) ez80_ld_ixyd_xy(opc, PREFIX(ih,iy)); // LD (ix+d),iy
        else LDRIM(a,a_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x07: // RLCA / (EZ80) ld bc,(ix+d) (prefixed)
        if ( isez80() && ih == 0 ) ez80_ld_rr_ixyd(opc, PREFIX(ih, iy)); // LD BC,(ix+d)
        else {
            st+= isez80() ? 1 :  israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
            a_= t= a_*257>>7;
            ff_= ff_&215
                | t &296;
            fb_= fb_      &128
                | (fa_^fr_) & 16;
            } else {
            a= t= a*257>>7;
            ff= ff&215
                | t &296;
            fb= fb      &128
                | (fa^fr) & 16;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0f: // RRCA / (EZ80) ld (ix+d),bc (prefixed) // (R4K) LD (PW+d),BCDE, LD (PW+d),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdd_r32(opc,iy);
        else if ( isez80() && ih == 0 ) ez80_ld_ixyd_rr(opc, PREFIX(ih,iy)); // LD (ix+d), BC
        else {
            st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
            a_= t= a_>>1
                | ((a_&1)+1^1)<<7;
            ff_= ff_&215
                | t &296;
            fb_= fb_      &128
                | (fa_^fr_) & 16;
            } else {
            a= t= a>>1
                | ((a&1)+1^1)<<7;
            ff= ff&215
                | t &296;
            fb= fb      &128
                | (fa^fr) & 16;
            }
            fk=0;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x17: // RLA,  (EZ80) ld de,(ix+d) (prefixed)
        if ( isez80() && ih == 0 ) ez80_ld_rr_ixyd(opc, PREFIX(ih, iy)); // LD DE,(ix+d)
        else {
            st+= isez80() ? 1 :  israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
                a_= t= a_<<1
                    | ff_>>8 & 1;
                ff_= ff_&215
                    | t &296;
                fb_= fb_      & 128
                    | (fa_^fr_) &  16;
            } else {
                a= t= a<<1
                    | ff>>8 & 1;
                ff= ff&215
                    | t &296;
                fb= fb      & 128
                    | (fa^fr) &  16;
            }
            fk=0;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1f: // RRA / (EZ80) ld (ix+d),de (prefixed) // (R4K) LD (PX+d),BCDE, LD (PX+d),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdd_r32(opc,iy);
        else if ( isez80() && ih == 0 ) ez80_ld_ixyd_rr(opc, PREFIX(ih,iy)); // LD (ix+d),DE
        else {
            st+= isez80() ? 1 : israbbit() ? 2 :isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
                a_= t= (a_*513 | ff_&256)>>1;
                ff_= ff_&215
                    | t &296;
                fb_= fb_      &128
                    | (fa_^fr_) & 16;
            } else {
                a= t= (a*513 | ff&256)>>1;
                ff= ff&215
                    | t &296;
                fb= fb      &128
                    | (fa^fr) & 16;
                fk=0;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x09: // ADD HL,BC // ADD IX,BC // ADD IY,BC
        if( ih ) {
          if ( altd ) ADDRRRR_ALTD(h, l, b, c, h_, l_);
          else ADDRRRR(h, l, b, c);
        } else if( iy ) {
          if ( altd ) ADDRRRR_ALTD(yh, yl, b, c, yh, yl);
          else ADDRRRR(yh, yl, b, c);
        } else {
          if ( altd ) ADDRRRR_ALTD(xh, xl, b, c, xh, xl);
          else ADDRRRR(xh, xl, b, c);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x19: // ADD HL,DE // ADD IX,DE // ADD IY,DE
        if( ih ) {
          if ( altd ) ADDRRRR_ALTD(h, l, d, e, h_, l_);
          ADDRRRR(h, l, d, e);
        } else if( iy ) {
          if ( altd ) ADDRRRR_ALTD(yh, yl, d, e, yh, yl);
          else ADDRRRR(yh, yl, d, e);
        } else {
          if ( altd ) ADDRRRR_ALTD(xh, xl, d, e, xh, xl);
          else ADDRRRR(xh, xl, d, e);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x29: // ADD HL,HL // ADD IX,IX // ADD IY,IY
        if( ih ) {
          if ( altd ) ADDRRRR_ALTD(h, l, h, l, h_, l_);
          else ADDRRRR(h, l, h, l);
        } else if( iy ) {
          if ( altd ) ADDRRRR_ALTD(yh, yl, yh, yl, yh, yl);
          else ADDRRRR(yh, yl, yh, yl);
        } else {
          if ( altd ) ADDRRRR_ALTD(xh, xl, xh, xl, xh, xl);
          else ADDRRRR(xh, xl, xh, xl);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x39: // ADD HL,SP // ADD IX,SP // ADD IY,SP
        if( ih ) {
          if ( altd ) ADDISP_ALTD(h, l, h_, l_);
          else ADDISP(h, l);
        } else if( iy ) {
          if ( altd ) ADDISP_ALTD(yh, yl, yh, yl);
          else ADDISP(yh, yl);
        } else {
          if ( altd ) ADDISP_ALTD(xh, xl, xh, xl);
          ADDISP(xh, xl);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x18: // JR
        if ( is8085() ) { // (8085) RL DE (RDEL)
          long long savest = st;
          RL(e,e);
          RL(d,d);
          st = savest;
          st+=10;
        } else if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 opcode JR\n",pc-1);
          st+=4;
        } else {
            st+= isez80() ? 3 : isgbz80() ? 8 : isz180() ? 8 : isr800() ? 3 : iskc160() ? 3 : 12;
            mp= pc+= (get_memory_inst(pc)^128)-127;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x20: // JR NZ,s8
        if ( is8085() ) i8085_rim(opc); // (8085) RIM
        else if ( is808x() ) {
          printf("%04x: ILLEGAL 8080 opcode JR NZ\n",pc-1);
          st+=4;
          break;
        } else JRCI(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x28: // JR Z,s8
        if ( is8085() ) i8085_ld_de_hln(opc);  // (8085) ld de,hl+nn (LDHI)
        else if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 opcode JR Z\n",pc-1);
          st+=4;
        } else JRC(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x30: // JR NC,s8
        if ( is8085() ) i8085_sim(opc); // (8085) SIM
        else if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 opcode JR NC\n",pc-1);
          st+=4;
        } else JRC(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x38: // JR C,s8
        if ( is8085() ) i8085_ld_de_spn(opc);  // (8085) LD DE,SP+nn (LDSI)
        else if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 opcode JR C\n",pc-1);
          st+=4;
        } else JRCI(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x08: // EX AF,AF'
        if ( is8085() ) i8085_sub_hl_bc(opc);  // (8085) SUB HL,BC (DSUB)
        else if ( is8080()) {
          printf("%04x: ILLEGAL 8080 opcode EX AF,AF\n",pc-1);
          st+= 4;
        } else if ( isgbz80() ) { gbz80_ld_inm_sp();
        } else {
            st+= israbbit() ? 2 : isez80() ? 1 : isr800() ? 1 : iskc160() ? 1 : 4;
            t  =  a_;
            a_ =  a;
            a  =  t;
            t  =  ff_;
            ff_=  ff;
            ff =  t;
            t  =  fr_;
            fr_=  fr;
            fr =  t;
            t  =  fa_;
            fa_=  fa;
            fa =  t;
            t  =  fb_;
            fb_=  fb;
            fb =  t;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x10: // DJNZ
        if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 opcode DJNZ\n",pc-1);
          st+=4;
          break;
        } else if ( is8085() ) {   // (8085) SRA HL (ARHL)
          SRA(h,h);
          RR(l,l);
          st += (-16 + 7);
          break;
        } else if ( isgbz80() ) {  // STOP
          t = get_memory_inst(pc++);    // collect and ignore 00 byte
          st += 4;
          end = pc; // stop simulation
          break;
        }
        if( ( altd && --b_) || ( altd == 0 && --b) )
          st+= isez80() ? 4 :israbbit() ? 5 : isr800() ? 3 : iskc160() ? 4 : 13,
          mp= pc+= (get_memory_inst(pc)^128)-127;
        else
          st+= isez80() ? 2 : israbbit() ? 5 : isr800() ? 2 : iskc160() ? 3 : 8,
          pc++;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x27: // DAA / (RCM) add sp,d / (EZ80) ld hl,(ix+d) (prefixed)
        if ( isez80() && ih == 0 ) ez80_ld_rr_ixyd(opc, PREFIX(ih, iy)); // LD HL,(ix+d)
        else if ( israbbit() ) rxk_add_sp_d(opc); // ADD SP,d
        else zilog_daa(opc);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2f: // CPL / (EZ80) ld (ix+d),hl // (R4K) LD (PY+d),BCDE, LD (PY+d),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdd_r32(opc,iy);
        else if ( isez80() && ih == 0 ) ez80_ld_ixyd_rr(opc, PREFIX(ih,iy)); // LD (ix+d),hl
        else {
            st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
            ff= ff      &-41
                | (a_ = a^255)& 40;
            fb|= -129;
            fa=  fa & -17
                | ~fr &  16;
            } else {
            ff= ff      &-41
                | (a^=255)& 40;
            fb|= -129;
            fa=  fa & -17
                | ~fr &  16;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x37: // SCF/ (EZ80) ld ix,(ix+d) (prefixed)
        if ( isez80() && ih == 0) ez80_ld_xy_ixyd(opc, PREFIX(ih,iy)); // LD ix,(ix+d)
        else {
            st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
                fb_= fb_      &128
                    | (fr_^fa_) & 16;
                ff_= 256
                    | ff_  &128
                    | a_   & 40;
            } else {
                fb= fb      &128
                    | (fr^fa) & 16;
                ff= 256
                    | ff  &128
                    | a   & 40;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3f: // CCF / (EZ80) ld (ix+d),ix // (R4K) LD (PZ+d),BCDE, LD (PZ+d),JKHL
        if ( israbbit4k() && ih==0) r4k_ld_ipdd_r32(opc,iy);
        else if ( isez80() && ih == 0 ) ez80_ld_ixyd_xy(opc, PREFIX(ih,iy)); // LD (ix+d),ix
        else {
            st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            if ( altd ) {
                fb_= fb_            &128
                    | (ff_>>4^fr_^fa_) & 16;
                ff_= ~ff_ & 256
                    | ff_  & 128
                    | a_   &  40;
            } else {
                fb= fb            &128
                    | (ff>>4^fr^fa) & 16;
                ff= ~ff & 256
                    | ff  & 128
                    | a   &  40;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x41: // LD B,C
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(b, c, b_, LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x42: // LD B,D / (R4K) RL HL
        if ( israbbit4k() ) { // RL HL
            long long sts = st;
            if (ih) {
                RL(l,l_);
                RL(h,h_);
            }
            st  = sts + 2;
        } else LDRR(b, d, b_, LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x43: // LD B,E
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(b, e, e_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x44: // LD B,H // LD B,IXh // LD B,IYh
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if( ih ) {
          LDRR(b, h, b_,LDrr_TICKS);
        } else if( iy && canixh() )
          LDRR(b, yh, b,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(b, xh, b,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x45: // LD B,L // LD B,IXl // LD B,IYl / (R4K) SUB HL,JK
        if ( israbbit4k() ) { // SUB HL,JK
          SUBHLRR(j,k);
          st += 2;
        } else if( ih ) {
          LDRR(b, l, b_,LDrr_TICKS);
        } else if( iy && canixh() ) {
          LDRR(b, yl, b,isez80() ? 1 : isr800() ? 1 : 4);
        } else if ( canixh() ) {
          LDRR(b, xl, b,isez80() ? 1 : isr800() ? 1 : 4);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x46: // LD B,(HL) // LD B,(IX+d) // LD B,(IY+d)
        if( ih ) {
          if ( altd ) LDRP(h, l, b_);
          else LDRP(h, l, b);
        } else if( iy )
          LDRPI(yh, yl, b);
        else
          LDRPI(xh, xl, b);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x47: // LD B,A
        LDRR(b, a, b_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x48: // LD C,B // (R4K) CP HL,d RLC 1,r32
        if (israbbit4k()) {
            if (ih == 0 ) r4k_rlc_r32(opc,iy);
            else r4k_cp_hl_d(opc);
        } else LDRR(c, b, c_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4a: // LD C,D
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(c, d, c_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4b: // LD C,E
        if (israbbit4k() && ih == 0) r4k_rlc_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(c, e,c_, LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4c: // LD C,H // LD C,IXh // LD C,IYh // (R4K) TEST HL,XY
        if ( israbbit4k()) r4k_test_hlxy(opc, PREFIX(ih, iy));
        else if( ih )
          LDRR(c, h, c_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(c, yh, c,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(c, xh, c,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4d: // LD C,L // LD C,IXl // LD C,IYl // (R4K) NEG HL, NEG BCDE, NEG JKHL
        if ( israbbit4k() ) {
            if (ih==0) r4k_neg_r32(opc, iy);
            else r4k_neg_hl(opc);
        } else if( ih )
          LDRR(c, l, c_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(c, yl, c,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(c, xl, c,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4e: // LD C,(HL) // LD C,(IX+d) // LD C,(IY+d)
        if( ih ) {
          if ( altd ) LDRP(h, l, c_);
          else LDRP(h, l, c);
        } else if( iy )
          LDRPI(yh, yl, c);
        else
          LDRPI(xh, xl, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4f: // LD C,A
        if (israbbit4k() && ih == 0) r4k_rlc_r32(opc, iy);
        else LDRR(c, a, c_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x50: // LD D,B / (R4K) RLC DE
        if ( israbbit4k() ) { // RLC DE
            long long sts = st;
            if ( ih ) {
                RLC(e,e_);
                RLC(d,d_);
            }
            st  = sts + 2;
        } else LDRR(d, b, d_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x51: // LD D,C / (R4K) RRC DE
        if ( israbbit4k() ) { // RRC DE
            long long sts = st;
            if ( ih ) {
                RRC(e,e_);
                RRC(d,d_);
            }
            st  = sts + 2;
        } else LDRR(d, c,  d_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x53: // LD D,E
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(d, e,  d_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x54: // LD D,H // LD D,IXh // LD D,IYh // (R4K) XOR HL,DE
        if (israbbit4k()) r4k_xor_hl_de(opc);
        else if( ih )
          LDRR(d, h,  d_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(d, yh, d,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(d, xh, d,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x55: // LD D,L // LD D,IXl // LD D,IYl / (R4K) SUB HL, DE
        if ( israbbit4k() ) { // SUB HL,DE
          SUBHLRR(d,e);
          st += 2;
        } else if( ih )
          LDRR(d, l,  d_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(d, yl, d,isez80() ? 1 : isr800() ? 1 : 4);
        else if (canixh() )
          LDRR(d, xl, d,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x56: // LD D,(HL) // LD D,(IX+d) // LD D,(IY+d)
        if( ih )
          LDRP(h, l, d);
        else if( iy )
          LDRPI(yh, yl, d);
        else
          LDRPI(xh, xl, d);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x57: // LD D,A
        LDRR(d, a,  d_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x58: // LD E,B
        if (israbbit4k() && ih == 0) r4k_rrc_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(e, b, e_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x59: // LD E,C
        if (israbbit4k() && ih == 0) r4k_rrc_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(e, c, e_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5a: // LD E,D
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else LDRR(e, d, e_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5c: // LD E,H // LD E,IXh // LD E,IYh // (R4K) TEST BCDE,JKHL
        if ( israbbit4k()) {
            if ( ih == 0 ) r4k_test_r32(opc, iy);
            else RABBIT4k_UNDEFINED();
        } else if( ih )
          LDRR(e, h, e_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(e, yh, e,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(e, xh, e,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5d: // LD E,L // LD E,IXl // LD E,IYl
        if ( israbbit4k()) RABBIT4k_UNDEFINED();
        else if( ih )
          LDRR(e, l, e_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(e, yl, e,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(e, xl, e,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5e: // LD E,(HL) // LD E,(IX+d) // LD E,(IY+d)
        if( ih )
          LDRP(h, l, e);
        else if( iy )
          LDRPI(yh, yl, e);
        else
          LDRPI(xh, xl, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5f: // LD E,A
        if (israbbit4k() && ih == 0) r4k_rrc_r32(opc, iy);
        else LDRR(e, a, e_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x60: // LD H,B // LD IXh,B // LD IYh,B / (R4K) RLC BC
        if ( israbbit4k() ) { // RLC BC
            long long sts = st;
            if ( ih ) {
                RLC(c,b_);
                RLC(b,b_);
            }
            st  = sts + 2;
        } else if( ih )
          LDRR(h, b, h_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yh, b, yh,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, b, xh,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x61: // LD H,C // LD IXh,C // LD IYh,C / (R4K) RRC BC
        if ( israbbit4k() ) { // RRC BC
            long long sts = st;
            if ( ih ) {
                RRC(c,c_);
                RRC(b,b_);
            }
            st  = sts + 2;
        } else if( ih )
          LDRR(h, c, h_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yh, c, yh,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, c, xh,isez80() ? 1 :isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x62: // LD H,D // LD IXh,D // LD IYh,D / (R4K) RL BC
        if ( israbbit4k() ) { // RL BC
            long long sts = st;
            if ( ih ) { 
                RL(c,c_);
                RL(b,b_);
            }
            st  = sts + 2;
        } else if( ih )
          LDRR(h, d,  h_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yh, d, yh,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, d, xh,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x63: // LD H,E // LD IXh,E // LD IYh,E / (R4K) RR BC
       if ( israbbit4k() ) { // RR BC
            long long sts = st;
            if ( ih ) {
                RR(b,b_);
                RR(c,c_);
            }
            st  = sts + 2;
        } else if( ih )
          LDRR(h, e,  h_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yh, e, yh,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, e, xh,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x65: // LD H,L // LD IXh,IXl // LD IYh,IYl / (R4K) ADD HL,JK // (RCM) LDP (mn),XY
        if ( israbbit() && ih == 0) rxk_ldp_inm_rr(opc, PREFIX(ih, iy));
        else if ( israbbit4k() ) { // ADD HL,JK
            if( ih ) {
                if ( altd ) ADDRRRR_ALTD(h, l, j, k, h_, l_);
                else ADDRRRR(h, l, j, k);
            }
        } else if( ih )
          LDRR(h, l, h_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yh, yl, yh,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, yl, xh,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x66: // LD H,(HL) // LD H,(IX+d) // LD H,(IY+d)
        if( ih )
          LDRP(h, l, h);
        else if( iy )
          LDRPI(yh, yl, h);
        else
          LDRPI(xh, xl, h);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x67: // LD H,A // LD IXh,A // LD IYh,A
        if( ih )
          LDRR(h, a, h_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yh, a, yh,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, a, xh,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x68: // LD L,B // LD IXl,B // LD IYl,B
        if ( israbbit4k() && ih == 0) r4k_rl_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if( ih )
          LDRR(l, b, l_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yl, b, yl,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, b, xl,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x69: // LD L,C // LD IXl,C // LD IYl,C
        if ( israbbit4k() && ih == 0) r4k_rl_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if( ih )
          LDRR(l, c, l_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yl, c, yl,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, c, xl,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6a: // LD L,D // LD IXl,D // LD IYl,D
        if ( israbbit4k() && ih == 0) r4k_rl_r32(opc, iy);
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if( ih )
          LDRR(l, d, l_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yl, d, yl,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, d, xl,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6b: // LD L,E // LD IXl,E // LD IYl,E
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if( ih )
          LDRR(l, e, l_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yl, e, yl,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, e, xl,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6c: // LD L,H // LD IXl,IXh // LD IYl,IYh // (RCM) LDP HL,(IXY)
        if (israbbit() && ih==0) rxk_ldp_hl_irr(opc, PREFIX(ih,iy));
        else if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else if( ih )
          LDRR(l, h, l_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yl, yh, yl,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, xh, xl,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6e: // LD L,(HL) // LD L,(IX+d) // LD L,(IY+d)
        if( ih )
          LDRP(h, l, l);
        else if( iy )
          LDRPI(yh, yl, l);
        else
          LDRPI(xh, xl, l);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6f: // LD L,A // LD IXl,A // LD IYl,A
        if (israbbit4k() && ih==0) r4k_rlb_a_r32(opc, iy);
        else if( ih )
          LDRR(l, a, l_,LDrr_TICKS);
        else if( iy && canixh() )
          LDRR(yl, a, yl,isez80() ? 1 : isr800() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, a, xl,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x70: // LD (HL),B // LD (IX+d),B // LD (IY+d),B
        if( ih )
          LDPR(h, l, b);
        else if( iy )
          LDPRI(yh, yl, b);
        else
          LDPRI(xh, xl, b);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x71: // LD (HL),C // LD (IX+d),C // LD (IY+d),C
        if( ih )
          LDPR(h, l, c);
        else if( iy )
          LDPRI(yh, yl, c);
        else
          LDPRI(xh, xl, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x72: // LD (HL),D // LD (IX+d),D // LD (IY+d),D
        if( ih )
          LDPR(h, l, d);
        else if( iy )
          LDPRI(yh, yl, d);
        else
          LDPRI(xh, xl, d);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x73: // LD (HL),E // LD (IX+d),E // LD (IY+d),E
        if( ih )
          LDPR(h, l, e);
        else if( iy )
          LDPRI(yh, yl, e);
        else
          LDPRI(xh, xl, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x74: // LD (HL),H // LD (IX+d),H // LD (IY+d),H
        if( ih )
          LDPR(h, l, h);
        else if( iy )
          LDPRI(yh, yl, h);
        else
          LDPRI(xh, xl, h);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x75: // LD (HL),L // LD (IX+d),L // LD (IY+d),L
        if( ih )
          LDPR(h, l, l);
        else if( iy )
          LDPRI(yh, yl, l);
        else
          LDPRI(xh, xl, l);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x77: // LD (HL),A // LD (IX+d),A // LD (IY+d),A
        if( ih )
          LDPR(h, l, a);
        else if( iy )
          LDPRI(yh, yl, a);
        else
          LDPRI(xh, xl, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x78: // LD A,B
        if ( israbbit4k() && ih == 0) r4k_rr_r32(opc, iy);
        else LDRR(a, b, a_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x79: // LD A,C
        if ( israbbit4k() && ih == 0) r4k_rr_r32(opc, iy);
        else LDRR(a, c, a_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7a: // LD A,D
        LDRR(a, d, a_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7b: // LD A,E
        if ( israbbit4k() && ih == 0) r4k_rr_r32(opc, iy);
        else LDRR(a, e, a_,LDrr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7c: // LD A,H // LD A,IXh // LD A,IYh (RCM) LD HL,IX LD HL,IY
        if ( israbbit() && ih == 0 ) rxk_ld_hl_xy(opc, PREFIX(ih, iy)); // LD HL,XY
        else if( ih )
          LDRR(a, h, a_, LDrr_TICKS);
        else if( iy )
          LDRR(a, yh, a,isez80() ? 1 : isr800() ? 1 : 4);
        else
          LDRR(a, xh, a,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7d: // LD A,L // LD A,IXl // LD A,IYl
        if (israbbit() && ih == 0 ) rxk_ld_xy_hl(opc, PREFIX(ih, iy)); // LD XY,HL
        else if( ih )
          LDRR(a, l, a_,LDrr_TICKS);
        else if( iy )
          LDRR(a, yl, a,isez80() ? 1 : isr800() ? 1 : 4);
        else
          LDRR(a, xl, a,isez80() ? 1 : isr800() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7e: // LD A,(HL) // LD A,(IX+d) // LD A,(IY+d)
        if( ih )
          LDRP(h, l, a);
        else if( iy )
          LDRPI(yh, yl, a);
        else
          LDRPI(xh, xl, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x80: // ADD A,B
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else ADD(b,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x81: // ADD A,C / (R4K) LD HL,BC
        if ( israbbit4k() ) {  // LD HL,BC
            if ( altd ) { h_ = b; l_ = c; }
            else { h = b; l = c; }
            st+=2; 
        } else ADD(c,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x82: // ADD A,D // (R4k) LDF (lmn),HL
        if (israbbit4k()) r4k_ldf_ilmn_hl(opc);
        else ADD(d,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x83: // ADD A,E // (R4K) LD (mn),BCDE
        if (israbbit4k()) r4k_ld_imn_r32(opc, 0);
        else ADD(e,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x84: // ADD A,H // ADD A,IXh // ADD A,IYh // (R4K) LD (mn),JKHL
        if (israbbit4k()) r4k_ld_imn_r32(opc, 1);
        else if( ih )
          ADD(h,ALUr_TICKS);
        else if( iy && canixh() )
          ADD(yh,ALURxy_TICKS);
        else if ( canixh() )
          ADD(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x85: // ADD A,L // ADD A,IXl // ADD A,IYl // (R4K) LD HL,(PW+d)
        if (israbbit4k()) r4k_ld_hl_ipsd(opc);
        else if( ih )
          ADD(l,ALUr_TICKS);
        else if( iy && canixh() )
          ADD(yl,ALURxy_TICKS);
        else if ( canixh() )
          ADD(xl,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x86: // ADD A,(HL) // ADD A,(IX+d) // ADD A,(IY+d) // (R4k) LD (PX+d),HL
        if (israbbit4k() && ih) r4k_ld_ipdd_hl(opc);
        else if( ih )
          ADD(get_memory_data(l|h<<8),ALUiHL_TICKS);
        else if( iy )
          ADD(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535),ALUiXY_TICKS);
        else
          ADD(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535),ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x87: // ADD A,A
        if (israbbit4k()) r4k_lljp(opc, 1);
        else {
            st+= ALUr_TICKS;
            if ( altd ) fr_= a_= (ff_= 2*(fa_= fb_= a));
            else fr= a= (ff= 2*(fa= fb= a));
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x88: // ADC A,B
        if ( israbbit4k() && ih == 0) r4k_sla_r32(opc, iy);
        else ADC(b,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x89: // ADC A,C / (R4K) LD (mn),JK
        if ( israbbit4k()) {
            if ( ih == 0 ) r4k_sla_r32(opc, iy);
            else LDPNNRR(j, k, 13);  // LD (mn),JK
        } else ADC(c,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8a: // ADC A,D // (R4K) LDF (lmn),A
        if ( israbbit4k()) r4k_ldf_ilmn_a(opc);
        else ADC(d,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8b: // ADC A,E // (R4K) LD A,(PW+HL)
        if (israbbit4k()) {
            if (ih == 0) r4k_sla_r32(opc, iy);
            else r4k_ld_a_ipshl(opc);
        } else ADC(e,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8c: // ADC A,H // ADC A,IXh // ADC A,IYh  // (R4K) LD (PW+HL),A, LDL PW,IX, LDL PW,IY
        if (israbbit4k()) {
            if (ih) r4k_ld_ipdhl_a(opc);
            else if (iy) r4k_ldl_pd_rr(opc, yl, yh);
            else r4k_ldl_pd_rr(opc, xl, xh);
        } else if( ih )
          ADC(h,ALUiHL_TICKS);
        else if( iy && canixh() )
          ADC(yh,ALURxy_TICKS);
        else if ( canixh() )
          ADC(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8d: // ADC A,L // ADC A,IXl // ADC A,IYl // (R4K) LD A,(PW+d), LD PW,BCDE, LD PW, JKHL
        if (israbbit4k()) {
            if (ih)
                r4k_ld_a_ipsd(opc);
            else 
                r4k_ld_pd_r32(opc,iy);
        } else if( ih )
          ADC(l,ALUr_TICKS);
        else if( iy && canixh() )
          ADC(yl,ALURxy_TICKS);
        else if ( canixh() )
          ADC(xl,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8e: // ADC A,(HL) // ADC A,(IX+d) // ADC A,(IY+d) // (R4K) LD (PW+d),A
        if (israbbit4k()) r4k_ld_ipdd_a(opc);
        else if( ih )
          ADC(get_memory_data(l|h<<8),ALUiHL_TICKS);
        else if( iy )
          ADC(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535),ALUiXY_TICKS);
        else
          ADC(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535),ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8f: // ADC A,A // (R4K) LDL PW,DE, LDL PW,HL LLCALL 
        if (israbbit4k() ) {
            if (ih) r4k_llcall(opc);
            else if (iy) r4k_ldl_pd_rr(opc, l, h);
            else r4k_ldl_pd_rr(opc, e, d);
        } else { 
            st+=ALUr_TICKS;
            if ( altd ) fr_= a_= (ff_= 2*(fa_= fb_= a)+(ff_>>8&1));
            else fr= a= (ff= 2*(fa= fb= a)+(ff>>8&1));
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x90: // SUB B
        if ( israbbit4k() ) RABBIT4k_UNDEFINED();
        else SUB(b,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x91: // SUB C / (R4K) LD BC,HL
        if ( israbbit4k() ) { // LD BC,HL
            if ( altd ) { b_ = h; c_ = l; }
            else { b = h; c = l; }
            st+=2; 
        } else SUB(c,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x92: // SUB D // (R4K) LDF HL,(lmn)
        if (israbbit4k()) r4k_ldf_hl_ilmn(opc);
        else SUB(d,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x93: // SUB E // (R4K) LD BCDE,(mn)
        if (israbbit4k()) r4k_ld_r32_imn(opc, 0);
        else SUB(e,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x94: // SUB H // SUB IXh // SUB IYh // (R4K) LD BCDE,(mn)
        if (israbbit4k()) r4k_ld_r32_imn(opc, 1);
        else if( ih )
          SUB(h,ALUr_TICKS);
        else if( iy && canixh() )
          SUB(yh,ALURxy_TICKS);
        else if ( canixh() )
          SUB(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x95: // SUB L // SUB IXl // SUB IYl / (R4K) LD HL,(PX+d)
        if (israbbit4k()) r4k_ld_hl_ipsd(opc);
        else if( ih )
          SUB(l,ALUr_TICKS);
        else if( iy && canixh() )
          SUB(yl,ALURxy_TICKS);
        else if ( canixh() )
          SUB(xl,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x96: // SUB (HL) // SUB (IX+d) // SUB (IY+d) // (R4k) LD (PX+d),HL
        if (israbbit4k() && ih) r4k_ld_ipdd_hl(opc);
        else if( ih )
          SUB(get_memory_data(l|h<<8),ALUiHL_TICKS);
        else if( iy )
          SUB(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535),ALUiXY_TICKS);
        else
          SUB(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535),ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x97: // SUB A // (R4k) LD XPC,HL
        if (israbbit4k() ) r4k_ld_lxpc_hl(opc);
        else {
            st+=ALUr_TICKS;
            if ( altd ) {
            fb_= ~(fa_= a);
            fr_= a_= ff_= 0;
            } else {
            fb= ~(fa= a);
            fr= a= ff= 0;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x98: // SBC A,B
        if ( israbbit4k() ) {
            if ( ih == 0 ) r4k_sra_r32(opc, iy);
            else r4k_jre(opc, 1);
        } else SBC(b, ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x99: // SBC A,C / (R4K) LD JK,(nm)
        if ( israbbit4k() ) { // LD JK,(mn)
            if (ih==0) r4k_sra_r32(opc, iy);
            else {
                if ( altd ) LDRRPNN(j_, k_, 11);
                else LDRRPNN(j, k, 11);
            }
        } else SBC(c, ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9a: // SBC A,D // (R4K) LDF A,(lmn)
        if ( israbbit4k()) r4k_ldf_a_ilmn(opc);
        else SBC(d, ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9b: // SBC A,E // (R4K) LD A,(PX+HL)
        if (israbbit4k()) {
            if (ih==0) r4k_sra_r32(opc, iy);
            else r4k_ld_a_ipshl(opc);
        } else SBC(e, ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9c: // SBC A,H // SBC A,IXh // SBC A,IYh // (R4K) LD (PX+HL),A, LDL PW,IX, LDL PW,IY
        if (israbbit4k()) {
            if (ih) r4k_ld_ipdhl_a(opc);
            else if (iy) r4k_ldl_pd_rr(opc, yl, yh);
            else r4k_ldl_pd_rr(opc, xl, xh);
        } else if( ih )
          SBC(h,ALUr_TICKS);
        else if( iy && canixh() )
          SBC(yh,ALURxy_TICKS);
        else if ( canixh() )
          SBC(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9d: // SBC A,L // SBC A,IXl // SBC A,IYl // (R4K) LD A,(PX+d),  LD PX,BCDE, LD PX, JKHL
        if (israbbit4k()) {
            if (ih)
                r4k_ld_a_ipsd(opc);
            else
                r4k_ld_pd_r32(opc,iy);
        } else if( ih )
          SBC(l,ALUr_TICKS);
        else if( iy && canixh() )
          SBC(yl,ALURxy_TICKS);
        else if ( canixh() )
          SBC(xl,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9e: // SBC A,(HL) // SBC A,(IX+d) // SBC A,(IY+d) // (R4K) LD (PX+d),A
        if (israbbit4k() && ih) r4k_ld_ipdd_a(opc);
        else if( ih )
          SBC(get_memory_data(l|h<<8),ALUiHL_TICKS);
        else if( iy )
          SBC(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535), ALUiXY_TICKS);
        else
          SBC(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535), ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9f: // SBC A,A // (R4K) LD HL,XPC  LDL PX,DE, LDL PX,HL
        if (israbbit4k()) {
            if (ih) r4k_ld_hl_lxpc(opc);  // LD HL,XPC
            else if (iy) r4k_ldl_pd_rr(opc, l, h); // LDL PX,HL
            else r4k_ldl_pd_rr(opc, e, d); // LDL PX,DE
        } else {
            st+= ALUr_TICKS;
            if ( altd ) {
            fb_= ~(fa_= a);
            fr_= a_= (ff_= (ff_&256)/-256);
            } else {
            fb= ~(fa= a);
            fr= a= (ff= (ff&256)/-256);
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa0:
        if ( israbbit4k() ) { // JR GT,s8
          st += 5;
          if (F_GT(f()))
            pc += (get_memory_inst(pc) ^ 128) - 127;
          else
            pc++;
        } else {                    // AND B
          AND(b, ALUr_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa1: // AND C // LD HL,DE (R4K)
        if ( israbbit4k() ) {  // LD HL,DE
            if ( altd ) { h_ = d; l_ = e; }
            else { h = d; l = e; }
            st+=2;
        } else AND(c, ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa2: // AND D / (R4K) JP GT,mn
        if ( israbbit4k() ) { // JP GT,nn
            if (ih) {
                long long sst = st;
                JPCI(F_GT(f()));
                st = sst + 7;
            }
        } else { AND(d, ALUr_TICKS); }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa3: // AND E // (R4K) LD BCDE,d
        if (israbbit4k()) r4k_ld_r32_d(opc,0);
        else AND(e, ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa4: // AND H // AND IXh // AND IYh // (R4K) LD JKHL,d
        if (israbbit4k()) r4k_ld_r32_d(opc,1);
        else if( ih )
          AND(h,  ALUr_TICKS);
        else if( iy && canixh() )
          AND(yh, ALURxy_TICKS);
        else if ( canixh() )
          AND(xh, ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa5: // AND L // AND IXl // AND IYl / (R4K) LD HL,(PY+d)
        if (israbbit4k()) r4k_ld_hl_ipsd(opc);
        else if( ih )
          AND(l, ALUr_TICKS);
        else if( iy && canixh() )
          AND(yl, ALURxy_TICKS);
        else if ( canixh() )
          AND(xl, ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa6: // AND (HL) // AND (IX+d) // AND (IY+d) // (R4K) LD (PY+d),HL
        if (israbbit4k() && ih) r4k_ld_ipdd_hl(opc);
        else if( ih )
          AND(get_memory_data(l|h<<8), ALUiHL_TICKS);
        else if( iy )
          AND(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535), ALUiXY_TICKS);
        else
          AND(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535), ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa7: // AND A / (R4K) MULU
        if ( israbbit4k() ) { // MULU
            if (ih) r4k_mulu(opc);
            else RABBIT4k_UNDEFINED();
        } else {
            st+=ALUr_TICKS;
            if ( altd ) {
            fa_= ~(ff_= fr_= a_);
            fb_= 0;
            } else {
            fa= ~(ff= fr= a);
            fb= 0;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa8:
        if ( israbbit4k() ) {  // JR GTU,s8
          if (ih==0) r4k_sll_r32(opc, iy);
          else {
            st += 5;
            if (F_GTU(f()))
                pc += (get_memory_inst(pc) ^ 128) - 127;
            else
                pc++;
          }
        } else {                    // XOR B
          XOR(b,ALUr_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa9: // XOR C / LD JK,nm (R4K)
        if ( israbbit4k() ) { // LD JK.nm
            if (ih==0) r4k_sll_r32(opc,iy);
            else {
                if ( altd ) LDRRIM(h_,l_);
                else LDRRIM(h, l);
            }
        } else { XOR(c,ALUr_TICKS); }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xaa: // XOR D / (R4K) JP GTU,mn
        if ( israbbit4k() ) { // JP GTU,mn
            if (ih) {
                long long sst = st;
                JPCI(F_GTU(f()));
                st = sst + 7;
            }
        } else { XOR(d,ALUr_TICKS); }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xab: // XOR E // (R4K) LD A,(PY+HL)
        if (israbbit4k()) {
            if (ih==0) r4k_sll_r32(opc,iy);
            else r4k_ld_a_ipshl(opc);
        } else XOR(e,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xac: // XOR H // XOR IXh // XOR IYh // (R4K) LD (PY+HL),A, LDL PY,IX, LDL PY,IY
        if (israbbit4k()) {
            if (ih) r4k_ld_ipdhl_a(opc);
            else if (iy) r4k_ldl_pd_rr(opc, yl, yh);
            else r4k_ldl_pd_rr(opc, xl, xh);
        } else if( ih )
          XOR(h,ALURxy_TICKS);
        else if( iy )
          XOR(yh,ALURxy_TICKS);
        else
          XOR(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xad: // XOR L // XOR IXl // XOR IYl // (R4K) LD A,(PY+d),  LD PY,BCDE, LD PY, JKHL
        if (israbbit4k()) {
            if (ih)
                r4k_ld_a_ipsd(opc);
            else
                r4k_ld_pd_r32(opc,iy);
        } else if( ih )
          XOR(l,ALUr_TICKS);
        else if( iy && canixh() )
          XOR(yl,ALURxy_TICKS);
        else if ( canixh() )
          XOR(xl,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xae: // XOR (HL) // XOR (IX+d) // XOR (IY+d) // (R4K) LD (PY+d),A
        if (israbbit4k() && ih) r4k_ld_ipdd_a(opc);
        else if( ih )
          XOR(get_memory_data(l|h<<8),ALUiHL_TICKS);
        else if( iy )
          XOR(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535),ALUiXY_TICKS);
        else
          XOR(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535),ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xaf: // XOR A // (R4K) LDL PY,DE, LDL PY,HL
        if (israbbit4k() && iy) r4k_ldl_pd_rr(opc, l, h);
        else if ( israbbit4k() && ih==0) r4k_ldl_pd_rr(opc, e, d);
        else {
            st+=ALUr_TICKS;
            if (altd) { a_= ff_= fr_= fb_= 0; fa_=256; }
            else { a= ff= fr= fb= 0; fa=256; }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb0:
        if ( israbbit4k() ) {  // JR LT, s8
          st += 5;
          if (F_LT(f()))
            pc += (get_memory_inst(pc) ^ 128) - 127;
          else
            pc++;
        } else {                    // OR B
          OR(b,ALUr_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb1: // OR C // LD DE,HL (R4K)
        if ( israbbit4k() ) {  // LD DE,HL
            if ( altd ) { d_ = h; e_ = l; }
            else { d = h; e = l; }
            st+=2;
        } else OR(c,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb2: // OR D / (R4K) JP LT,mn
        if ( israbbit4k() ) { // JP LT,mn
            if (ih) {
                long long sst = st;
                JPCI(F_LT(f()));
                st = sst + 7;
            }
        } else { OR(d,ALUr_TICKS); }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb3: // OR E / (R4K) EX BC,HL
        if ( israbbit4k() ) r4k_ex_bc_hl(opc); // EX BC,HL
        else OR(e,ALUr_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb4: // OR H // OR IXh // OR IYh // (R4K) EX JKHL,BCDE
        if (israbbit4k()) r4k_ex_jkhl_bcde(opc);
        else if( ih )
          OR(h,ALUr_TICKS);
        else if( iy && canixh() )
          OR(yh,ALURxy_TICKS);
        else if ( canixh() )
          OR(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb5: // OR L // OR IXl // OR IYl / (R4K) LD HL,(PZ+d)
        if (israbbit4k()) r4k_ld_hl_ipsd(opc);
        else if( ih )
          OR(l,ALUr_TICKS);
        else if( iy && canixh() )
          OR(yl,ALURxy_TICKS);
        else if ( canixh() )
          OR(xl,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb6: // OR (HL) // OR (IX+d) // OR (IY+d) // (R4K) LD (PZ+d),HL
        if (israbbit4k() && ih) r4k_ld_ipdd_hl(opc);
        else if( ih )
          OR(get_memory_data(l|h<<8),ALUiHL_TICKS);
        else if( iy )
          OR(get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535),ALUiXY_TICKS);
        else
          OR(get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535),ALUiXY_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb7: // OR A
        st+=ALUr_TICKS;
        if ( altd ) {
          fa_= 256
            | (ff_= fr_= a);
          fb_= 0;
        } else {
          fa= 256
            | (ff= fr= a);
          fb= 0;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb8:
        if ( israbbit4k() ) {  // JR V,s8
          if (ih==0) r4k_srl_r32(opc, iy);
          else {
            st += 5;
            if (F_V(f()))
                pc += (get_memory_inst(pc) ^ 128) - 127;
            else
                pc++;
          }
        } else {                    // CP B
          CP(b,ALUr_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb9: // CP C / (R4K) EX JK,HL
        if ( israbbit4k() ) { // EX JK,HL
            if (ih==0) r4k_srl_r32(opc, iy);
            else r4k_ex_jk_hl(opc);
        } else { CP(c,ALUr_TICKS); }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xba: // CP D /  (R4K) JP V,mn
        if ( israbbit4k() ) { // JP V,mn
            if (ih) {
                long long sst = st;
                JPCI(F_V(f()));
                st = sst + 7;
            }
        } else { CP(d,ALUr_TICKS); }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbb: // CP E // (R4K) LD A,(PZ+HL)
        if (israbbit4k()) {
            if (ih==0) r4k_srl_r32(pc,iy);
            else r4k_ld_a_ipshl(opc);
        } else {
            CP(e,ALUr_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbc: // CP H // CP IXh // CP IYh // (R4K) LD (PZ+HL),A, LDL PZ,IX, LDL PZ,IY
        if (israbbit4k()) {
            if (ih) r4k_ld_ipdhl_a(opc);
            else if (iy) r4k_ldl_pd_rr(opc, yl, yh);
            else r4k_ldl_pd_rr(opc, xl, xh);
        } else if( ih )
          CP(h,ALUr_TICKS);
        else if( iy && canixh() )
          CP(yh,ALURxy_TICKS);
        else if ( canixh() )
          CP(xh,ALURxy_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbd: // CP L // CP IXl // CP IYl // (R4K) LD A,(PZ+d),  LD PZ,BCDE, LD PZ, JKHL
        if (israbbit4k()) {
            if (ih)
                r4k_ld_a_ipsd(opc);
            else
                r4k_ld_pd_r32(opc,iy);
        } else if( ih )
          CP(l,ALUr_TICKS);
        else if( iy && canixh() )
          CP(yl,ALURxy_TICKS);
        else if (canixh())
          CP(xl,isez80() ? 1 :isr800() ? 1 :  4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbe: // CP (HL) // CP (IX+d) // CP (IY+d) // (R4K) LD (PZ+d),A
        if (israbbit4k() && ih) r4k_ld_ipdd_a(opc);
        else if( ih ) {
          w= get_memory_data(l|h<<8);
          CP(w,ALUiHL_TICKS);
        } else if( iy ) {
          w= get_memory_data(((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535);
          CP(w,ALUiXY_TICKS);
        } else {
          w= get_memory_data(((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535);
          CP(w,ALUiXY_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbf: // CP A // (R4K) CLR HL, LDL PZ,DE, LDL PZ,HL
        if (israbbit4k()) {
            if (ih ) {
                if ( altd ) h_ = l_ = 0;
                else h = l = 0;
                st += 2;
            } else if (iy) r4k_ldl_pd_rr(opc, l, h);
            else r4k_ldl_pd_rr(opc, e, d);
        } else {
            st+=ALUr_TICKS;
            if ( altd ) {
            fr_= 0;
            fb_= ~(fa_= a);
            ff_= a&40;
            } else {
            fr= 0;
            fb= ~(fa= a);
            ff= a&40;
            }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc9: // RET
        RET(isez80() ? 5 : israbbit() ?  8 : isz180() ? 9 : isgbz80() ? 8 : isr800() ? 3 : iskc160() ? 4 : 10);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc0: // RET NZ
        RETCI(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc8: // RET Z
        RETC(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd0: // RET NC
        RETC(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd8: // RET C
        RETCI(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe0: // RET PO
		if ( isgbz80()) { // LDH (n),A - I/O
		  t = get_memory_inst(pc++);
		  put_memory(0xFF00 + t, a);
		  st+= 12;
		} else {
          RETC(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
		}
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe8: // RET PE
        if ( isgbz80()) gbz80_add_sp_d();
        else RETCI(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf0: // RET P
  	    if ( isgbz80()) { // LDH A, (n) - I/O
		  t = get_memory_inst(pc++);
		  a = get_memory_data(0xFF00 + t);
		  st+= 12;
		} else {
          RETC(ff&128);
		}
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf8: // RET M
        if ( isgbz80() ) gbz80_ld_hl_spd();
        else RETCI(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc1: // POP BC
        POP(b, c, b_, c_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd1: // POP DE
        POP(d, e, d_, e_);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe1: // POP HL // POP IX // POP IY
        if( ih )
          POP(h, l, h_, l_);
        else if( iy )
          { POP(yh, yl, yh, yl); st += iskc160() ? 1 : 0; }
        else
          { POP(xh, xl, xh, xl); st += iskc160() ? 1 : 0; }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf1: // POP AF // (R4K)
        if (israbbit4k() && ih==0) r4k_pop_r32(opc, iy);
        else {
            st+= isez80() ? 3 : isgbz80() ? 12 : israbbit() ? 7 : isz180() ? 9 : 10;
            setf(get_memory_data(sp++));
            a= get_memory_data(sp++);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc5: // PUSH BC
        PUSH(b, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd5: // PUSH DE
        PUSH(d, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe5: // PUSH HL // PUSH IX // PUSH IY
        if( ih )
          PUSH(h, l);
        else if( iy )
          PUSH(yh, yl);
        else
          PUSH(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf5: // PUSH AF
        if (israbbit4k() && ih==0) r4k_push_r32(opc, iy);
        else PUSH(a, f());
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc3: // JP nn
        st+= isez80() ? 4 : israbbit() ? 3 : israbbit() ? 7 : isz180() ? 9 : isgbz80() ? 12 : isr800() ? 3 : iskc160() ? 3 : 10;
        ioi=ioe=0;
        mp= pc= get_memory_inst(pc) | get_memory_inst(pc+1)<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc2: // JP NZ
        JPCI(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xca: // JP Z
        JPC(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd2: // JP NC
        JPC(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xda: // JP C
        JPCI(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe2: // JP PO
		if ( isgbz80()) { // LD (C), A - I/O
		  put_memory(0xFF00+c,a);
		  st+= 8;
		} else {
          JPC(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
		}
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xea: // JP PE
        if ( israbbit4k() && ih == 0 ) r4k_callxy(opc, iy);
        else if ( isgbz80() ) gbz80_ld_inm_a();  // ld (nn),a
        else JPCI(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf2: // JP P
		if ( isgbz80()) { // LD A, (C)
		  a= get_memory_data(0xFF00+c);
		  st+= 8;
		} else {
          JPC(ff&128);
        }
		ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xfa: // JP M
        if ( isgbz80()) gbz80_ld_a_inm();  // ld a,(nn)
        else JPCI(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xcd: // CALL nn // (R4K) LD BCDE,PW, LD JKHL,PW
        if ( israbbit4k() && ih == 0 ) r4k_ld_r32_ps(opc, iy);
        else {
            st+= isez80() ? 5 : israbbit() ? 12 : isz180() ? 16 : is8085() ? 18 : isgbz80() ? 12 : isr800() ? 5 : iskc160() ? 5 : 17;
            t= pc+2;
            ioi=ioe=0;
            mp= pc= get_memory_inst(pc) | get_memory_inst(pc+1)<<8;
            put_memory(--sp,t>>8);
            put_memory(--sp,t);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc4: // CALL NZ / (RCM) LD HL,(SP+N)
        if ( israbbit() ) rxk_ld_hl_ispn(opc, ih, iy); // LD HL,(SP+n)
        else CALLCI(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xcc: // CALL Z / (RCM) BOOL HL/XY
        if ( israbbit() ) rxk_bool(opc, ih, iy);  // BOOL HL/IXY
        else CALLC(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd4: // CALL NC / (RCM) LD (SP+N),HL
        if ( israbbit() ) rxk_ld_ispn_hl(opc, ih, iy); // LD (SP+n),HL
        else  CALLC(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xdc: // CALL C / (RCM) AND HL,DE
        if ( israbbit() ) rxk_and_hlxy_de(opc, ih, iy); // AND HL,DE
        else CALLCI(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe4: // CALL PO / (RCM) LD HL,(IX+D)
        if ( israbbit() ) rxk_ld_hl_ihlxyd(opc, PREFIX(ih, iy));  // LD HL,(IXY+d) LD HL,(HL+d)
        else if ( isgbz80()) fprintf(stderr,"%04x: ILLEGAL gbz80 instruction E4\n", pc - 1);
        else CALLC(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xec: // CALL PE / (RCM) OR HL,DE
        if ( israbbit() ) rxk_or_hlxy_de(opc, ih, iy);  // OR HL,DE
        else if ( isgbz80()) fprintf(stderr, "%04x: ILLEGAL gbz80 instruction EC\n", pc - 1);
        else CALLCI(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf4: // CALL P or (RCM) LD (IX+D),HL
        if ( israbbit() ) rxk_ld_ihlxyd_hl(opc, PREFIX(ih,iy)); // LD (IXY+d),HL LD (HL+d),HL
        else if ( isgbz80()) fprintf(stderr, "%04x: ILLEGAL gbz80 instruction F4\n", pc - 1);
        else CALLC(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xfc: // CALL M  / (RCM) RR HL
        if ( israbbit() ) { // RR HL
          long long savest = st;
          if ( ih ) {
            RR(h,h_);
            RR(l,l_);
          } else if ( iy ) {
            RR(yh,yh);
            RR(yl,yl);
          } else {
            RR(xh,xh);
            RR(xl,xl);
          }
          st = savest + 2;
		} else if ( isgbz80()) {
		  printf("%04x: ILLEGAL gbz80 instruction FC\n", pc - 1);
        } else {
          CALLCI(ff&128);
        }
        ih=1;altd=0;ioi=0;ioe=0;
        break;
      case 0xc6: // ADD A,n
        ADD(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xce: // ADC A,n // (R4K) LD BCDE,(ix+d), LD JKHL,(ix+d)
        if (israbbit4k() && ih==0) r4k_ld_r32_ixyd(opc, xl, xh, iy);
        else ADC(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd6: // SUB n
        SUB(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xde: // SBC A,n // (R4K) LD BCDE,(iy+d), LD JKHL,(iy+d)
        if (israbbit4k() && ih==0) r4k_ld_r32_ixyd(opc, yl, yh, iy);
        else SBC(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe6: // AND n
        AND(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xee: // XOR A,n // (R4K) LD BCDE,(SP+n) LD JKHL,(SP+n)
        if (israbbit4k() && ih==0) r4k_ld_r32_ispn(opc, iy);
        else XOR(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf6: // OR n
        OR(get_memory_inst(pc++), ALUn_TICKS);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xfe: // CP A,n // LD BCDE,(SP+HL), LD JKHL,(SP+HL)
        if (israbbit4k() && ih==0) r4k_ld_r32_isphl(opc, iy);
        else { 
            w= get_memory_inst(pc++);
            CP(w, ALUn_TICKS);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc7: // RST 0x00  (RCM) LJP
        if (israbbit()) rxk_ljp(opc);
        else RST(0);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xcf: // RST 0x08 (RCM) LCALL
        if (israbbit() && ih) rxk_lcall(opc);
        else if (israbbit4k() && ih==0) r4k_ld_ixyd_r32(opc, xl, xh, iy);
        else RST(8);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd7: // RST 0x10
        RST(0x10);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xdf: // RST 0x18
        if (israbbit4k() && ih==0) r4k_ld_ixyd_r32(opc, xl, xh, iy);
        else RST(0x18);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe7: // RST 0x20
        RST(0x20);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xef: // RST 0x28 // (R4K) LD (SP+n),BCDE LD (SP+n),JKHL
        if (israbbit4k() && ih==0) r4k_ld_ispn_r32(opc, iy);
        else RST(0x28);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf7: // RST 0x30, (RCM) mul
        if ( israbbit() ) rxk_mul(opc);  // MUL
         else RST(0x30);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xff: // RST 0x38 // LD (SP+HL),BCDE , LD (SP+HL),JKHL
        if (israbbit4k() && ih==0) r4k_ld_isphl_r32(opc, iy);
        else RST(0x38);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd3: // OUT (n),A
        if ( isgbz80()) {
        } else if ( israbbit() ) { // IOI
          ioi=1;
          st+=2;
        } else {
          st+= is808x() ? 10 : isr800() ? 3 : iskc160() ? 5 : 11;
          out(mp= get_memory_inst(pc++) | a<<8, a);
          mp= mp&65280
            | ++mp;
          ih=1;altd=0;ioi=0;ioe=0;
        }
        break;
      case 0xdb: // IN A,(n) // (RCM) ioe
        if ( isgbz80() ) {

        } else if ( israbbit() ) { // IOE
          ioe=1;
          st+=2;
        } else {
          st+= is808x() ? 10 : isr800() ? 3 : iskc160() ? 4 : 11;
          a= in(mp= get_memory_inst(pc++) | a<<8);
          ++mp;
          ih=1;altd=0;ioi=0;ioe=0;
        }
        break;
      case 0xf3: // DI  / (RCM) RL DE
        if ( israbbit() ) { // RL DE
          long long savest = st;
          RL(e,e_);
          RL(d,d_);
          st = savest + 2;
        } else {
          st+= isez80() ? 1 : isz180() ? 3 : isr800() ? 2 : iskc160() ? 1 : 4;
          iff= 0;
        }
        ih=1;altd=0;ioi=0;ioe=0;
        break;
      case 0xfb: // EI / (RCM) RR DE
        if ( israbbit() ) { // RR DE
          long long savest = st;
          RR(d,d_);
          RR(e,e_);
          st = savest + 2;
        } else {
          st+= isez80() ? 1 : isz180() ? 3 : isr800() ? 2 : iskc160() ? 1 : 4;
          iff= 1;
        }
        ih=1;altd=0;ioi=0;ioe=0;
        break;
      case 0xeb: // EX DE,HL
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
        if (altd) {
            t = d; d = h_;  h_ = t;
            t = e; e = l_;  l_ = t;
        } else {
            t = d; d = h; h = t;
            t = e; e = l; l = t;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd9: // EXX
        if ( is8085() ) i8085_ld_ide_hl(opc);  // (8085) ld (de),hl (SHLX)
        else if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 instruction EXX\n",pc-1);
        } else if ( isgbz80() ) {  // RETI
          RET(8);
        } else {
            st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
            t = b; b = b_; b_= t;
            t = c; c = c_; c_= t;
            t = d; d = d_; d_= t;
            t = e; e = e_; e_= t;
            t = h; h = h_; h_= t;
            t = l; l = l_; l_= t;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe3: // EX (SP),HL // EX (SP),IX // EX (SP),IY or (RCM) EX DE',HL
        if ( isgbz80() ) {
          printf("%04x: ILLEGAL GBZ80 instruction EX (SP),HL\n",pc-1);
        } else if ( israbbit() && ih ) {
            if (altd) {
                t = h_; h_ = d_; d_ = t;
                t = l_; l_ = e_; e_ = t;
            } else {
                t = h;  h = d_;  d_ = t;
                t = l;  l = e_;  e_ = t;
            }
            st += 2;
        } else {
          if( ih )
            EXSPI(h, l);
          else if( iy )
            EXSPI(yh, yl);
          else
            EXSPI(xh, xl);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe9: // JP (HL)
        st+= isez80() ? 3 : isz180() ? 3 : is8085() ? 6 : is8080() ? 5 : isr800() ? 1 : iskc160() ? 2 : 4;
        if( ih )
          pc= l | h<<8;
        else if( iy )
          pc= yl | yh<<8;
        else
          pc= xl | xh<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf9: // LD SP,HL
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 4 : is8085() ? 6  : is8080() ? 5 : isgbz80() ? 8 : isr800() ? 1 : iskc160() ? 1 : 6;
        if( ih )
          sp= l | h<<8;
        else if( iy )
          sp= yl | yh<<8;
        else
          sp= xl | xh<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xdd: // OP DD // (8085) JP NK,nnnn //  (R4K) LD BCDE, PX, LD JKHL,PX
        if ( is8085() ) { // (8085) JP NK,nnnn (JNK nnnn)
          JPC(fk);
        } else if ( is8080() ) {
          printf("%04x: ILLEGAL 8080 prefix 0xDD\n",pc-1);
        } else if ( isgbz80() ) {
          printf("%04x: ILLEGAL GBZ80 prefix 0xDD\n",pc-1);
        } else if ( israbbit4k() && ih == 0 ) r4k_ld_r32_ps(opc, iy);
        else {
          st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
          ih= iy= 0;
        }
        break;
      case 0xfd: // OP FD // (8085) JP K,nnnn // (R4K) LD BCDE,PZ, LD JKHL,PZ
        if ( is8085() ) { // (8085) JP K,nnnn (JK nnnn)
          JPCI(fk);
        } else if ( is808x() ) {
          printf("%04x: ILLEGAL 8080 prefix 0xFD\n",pc-1);
        } else if ( isgbz80() ) {
          printf("%04x: ILLEGAL GBZ80 prefix 0xFD\n",pc-1);
        } else if ( israbbit4k() && ih == 0 ) r4k_ld_r32_ps(opc, iy);
        else {
          st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : isr800() ? 1 : iskc160() ? 1 : 4;
          ih= 0;
          iy= 1;
        }
        break;
      case 0xcb: // OP CB
		if ( is8085() ) i8085_rstv(opc); 		// (8085) RSTV, OVRST8
		else if ( is808x() ) {
          printf("%04x: ILLEGAL 8080 prefix 0xCB\n",pc-1);
        } else {
            handle_cb_page();
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xed: // OP ED // (8085) LD HL,(DE) // (R4K) LD BCDE,PY, LD JKHL, PY
        if ( is8085() ) { // (8085) LD HL,(DE) (LHLDE)
          if ( get_memory_inst(pc) != 0xfe) i8085_ld_hl_ide(opc);
          else handle_ed_page();
        } else if ( is8080() ) {
          if ( get_memory_inst(pc) == 0xfe) handle_ed_page();
          else printf("%04x: ILLEGAL 8080 prefix 0xED\n",pc-1);
        } else if ( isgbz80() ) {
          if ( get_memory_inst(pc) == 0xfe) handle_ed_page();
          else printf("%04x: ILLEGAL GBZ80 prefix 0xED\n",pc-1);
        } else if ( israbbit4k() && ih == 0 ) r4k_ld_r32_ps(opc, iy);
        else handle_ed_page();
        ih=1;altd=0;ioi=0;ioe=0;//break;
    }
  } while ( pc != end && st < counter  );
  if ( alarmtime != 0 ) {
     if ( rc2014_mode ) exit(l);
      /* We running as a test, we should never reach the end, so exit with error */
      exit(1);
  }
  if( tap && st>sttap )
    sttap= st+( tap= tapcycles() );
  if ( counter != -1 )
    printf("%llu\n", st);
  warn_existing_temp_breakpoints();
  if (profiler_enabled) {
      profiler_stop();
  }
  if( output ){
    fh= fopen(output, "wb+");
    if( !fh )
      fprintf(stderr, "\nCannot create or write in file: %s\n", output),
      exit(EXIT_FAILURE);
    if( !strcasecmp(strchr(output, '.'), ".sna" ) )
      put_memory(--sp,pc>>8),
      put_memory(--sp,pc),
      fwrite(&i, 1, 1, fh),
      fwrite(&l_, 1, 1, fh),
      fwrite(&h_, 1, 1, fh),
      fwrite(&e_, 1, 1, fh),
      fwrite(&d_, 1, 1, fh),
      fwrite(&c_, 1, 1, fh),
      fwrite(&b_, 1, 1, fh),
      t= f(),
      ff= ff_,
      fr= fr_,
      fa= fa_,
      fb= fb_,
      w= f(),
      fwrite(&w, 1, 1, fh),
      fwrite(&a_, 1, 1, fh),
      fwrite(&l, 1, 1, fh),
      fwrite(&h, 1, 1, fh),
      fwrite(&e, 1, 1, fh),
      fwrite(&d, 1, 1, fh),
      fwrite(&c, 1, 1, fh),
      fwrite(&b, 1, 1, fh),
      fwrite(&yl, 1, 1, fh),
      fwrite(&yh, 1, 1, fh),
      fwrite(&xl, 1, 1, fh),
      fwrite(&xh, 1, 1, fh),
      iff<<= 2,
      fwrite(&iff, 1, 1, fh),
      r= ((r&127)|(r7&128)),
      fwrite(&r, 1, 1, fh),
      fwrite(&t, 1, 1, fh),
      fwrite(&a, 1, 1, fh),
      fwrite(&sp, 2, 1, fh),
      fwrite(&im, 1, 1, fh),
      fwrite(&w, 1, 1, fh),
      fwrite(get_memory_addr(0x4000, MEM_TYPE_INST), 1, 0xc000, fh);
    else if ( !strcasecmp(strchr(output, '.'), ".scr" ) )
      fwrite(get_memory_addr(0x4000, MEM_TYPE_INST), 1, 0x1b00, fh);
    else{
      fwrite(get_memory_addr(0, MEM_TYPE_INST), 1, 65536, fh);
      w= f();
      fwrite(&w, 1, 1, fh);    // 10000 F
      fwrite(&a, 1, 1, fh);    // 10001 A
      fwrite(&c, 1, 1, fh);    // 10002 C
      fwrite(&b, 1, 1, fh);    // 10003 B
      fwrite(&l, 1, 1, fh);    // 10004 L
      fwrite(&h, 1, 1, fh);    // 10005 H
      fwrite(&pc, 2, 1, fh);   // 10006 PCl
                               // 10007 PCh
      fwrite(&sp, 2, 1, fh);   // 10008 SPl
                               // 10009 SPh
      fwrite(&i, 1, 1, fh);    // 1000a I
      r= ((r&127)|(r7&128));
      fwrite(&r, 1, 1, fh);    // 1000b R
      fwrite(&e, 1, 1, fh);    // 1000c E
      fwrite(&d, 1, 1, fh);    // 1000d D
      fwrite(&c_, 1, 1, fh);   // 1000e C'
      fwrite(&b_, 1, 1, fh);   // 1000f B'
      fwrite(&e_, 1, 1, fh);   // 10010 E'
      fwrite(&d_, 1, 1, fh);   // 10011 D'
      fwrite(&l_, 1, 1, fh);   // 10012 L'
      fwrite(&h_, 1, 1, fh);   // 10013 H'
      ff= ff_;
      fr= fr_;
      fa= fa_;
      fb= fb_;
      w= f();
      fwrite(&w, 1, 1, fh);    // 10014 F'
      fwrite(&a_, 1, 1, fh);   // 10015 A'
      fwrite(&yl, 1, 1, fh);   // 10016 IYl
      fwrite(&yh, 1, 1, fh);   // 10017 IYh
      fwrite(&xl, 1, 1, fh);   // 10018 IXl
      fwrite(&xh, 1, 1, fh);   // 10019 IXh
      fwrite(&iff, 1, 1, fh);  // 1001a IFF
      fwrite(&im, 1, 1, fh);   // 1001b IM
      fwrite(&mp, 2, 1, fh);   // 1001c MEMPTRl
                               // 1001d MEMPTRh
      wavlen-= wavpos,
      sttap-= st;
      wavlen= (wavlen<<1) | (ear>>6&1);
      fwrite(&wavlen, 4, 1, fh);  // 1001e wavlen
      fwrite(&sttap, 4, 1, fh);   // 10022 sttap
    }
    fclose(fh);
  }
}


static void handle_r4k_7f_page(void)
{
    uint8_t opc;
    if (ih) {
        // 7f page - 8 bit operations moved out from main page
        r++;
        switch( (opc = get_memory_inst(pc++)) ){
        case 0x40: // LD B,B
            if ( altd ) { b_ = b; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
        case 0x49: // LD C,C
            if ( altd ) { c_ = c; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
        case 0x52: // LD D,D
            if ( altd ) { d_ = d; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
        case 0x5b: // LD E,E
            if ( altd ) { e_ = e; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
        case 0x64: // LD H,H
            if ( altd ) { h_ = h; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
        case 0x6d: // LD L,L
            if ( altd ) { l_ = l; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
        case 0x7f: // LD A,A
            if ( altd ) { a_ = a; st += 4; ih=1;altd=0;ioi=0;ioe=0;break; }
            st += 4;
            ih=1;altd=0;ioi=0;ioe=0;
            break;
        case 0x41: // LD B,C
            LDRR(b, c, b_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x42: // LD B,D
            LDRR(b, d, b_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x43: // LD B,E
            LDRR(b, e, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x44: // LD B,H 
            LDRR(b, h, h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x45: // LD B,L 
            LDRR(b, l, b_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x47: // LD B,A
            LDRR(b, a, b_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x48: // LD C,B
            LDRR(c, b, c_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x4a: // LD C,D
            LDRR(c, d, c_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x4b: // LD C,E
            LDRR(c, e,c_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x4c: // LD C,H 
            LDRR(c, h, c_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x4d: // LD C,L 
            LDRR(c, l, c_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x4f: // LD C,A
            LDRR(c, a, c_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
            break;
        case 0x50: // LD D,B
            LDRR(d, b, d_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x51: // LD D,C
            LDRR(d, c,  d_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x53: // LD D,E
            LDRR(d, e,  d_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x54: // LD D,H 
            LDRR(d, h,  d_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x55: // LD D,L 
            LDRR(d, l,  d_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x57: // LD D,A
            LDRR(d, a,  d_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
            break;
        case 0x58: // LD E,B
            LDRR(e, b, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x59: // LD E,C
            LDRR(e, c, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x5a: // LD E,D
            LDRR(e, d, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x5c: // LD E,H
            LDRR(e, h, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x5d: // LD E,L
            LDRR(e, l, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x5f: // LD E,A
            LDRR(e, a, e_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x60: // LD H,B
            LDRR(h, b, h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x61: // LD H,C
            LDRR(h, c, h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x62: // LD H,D 
            LDRR(h, d,  h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x63: // LD H,E
            LDRR(h, e,  h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x65: // LD H,L
            LDRR(h, l, h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x67: // LD H,A
            LDRR(h, a, h_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x68: // LD L,B 
            LDRR(l, b, l_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x69: // LD L,C 
            LDRR(l, c, l_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x6a: // LD L,D
            LDRR(l, d, l_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x6b: // LD L,E 
            LDRR(l, e, l_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x6c: // LD L,H 
            LDRR(l, h, l_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x6f: // LD L,A 
            LDRR(l, a, l_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x78: // LD A,B
            LDRR(a, b, a_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x79: // LD A,C
            LDRR(a, c, a_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x7a: // LD A,D
            LDRR(a, d, a_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x7b: // LD A,E
            LDRR(a, e, a_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x7c: // LD A,H
            LDRR(a,h,a_, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x7d: // LD A,L 
            LDRR(a, l, a_,4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x80: // ADD A,B
            ADD(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x81: // ADD A,C
            ADD(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x82: // ADD A,D
            ADD(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x83: // ADD A,E
            ADD(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x84: // ADD A,H
            ADD(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x85: // ADD A,L
            ADD(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x86: // ADD A,(HL)
            ADD(get_memory_data(l|h<<8), 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x87: // ADD A,A
            st+= 4;
            if ( altd ) fr_= a_= (ff_= 2*(fa_= fb_= a));
            else fr= a= (ff= 2*(fa= fb= a));
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x88: // ADC A,B
            ADC(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x89: // ADC A,C
            ADC(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x8a: // ADC A,D
            ADC(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x8b: // ADC A,E
            ADC(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x8c: // ADC A,H
            ADC(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x8d: // ADC A,L
            ADC(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x8e: // ADC A,(HL)
            ADC(get_memory_data(l|h<<8), 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x8f: // ADC A,A
            st+=4;
            if ( altd ) fr_= a_= (ff_= 2*(fa_= fb_= a)+(ff_>>8&1));
            else fr= a= (ff= 2*(fa= fb= a)+(ff>>8&1));
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x90: // SUB B
            SUB(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x91: // SUB C
            SUB(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x92: // SUB D
            SUB(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x93: // SUB E
            SUB(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x94: // SUB H
            SUB(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x95: // SUB L
            SUB(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x96: // SUB (HL)
            SUB(get_memory_data(l|h<<8), 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x97: // SUB A
            st+=4;
            if ( altd ) {
                fb_= ~(fa_= a);
                fr_= a_= ff_= 0;
            } else {
                fb= ~(fa= a);
                fr= a= ff= 0;
            }
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x98: // SBC A,B
            SBC(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x99: // SBC A,C
            SBC(c,  4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x9a: // SBC A,D
            SBC(d,  4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x9b: // SBC A,E
            SBC(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x9c: // SBC A,H
            SBC(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x9d: // SBC A,L
            SBC(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x9e: // SBC A,(HL)
            SBC(get_memory_data(l|h<<8), 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0x9f: // SBC A,A
            st+=  4;
            if ( altd ) {
                fb_= ~(fa_= a);
                fr_= a_= (ff_= (ff_&256)/-256);
            } else {
                fb= ~(fa= a);
                fr= a= (ff= (ff&256)/-256);
            }
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa0: // AND B
            AND(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa1: // AND C
            AND(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa2: // AND D
            AND(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa3: // AND E
            AND(e,  4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa4: // AND H
            AND(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa5: // AND L 
            AND(l,  4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa6: // AND (HL) // AND (IX+d) // AND (IY+d)
            AND(get_memory_data(l|h<<8), 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa7: // AND A
            st+= 4;
            if ( altd ) {
                fa_= ~(ff_= fr_= a_);
                fb_= 0;
            } else {
                fa= ~(ff= fr= a);
                fb= 0;
            }
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa8: // XOR B
            XOR(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xa9: // XOR C
            XOR(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xaa: // XOR D
            XOR(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xab: // XOR E
            XOR(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xac: // XOR H
            XOR(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xad: // XOR L 
            XOR(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xae: // XOR (HL)
            XOR(get_memory_data(l|h<<8), 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xaf: // XOR A
            st+= 4;
            if (altd) { a_= ff_= fr_= fb_= 0; fa_=256; }
            else { a= ff= fr= fb= 0; fa=256; }
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb0: // OR B
            OR(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb1: // OR C
            OR(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb2: // OR D
            OR(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb3: // OR E
            OR(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb4: // OR H
            OR(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb5: // OR L
            OR(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb6: // OR (HL) // OR (IX+d) // OR (IY+d)
            OR(get_memory_data(l|h<<8),7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb7: // OR A
            st+= 4;
            if ( altd ) {
                fa_= 256
                    | (ff_= fr_= a);
                fb_= 0;
            } else {
                fa= 256
                    | (ff= fr= a);
                fb= 0;
            }
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb8: // CP B
            CP(b, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xb9: // CP C
            CP(c, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xba: // CP D
            CP(d, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xbb: // CP E
            CP(e, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xbc: // CP H
            CP(h, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xbd: // CP L 
            CP(l, 4);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xbe: // CP (HL) 
            w= get_memory_data(l|h<<8);
            CP(w, 7);
            ih=1;altd=0;ioi=0;ioe=0;break;
        case 0xbf: // CP A
            st+= 4;
            if ( altd ) {
                fr_= 0;
                fb_= ~(fa_= a);
                ff_= a&40;
            } else {
                fr= 0;
                fb= ~(fa= a);
                ff= a&40;
            }
            ih=1;altd=0;ioi=0;ioe=0;break;
        default:
            t += 4;
            ih=1;altd=0;ioi=0;ioe=0;
            break;
        }
    }
}

static void handle_ed_page(void)
{
    uint8_t opc;
    r++;
    switch( (opc = get_memory_inst(pc++)) ){
    case 0x02:    // (EZ80) LEA BC,IX+d // (R4K) SBOX A // (KC160) LD (SP+d),XIX
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if ( israbbit4k()) r4k_sbox_a(opc);
        else if ( isez80() ) ez80_lea_rr_xyd(opc); // LEA BC,IX+d
        else st += 8;
        break;
    case 0x03:    // (EZ80) LEA BC,IY+d // (R4K) LDL PW,(SP+n) // (KC160) LDF (lmn),XIX
        if ( iskc160() ) kc160_ldf_ilmn_r24(opc); // LDF (lmn),XIX
        else if ( israbbit4k() ) r4k_ldl_pd_ispn(opc);
        else if ( isez80() ) ez80_lea_rr_xyd(opc); // LEA BC,IY+d
        else st += 8;
        break;
    case 0x04:    // (Z180) TST A,B // (R4K) LD PW,(SP+n)
        if ( israbbit4k() ) r4k_ld_pd_ispn(opc);
        else if ( canz180() ) TEST(b, isez80() ? 2 : 7);
        else st += 8;
        break;
    case 0x07:    // (EZ80) ld bc,(hl) // (R4K) LD (PW+BC),HL
        if ( israbbit4k() ) r4k_ld_ipdbc_hl(opc);
        else if ( isez80() ) ez80_ld_rr_ihl(opc);  // LD BC,(HL)
        else st += 8;
        break;
    case 0x0c:    // (Z180) TST A,C // R4K LD PW,klmn
        if ( israbbit4k() ) r4k_ld_pd_klmn(opc);
        else if ( canz180() ) TEST(c, isez80() ? 2 : 7);
        else st += 8;
        break;
    case 0x0f:    // (EZ80) ld (hl),bc // (R4K) CONVD PW
        if ( israbbit4k() ) r4k_convd(opc);
        else if ( isez80() ) ez80_ld_ihl_rr(opc); // LD (HL),BC
        else st += 8;
        break;
    case 0x12:    // (EZ80) LEA DE,IX+d // (R4K) IBOX A // (KC160) LD (SP+d),YIY
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if (israbbit4k()) r4k_ibox_a(opc);
        else if ( isez80() ) ez80_lea_rr_xyd(opc); // LEA DE,IX+d
        else st += 8;
        break;
    case 0x13:    // (EZ80) LEA DE,IY+d // (R4K) LDL PX,(SP+n) // (KC160) LDF (lmn),YIY
        if ( iskc160() ) kc160_ldf_ilmn_r24(opc); // LDF (lmn),YIY
        else if ( israbbit4k() ) r4k_ldl_pd_ispn(opc);
        else if ( isez80() ) ez80_lea_rr_xyd(opc); // LEA DE,IY+d
        else st += 8;
        break;
    case 0x14:    // (Z180) TST A,D // (R4K) LD PX,(SP+n)
        if ( israbbit4k() ) r4k_ld_pd_ispn(opc);
        else if ( canz180() ) TEST(d, isez80() ? 2 : 7);
        else st += 8;
        break;
    case 0x17:    // (EZ80) ld de,(hl) // (R4K) LD (PX+BC),HL
        if ( israbbit4k() ) r4k_ld_ipdbc_hl(opc);
        else if ( isez80() ) ez80_ld_rr_ihl(opc);  // LD DE,(HL)
        else st += 8;
        break;
    case 0x1c:    // (Z180) TST A,E // R4K LD PX,klmn
        if ( israbbit4k() ) r4k_ld_pd_klmn(opc);
        else if ( canz180() ) TEST(e, isez80() ? 2 : 7);
        else st += 8;
        break;
    case 0x1f:    // (EZ80) ld (hl),de // (R4K) CONVD PX
        if ( israbbit4k() ) r4k_convd(opc);
        else if ( isez80() ) ez80_ld_ihl_rr(opc); // LD (HL),DE
        else st += 8;
        break;
    case 0x22:    // (EZ80) LEA HL,IX+d // (KC160) LD (SP+d),AHL
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if ( isez80() ) ez80_lea_rr_xyd(opc); // LEA HL,IX+d
        else st += 8;
        break;
    case 0x23:    // (EZ80) LEA HL,IY+d, (ZXN) swapnib // (R4K) LDL PY,(SP+n) // (KC160) LDF (lmn),AHL
        if ( iskc160() ) kc160_ldf_ilmn_r24(opc); // LDF (lmn),AHL
        else if ( israbbit4k() ) r4k_ldl_pd_ispn(opc);
        else if ( isez80() ) ez80_lea_rr_xyd(opc); // LEA HL,IY+d
        else if ( isz80n() ) SWAP(a); // SWAPNIB
        else st += 8;
        break;
    case 0x24:    // (Z180) TST A,D // (Z80N) MIRROR // (R4K) LD PY,(SP+n)
        if ( israbbit4k() ) r4k_ld_pd_ispn(opc);
        else if ( canz180() ) TEST(h, isez80() ? 2 : 7);
        else if ( isz80n() )  z80n_mirror();
        else st += 8;
        break;
    case 0x28:    // (ZXN) bsla de,b // (R4K) LDF PY,(lmn) // (KC160) LD AHL,(IY+d)
        if ( iskc160() ) kc160_ld_r24_ixysd(opc);
        else if ( israbbit4k()) r4k_ldf_pd_ilmn(opc);
        else if ( isz80n() ) { // BSLA DE,B
            long long old_st = st;
            unsigned short old_ff = ff, old_fa = fa, old_fb = fb, old_fr = fr;
            int count;
            for ( count = 0 ; count < (b & 0x1f); count++ ) {
                SLA(e,e);
                RL(d,d);
            }
            st = old_st + 8;
            ff = old_ff; fa = old_fa; fb = old_fb; fr = old_fr;
        } else {
            st += 8;
        }
        break;
    case 0x29:    // (ZXN) bsra de,b // (R4K) LDF (lmn),PY // (Z180) OUT0 (n),l // (KC160) LD AHL,(IX+d)
        if ( iskc160() ) kc160_ld_r24_ixysd(opc);
        else if ( israbbit4k() ) r4k_ldf_ilmn_ps(opc);
        else if (canz180()) z180_out0(opc);
        else if ( isz80n() ) { // BSRA DE,B
            long long old_st = st;
            unsigned short old_ff = ff, old_fa = fa, old_fb = fb, old_fr = fr;
            int count;
            for ( count = 0 ; count < (b & 0x1f); count++ ) {
                SRA(d,d);
                RR(e,e);
            }
            st = old_st + 8;
            ff = old_ff; fa = old_fa; fb = old_fb; fr = old_fr;
        } else {
            st += 8;
        }
        break;
    case 0x2a:    // (ZXN) bsrl de,b // (R4K) LDF IX,(lmn)  // (KC160) LD AHL,(SP+d)
        if (iskc160()) kc160_ld_r24_ixysd(opc);
        else if (israbbit4k()) r4k_ldf_rr_ilmn(opc); 
        else if ( isz80n() ) { // BSRL DE,B
            long long old_st = st;
            unsigned short old_ff = ff, old_fa = fa, old_fb = fb, old_fr = fr;
            int count;
            for ( count = 0 ; count < (b & 0x1f); count++ ) {
                SRL(d,d);
                RR(e,e);
            }
            st = old_st + 8;
            ff = old_ff; fa = old_fa; fb = old_fb; fr = old_fr;
        } else {
            st += 8;
        }
        break;
    case 0x2b:    // (ZXN) bsrf de,b // (R4K) LDF (lmn),IX // (KC160) LDF AHL,(lmn)
        if ( iskc160() ) kc160_ldf_r24_ilmn(opc); // LDF AHL,(lmn)
        else if (israbbit4k()) r4k_ldf_ilmn_rr(opc);
        else if ( isz80n() ) { // BSRF DE,B
            long long old_st = st;
            unsigned short old_ff = ff, old_fa = fa, old_fb = fb, old_fr = fr;
            int count;
            for ( count = 0; count < (b & 0x1f); count++) {
                RR(d,d);
                d |= 128;
                RR(e,e);
            }
            st = old_st + 8;
            ff = old_ff; fa = old_fa; fb = old_fb; fr = old_fr;
        } else {
            st += 8;
        }
        break;
    case 0x2c:    // (Z180) TST A,E (ZXN) brlc de,b // (R4K) LD PY,klmn
        if ( israbbit4k() ) r4k_ld_pd_klmn(opc);
        else if ( canz180() ) TEST(l, isez80() ? 2 : 7);
        else if ( isz80n() ) { // BRLC DE,B
            long long old_st = st;
            unsigned short old_ff = ff, old_fa = fa, old_fb = fb, old_fr = fr;
            int count;
            for ( count = 0 ; count < (b & 0x0f); count++ ) {
                ff &= ~256;
                ff |= ( d & 128) ? 256 : 0;
                RL(e,e);
                RL(d,d);
            }
            st = old_st + 8;
            ff = old_ff; fa = old_fa; fb = old_fb; fr = old_fr;
        } else {
            st += 8;
        }
        break;
    case 0x2f:    // (EZ80) ld (hl),hl // (R4K) CONVD PY
        if ( israbbit4k() ) r4k_convd(opc);
        else if ( isez80() ) ez80_ld_ihl_rr(opc); // LD (HL),HL
        else st += 8;
        break;
    case 0x32:    // (EZ80) LEA IX,IX+d, (ZXN) add de,a
        if ( isez80() ) ez80_lea_xy_xd(opc); // LEA IX,IX+d
        else if ( isz80n() ) z80n_add_de_a();
        else st += 8;
        break;
    case 0x33:    // (EZ80) LEA IY,IY+d, (ZXN) add bc,a // (R4K) LDL PZ,(SP+n)
        if ( israbbit4k() ) r4k_ldl_pd_ispn(opc);
        else if ( isez80() ) ez80_lea_xy_yd(opc); // LEA IY,IY+d
        else if ( isz80n() ) z80n_add_bc_a();
        else st += 8;
        break;
    case 0x3e:    // (EZ80) ld (hl),iy // (R4k) CONVC PZ
        if ( israbbit4k()) r4k_convc(opc);
        else if ( isez80() ) ez80_ld_ihl_xy(opc); // LD (HL),IY
        else st += 8;
        break;
    case 0x3f:    // (EZ80) ld (hl),ix // (R4K) CONVD PZ
        if ( israbbit4k() ) r4k_convd(opc);
        else if ( isez80() ) ez80_ld_ihl_xy(opc); // LD (HL),IX
        else st += 8;
        break;
    case 0x64:    // (Z180) TST A,n // (RCM) LDP (HL),HL
        if ( israbbit() ) rxk_ldp_irr_hl(opc, 0xed);
        else if ( canz180() ) {
            uint8_t v = get_memory_inst(pc++);
            TEST(v, isez80() ? 3 : 9);
        } else UNDOCUMENTED_NEG();
        break;
    case 0x90:
        if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_ldisr(opc);
        else if ( isz80n()) z80n_outinb();
        else st += 8;
        break;
    case 0x91: // (KC160) LD (IY+d),IY
        if ( iskc160() ) kc160_ld_ixysd_xy(opc); // LD (IY+d),IY
        else if ( isz80n() ) z80n_nextreg_8_8();
        else st+=8;
        break;
    case 0x92: // (ZXN) NEXTREG n,a // (EZ80) INIMR // (KC160) LD (SP+d),IY
        if ( iskc160() ) kc160_ld_ixysd_xy(opc); // LD (SP+d),IY
        else if ( isez80() ) ez80_inimr(opc);
        else if ( isz80n() ) z80n_nextreg_8_a();
        else st += 8;
        break;
    case 0xa5: // (R4K) PUSH nm // (KC160) LD (IX+d),HL
        if ( iskc160() ) kc160_ld_ixysd_rr(opc); // LD (IX+d),HL
        else if (israbbit4k()) r4k_push_mn(opc);
        else if ( isz80n()) z80n_ldws();
        else st += 8;
        break;
    case 0xb7: // (ZXN) LDPIR // (KC160) LDF (lmn),SP
        if ( iskc160() ) kc160_ldf_ilmn_rr(opc); // LDF (lmn),SP
        else if ( isz80n()) z80n_ldpirx();
        else st += 8;
        break;

    case 0xc1:   // (R800) MULUB A,B // (R4K) POP PW
        if ( israbbit4k()) r4k_pop_pd(opc);
        else if ( isr800() ) r800_mulub(opc); // MULUB A,B
        else st += 8; 
        break;
    case 0xc9:   // (R800) MULUB A,C
        if ( isr800() ) r800_mulub(opc); // MULUB A,C
        else st += 8; 
        break;
    case 0xd1:   // (R800) MULUB A,D // (R4K) POP PX
        if ( israbbit4k()) r4k_pop_pd(opc);
        else if ( isr800() ) r800_mulub(opc); // MULUB A,D
        else st += 8; 
        break;
    case 0xd9:   // (R800) MULUB A,E // (R4K) EXP
        if ( israbbit4k() ) r4k_exp(opc);
        else if ( isr800() ) r800_mulub(opc); // MULUB A,E
        else st += 8; 
        break;
    case 0xe1:   // (R800) MULUB A,H // (R4K) POP PY // (KC160) CPI X
        if (iskc160()) kc160_cpi_x(opc);
        else if ( israbbit4k()) r4k_pop_pd(opc);
        else if ( isr800() ) r800_mulub(opc); // MULUB A,H
        else st += 8; 
        break;
    case 0xe9:   // (R800) MULUB A,L // (KC160) CPD X
        if (iskc160())  kc160_cpd_x(opc);
        else if ( isr800() ) r800_mulub(opc); // MULUB A,L
        else st += 8; 
        break;
    case 0xf9:   // (R800) MULUB A,A // (KC160) CPDR X
        if (iskc160()) kc160_cpdr_x(opc);
        else if ( isr800() ) r800_mulub(opc); // MULUB A,A
        else st += 8; 
        break;

    case 0xc3:  // (R800) MULUW HL,BC // (KC160) JP3
        if (iskc160()) kc160_jp3(opc, 1); // JP3 lmn
        if ( israbbit4k()) r4k_jre(opc, fr); // JRE NZ,dddd
        else if ( isr800() ) r800_muluw(opc); // MULW HL,BC
        else st += 8; 
        break;
    case 0xd3:  // (R800) MULUW HL,DE
        if ( israbbit4k()) r4k_jre(opc, !(ff&256)); // JRE NC,dddd
        else if ( isr800() ) r800_muluw(opc); // MULW HL,DE
        else st += 8; 
        break;
    case 0xe3:  // (R800) MULUW HL,HL // (KC160) OUTI X
        if (iskc160()) kc160_outi_x(opc);
        else if ( isr800() ) r800_muluw(opc); // MULW HL,HL
        else st += 8; 
        break;
    case 0xf3:  // (R800) MULUW HL,SP // (KC160) OTIR X
        if (iskc160() ) kc160_otir_x(opc);
        else if ( isr800() ) r800_muluw(opc); // MULW HL,SP
        else st += 8; 
        break;
    case 0xa4:   // (ZXN) LDIX / (R4K) FLAG GT,HL // (EZ80) OUTI2 / (KC160) LD (IY+d),HL
        if (iskc160() ) kc160_ld_ixysd_rr(opc); // LD (IY+d),HL
        else if ( isez80() ) ez80_outi2(opc);
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc,F_GT(f()));  // FLAG GT,HL
        else if ( isz80n()) z80n_ldix();
        else st += 8;
        break;
    case 0xac:   // (ZXN) LDDX / (R4K) FLAG GTU,HL // (EZ80) OUTD2 / (KC160) LD HL,(IY+d)
        if (iskc160() ) kc160_ld_rr_ixysd(opc); // LD HL,(IY+d)
        else if ( isez80() ) ez80_outd2(opc);
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc,F_GTU(f()));  // FLAG GTU,HL
        else if ( isz80n()) z80n_lddx();
        else st += 8;
        break;
    case 0xb4:   // (ZXN) LDIRX / (R4K) FLAG LT,HL // (EZ80) OTI2R // (KC160) LD (IY+d),SP
        if (iskc160() ) kc160_ld_ixysd_rr(opc); // LD (IY+d),SP
        else if ( isez80() ) ez80_oti2r(opc);
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc,F_LT(f()));  // FLAG LT,HL
        else if ( isz80n() ) z80n_ldirx();
        else st += 8;
        break;
    case 0xbc:   // (ZXN) LDDRX / (R4K) FLAG V,HL // (EZ80) OTD2R / (KC160) LD SP,(IY+d)
        if (iskc160() ) kc160_ld_rr_ixysd(opc); // LD SP,(IY+d)
        else if ( isez80() ) ez80_otd2r(opc);
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc,F_V(f()));  // FLAG V,HL
        else if ( isz80n()) z80n_lddrx();
        else st += 8;
        break;
    case 0xc4:   // (R4K) FLAG NZ,HL // (KC160) LD A,ZP
        if (iskc160()) kc160_ld_pp_pp(opc); // (KC160) LD A,ZP
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc, fr); // FLAG NZ,HL
        else st += 8;
        break;
    case 0xcc:   // (R4K) FLAG Z,HL // (KC160) LD A,YP
        if (iskc160()) kc160_ld_pp_pp(opc); // (KC160) LD A,YP
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc, !fr); // FLAG Z,HL
        else st += 8;
        break;
    case 0xd4:   // (R4K) FLAG NC,HL // (KC160) LD XP,YP
        if (iskc160()) kc160_ld_pp_pp(opc); // (KC160) LD XP,YP
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc, !(ff&256)); // FLAG NC,HL
        else st += 8;
        break;
    case 0xdc:   // (R4K) FLAG C,HL // (KC160) LD XP,ZP
        if (iskc160()) kc160_ld_pp_pp(opc); // (KC160) LD XP,ZP
        else if ( israbbit4k() ) r4k_flag_cc_hl(opc, (ff&256) == 256); // FLAG C,HL
        else st += 8;
        break;
    case 0x0d:   // (R4K) LDL PW,mn
    case 0x1d:   // (R4K) LDL PX,mn
    case 0x2d:   // (R4K) LDL PY,mn
        if ( israbbit4k() ) r4k_ldl_pd_mn(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x05:  // (R4K) LD (SP+n),PW
    case 0x15:  // (R4K) LD (SP+n),PX
    case 0x25:  // (R4K) LD (SP+n),PY
        if ( israbbit4k() ) r4k_ld_ispn_ps(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x06: // (R4K) LD HL,(PW+BC) // (KC160) LD IX,SP
    case 0x16: // (R4K) LD HL,(PX+BC) // (KC160) LD IY,SP
        if (iskc160() ) kc160_ld_hxy_sp(opc);
        else if ( israbbit4k() ) r4k_ld_hl_ipsbc(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0xc5: // (R4K) PUSH PW // (KC160) LD A,XP
    case 0xd5: // (R4K) PUSH PX // (KC160) LD XP,A
    case 0xe5: // (R4K) PUSH PY // (KC160) LD YP,ZP
    case 0xf5: // (R4K) PUSH PZ // (KC160) LD ZP,YP
        if (iskc160()) kc160_ld_pp_pp(opc);
        else if (israbbit4k()) r4k_push_ps(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0xf1: // (R4K) POP PZ // (KC160) CPIR X
        if (iskc160() ) kc160_cpir_x(opc);
        else if ( israbbit4k()) r4k_pop_pd(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x08:  // (R4K) LDF PW,(lmn) // (Z180) in0 c,(n) // (KC160) LD XIX,(IY+d)
    case 0x18:  // (R4K) LDF PX,(lmn) // (Z180) in0 e,(n) // (KC160) LD YIY,(IY+d)
        if (iskc160() ) kc160_ld_r24_ixysd(opc);
        else if ( israbbit4k()) r4k_ldf_pd_ilmn(opc);
        else if (canz180()) z180_in0(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x09: // (R4K) LDF (lmn),PW // (Z180) OUT0 (n),c // (KC160) LD XIX,(IX+d)
    case 0x19: // (R4K) LDF (lmn),PX // (Z170) OUT0 (n),e // (KC160) LD YIY,(IX+d)
        if ( iskc160() ) kc160_ld_r24_ixysd(opc);
        else if ( israbbit4k() ) r4k_ldf_ilmn_ps(opc);
        else if (canz180()) z180_out0(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x83: // (Z180) otim // (R4K) SYSRET // (KC160) LDF (lmn),IX
        if (iskc160()) kc160_ldf_ilmn_xy(opc); // LDF (lmn),IX
        else if (israbbit4k()) r4k_sysret(opc);
        else if ( canz180()) z180_otim(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x8b: // (Z180) otdm // (R4K) LLRET // (KC160) LDF IX,(lmn)
        if (iskc160()) kc160_ldf_xy_ilmn(opc); // LDF IX,(lmn)
        else if ( israbbit4k() ) r4k_llret(opc);
        else if ( canz180()) z180_otdm(opc);
        else st += israbbit() ? 4 : 8;
        st += 8;
        break;
    case 0x93: // (Z180) otimr // (KC160) LDF (lmn),IY
        if (iskc160()) kc160_ldf_ilmn_xy(opc); // LDF (lmn),IY
        else if ( canz180()) z180_otimr(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x9b: // (Z180) otdmr // (KC160) LDF IY,(lmn)
        if (iskc160()) kc160_ldf_xy_ilmn(opc); // LDF IY,(lmn)
        else if ( canz180()) z180_otdmr(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0xcb: // (R4K) JRE Z,dddd
        if (israbbit4k()) r4k_jre(opc, !fr); // JRE Z, dddd
        else st += israbbit() ? 4 : 8;
        break;
    case 0xdb: // (R4K) JRE C,dddd
        if (israbbit4k()) r4k_jre(opc, (ff&256) == 256); // JRE C, dddd
        else st += israbbit() ? 4 : 8;
        break;

    case 0x0a: // (R4K) LDF BC,(lmn) // (KC160) LD XIX,(SP+d)
    case 0x1a: // (R4K) LDF DE,(lmn) // (KC160) LD YIY,(SP+d)
        if (iskc160()) kc160_ld_r24_ixysd(opc);
        else if (israbbit4k()) r4k_ldf_rr_ilmn(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x3a: // (R4K) LDF IY,(lmn)
        if (israbbit4k()) r4k_ldf_rr_ilmn(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x0b: // (R4K) LDF (lmn),BC // LDF XIX,(lmn)
    case 0x1b: // (R4K) LDF (lmn),BC // LDF YIY,(lmn)
        if ( iskc160() ) kc160_ldf_r24_ilmn(opc);
        else if (israbbit4k()) r4k_ldf_ilmn_rr(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x3b: // (R4K) LDF (lmn),IY
        if (israbbit4k()) r4k_ldf_ilmn_rr(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x0e: // (R4K) CONVC PW // (KC160) LD XIX,lmn
    case 0x1e: // (R4K) CONVC PX // (KC160) LD YIY,lmn
    case 0x2e: // (R4K) CONVC PY // (KC160) LD AHL,lmn
        if (iskc160()) kc160_ld_r24_lmn(opc);
        else if (israbbit4k()) r4k_convc(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x80: // (R4K) COPY // (KC160) LD (IY+d),IX
        if ( iskc160() ) kc160_ld_ixysd_xy(opc); // LD (IY+d),IX
        else if ( israbbit4k() ) r4k_copy(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x88: // (R4K) COPYR // (KC160) LD IX,(IY+d)
        if ( iskc160() ) kc160_ld_xy_ixysd(opc); // LD IX,(IY+d)
        else if ( israbbit4k() ) r4k_copyr(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x98: // (R3K) LDDSR / (KC160) LD IY,(IY+d)
        if ( iskc160() ) kc160_ld_xy_ixysd(opc); // LD IY,(IY+d)
        else if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_lddsr(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0xc0: // (R3K) UMA
        if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_uma(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0xc8: // (R3K) UMS
        if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_ums(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0xd0: // (R3K) LSIDR
        if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_lsidr(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0xd8: // (R3K) LSDDR
        if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_lsddr(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0xf0: // (R3K) LSIR // (KC160) LDIR XY
        if ( iskc160() ) kc160_ldir_xy(opc);
        else if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_lsir(opc);
        else st += israbbit() ? 4 : 8;
        break; 
    case 0xf8: // (R3K) LSDR // (KC160) LDDR XY
        if ( iskc160() ) kc160_lddr_xy(opc);
        else if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_lsdr(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0xc6: // (R4K) ADD JKHL,BCDE
    case 0xd6: // (R4K) SUB JKHL,BCDE
    case 0xe6: // (R4K) AND JKHL,BCDE
    case 0xee: // (R4K) XOR JKHL,BCDE
    case 0xf6: // (R4K) OR JKHL,BCDE
        if (israbbit4k()) r4k_alu_jkhl_bcde(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x7f: // (R3K) RDMODE // (KC160) MULS DE,HL
        if ( iskc160()) kc160_muls_de_hl(opc);
        else if (c_cpu & (CPU_R3K|CPU_R4K)) r3k_rdmode(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0xc2:  // (R4K) LLJP NZ // (KC160) JP3 NZ,lmn
        if (iskc160()) kc160_jp3(opc, fr); // JP3 NZ,lmn
        else if (israbbit4k()) r4k_lljp(opc, fr); // LLJP NZ
        else st += israbbit() ? 4 : 8;
        break;
    case 0xca:  // (R4K) LLJP Z // (KC160) JP3 Z,lmn
        if (iskc160()) kc160_jp3(opc, !fr); // JP3 Z,lmn
        else if (israbbit4k()) r4k_lljp(opc, !fr); // LLJP Z
        else st += israbbit() ? 4 : 8;
        break;
    case 0xd2:  // (R4K) LLJP NC // (KC160) JP3 NC,lmn
        if (iskc160()) kc160_jp3(opc, !(ff&256));// JP3 NC,lmn
        else if (israbbit4k()) r4k_lljp(opc, !(ff&256)); // LLJP NC
        else st += israbbit() ? 4 : 8;
        break;
    case 0xda:  // (R4K) LLJP C // (KC160) JP3 C,lmn
        if (iskc160()) kc160_jp3(opc, (ff&256) == 256);// JP3 C,lmn
        else if (israbbit4k()) r4k_lljp(opc, (ff&256) == 256); // LLJP C
        else st += israbbit() ? 4 : 8;
        break;

    case 0xfa: // (R4K) LLCALL (JKHL) // (KC160) INDR X
        if ( iskc160() ) kc160_indr_x(opc);
        else if (israbbit4k()) r4k_llcall_jkhl(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x00: // (R4K) CBM n // (Z180) IN0 B,(n) // (KC160) LD (IY+d),XIX
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if (israbbit4k()) r4k_cbm(opc);
        else if (canz180()) z180_in0(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x01: // (R4K) LD PW,(HTR+HL) // (Z180) OUT0 (n),b // (KC160) LD (IX+d),XIX
    case 0x11: // (R4K) LD PX,(HTR+HL) // (Z180) OUT0 (n),d // (KC160) LD (IX+d),YIY
    case 0x21: // (R4K) LD PY,(HTR+HL) // (Z180) OUT0 (n),h // (KC160) LD (IX+d),AHL
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if (israbbit4k()) r4k_ld_pd_ihtrhl(opc);
        else if (canz180()) z180_out0(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x10:  // (R4K) DWJNZ d // (Z180) IN0 d,(n) // (KC160) LD (IY+d),YIY
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if ( israbbit4k() ) r4k_dwjnz(opc);
        else if (canz180()) z180_in0(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x20:  // (Z180) IN0, H,(n) // (KC160) LD (IY+d),AHL
        if ( iskc160() ) kc160_ld_ixysd_r24(opc);
        else if (canz180()) z180_in0(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x82:  // (EZ80) INIM // (KC160) LD (SP+d),IX
        if ( iskc160() ) kc160_ld_ixysd_xy(opc); // LD (SP+d),IX
        else if ( isez80() ) ez80_inim(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x8c:  // (EZ80) IND2 / (KC160) LD BC,(IY+d)
        if ( iskc160() ) kc160_ld_rr_ixysd(opc); // LD BC,(IY+d)
        else if ( isez80() ) ez80_ind2(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x84:  // (EZ80) INI2 // (KC160) LD (IY+d),BC
        if ( iskc160() ) kc160_ld_ixysd_rr(opc); // LD (IY+d),BC
        else if ( isez80() ) ez80_ini2(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x94:  // (EZ80) INI2R // (KC160) LD (IY+d),DE
        if ( iskc160() ) kc160_ld_ixysd_rr(opc); // LD (IY+d),DE
        else if ( isez80() ) ez80_ini2r(opc); 
        else st += israbbit() ? 4 : 8;
        break;
    case 0x9a: // (EZ80) INDM // (KC160) LD IY,(SP+d)
        if ( iskc160() ) kc160_ld_xy_ixysd(opc); // LD IY,(SP+d)
        else if ( isez80() ) ez80_indm(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x9c: // (EZ80) IND2 // (KC160) LD DE,(IY+d)
        if ( iskc160() ) kc160_ld_rr_ixysd(opc); // LD DE,(IY+d)
        else if ( isez80() ) ez80_ind2(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0xc7: // (EZ80) LD I,HL
        if ( isez80() ) ez80_ld_i_hl(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0xd7: // (EZ80) LD HL,I
        if ( isez80() ) ez80_ld_hl_i(opc);
        else st += israbbit() ? 4 : 8;
        break;





    case 0x81: // (KC160) LD (IX+d),IX
        if ( iskc160() ) kc160_ld_ixysd_xy(opc); // LD (IX+d),IX
        else st += 8;
        break;

    case 0x85: // (KC160) LD (IX+d),BC
    case 0x86: // (KC160) LD (SP+d),BC
    case 0x95: // (KC160) LD (SP+d),DE
    case 0x96: // (KC160) LD (SP+d),DE
    case 0xa6: // (KC160) LD (SP+d),HL
    case 0xb6: // (KC160) LD (SP+d),SP
        if ( iskc160() ) kc160_ld_ixysd_rr(opc);
        else st+= 8;
        break;


    case 0x87: // (KC160) LDF (lmn),BC
    case 0x97: // (KC160) LDF (lmn),DE
    case 0xa7: // (KC160) LDF (lmn),HL
        if ( iskc160() ) kc160_ldf_ilmn_rr(opc);
        else st += 8;
        break;

    case 0x89: // (KC160) LD IX,(IX+d)
    case 0x99: // (KC160) LD IY,(IX+d)
        if ( iskc160() ) kc160_ld_xy_ixysd(opc); // LD IX,(IX+d);
        else st += 8;
        break;

    case 0x8d:  // (KC160) LD BC,(IX+d)
    case 0x8e:  // (KC160) LD BC,(SP+d)
    case 0x9d:  // (KC160) LD DE,(IX+d)
    case 0x9e:  // (KC160) LD DE,(SP+d)
    case 0xad:  // (KC160) LD HL,(IX+d)
    case 0xae:  // (KC160) LD HL,(SP+d)
    case 0xbd:  // (KC160) LD SP,(IX+d)
    case 0xbe:  // (KC160) LD SP,(SP+d)
        if ( iskc160() ) kc160_ld_rr_ixysd(opc); 
        else st += 8;
        break;

    case 0x8f: // (KC160) LDF BC,(lmn)
    case 0x9f: // (KC160) LDF DE,(lmn)
    case 0xaf: // (KC160) LDF HL,(lmn)
    case 0xbf: // (KC160) LDF SP,(lmn)
        if ( iskc160() ) kc160_ldf_rr_ilmn(opc);
        else st += 8;
        break;

    case 0xe0: // (KC160) LDI XY
        if (iskc160()) kc160_ldi_xy(opc);
        else st += 8;
        break;
    case 0xe2: // (KC160) INI X
        if (iskc160()) kc160_ini_x(opc);
        else st += 8;
        break;
    case 0xe8: // (KC160) LDD Xy
        if (iskc160()) kc160_ldd_xy(opc);
        else st += 8;
        break;
    case 0xeb: // (KC160) OUTD X
        if ( iskc160() ) kc160_outd_x(opc);
        else st += 8;
        break;
    case 0xf2: // (KC160) INIR X
        if ( iskc160()) kc160_inir_x(opc);
        else st += 8;
        break;
    case 0xfb: // (KC160) OTDR X
        if ( iskc160() ) kc160_otdr_x(opc);
        else st += 8;
        break;


    case 0xe4: // (KC160) LD YP,XP
    case 0xf4: // (KC160) LD ZP,A
    case 0xec: // (KC160) LD YP,A
    case 0xfc: // (KC160) LD ZP,XP
        if ( iskc160()) kc160_ld_pp_pp(opc); // (KC160) LD A,ZP
        else st += 8;
        break;


    case 0xcd: case 0xce: case 0xcf:
    case 0xdd: case 0xde: case 0xdf:
    case 0xe7:
    case 0xed: case 0xef:
    case 0xf7:
    case 0xff:
        st+= 8; break;



    case 0x26: // (R4K) LD HL,(PY+BC) // (KC160) LD HL,SP
        if ( iskc160() ) kc160_ld_hxy_sp(opc);
        else if ( israbbit4k() ) r4k_ld_hl_ipsbc(opc);
        else st += israbbit() ? 4 : 8;
        break;
    case 0x27: // (ZXN) tst $xx (EZ80) ld hl,(hl) // (R4K) LD (PY+BC),HL
        if ( israbbit4k() ) r4k_ld_ipdbc_hl(opc);  // LD (PY+BC),HL
        else if ( isez80() ) ez80_ld_rr_ihl(opc);  // LD HL,(HL)
        else if ( isz80n() ) { // TST n
            uint8_t v = get_memory_inst(pc++);
            TEST(v, 7);
            st += 11;
        } else {
            st += 8;
        }
        break;

    case 0x30:                                         // (ZXN) mul d,e
        if ( isz80n() ) z80n_mul_d_e();
        else st += 8;
        break;
    case 0x31: // (EZ80) LD IY,(HL) // (R4K) LD PZ,(HTR+HL) // (ZXN) ADD HL,A
        if (israbbit4k()) r4k_ld_pd_ihtrhl(opc);
        else if ( isez80() ) ez80_ld_xy_ihl(opc); // LD IY,(HL)
        else if ( isz80n() ) z80n_add_hl_a();
        else st += 8;
        break;
    case 0x34:                                         // (ZXN) add hl,$xxxx // (R4K) LD PZ,(SP+n)
        if ( israbbit4k() ) {
            r4k_ld_pd_ispn(opc);
        } else if ( canz180() ) {			// (Z180/EZ80) TST A,(HL)
            uint8_t v = get_memory_data(l | h << 8);
            TEST(v, isez80() ? 3 : 10);
        } else if ( isz80n() ) z80n_add_hl_mn();
         else st += 8;
        break;
    case 0x35:                                         // (ZXN) add de,$xxxx // (R4K) LD (SP+n),PZ
        if ( israbbit4k() ) r4k_ld_ispn_ps(opc);
        else if ( isz80n() ) z80n_add_de_mn();
        else st += israbbit() ? 4 : 8;
        break;
    case 0x36:                                         // (ZXN) add bc,$xxxx/ (EZ80) ld iy,(hl) // (R4K) LD HL,(PZ+BC)
        if ( israbbit4k() ) r4k_ld_hl_ipsbc(opc);
        else if ( isez80() ) ez80_ld_xy_ihl(opc);  // LD IY,(HL)
        else if ( isz80n() ) z80n_add_bc_mn();
        else st += israbbit() ? 4 : 8;
        break;
    case 0x37:                                         // (ZXN) inc dehl / (EZ80) ld ix,(hl) // (R4K) LD (PZ+BC),HL
        if ( israbbit4k() ) r4k_ld_ipdbc_hl(opc);
        else if ( isez80() ) ez80_ld_xy_ihl(opc); // LD IX,(HL)
        else st += israbbit() ? 4 : 8;
        break;
    case 0x38:                                         // (ZXN) dec dehl // (R4K) LDF PZ,(lmn) // (Z180) IN0 A,(n)
        if ( israbbit4k()) r4k_ldf_pd_ilmn(opc);
        else if ( canz180()) z180_in0(opc);  // IN0 A,(n)
        else st += 8;
        break;
    case 0x39:                                         // (ZXN) add dehl,a // (R4K) LDF (lmn),PZ // (Z180) OUT0 (n),A
        if ( israbbit4k() ) r4k_ldf_ilmn_ps(opc);
        else if (canz180()) z180_out0(opc);
        else st += 8;
        break;

    case 0x3C:                                         // (ZXN) sub dehl,a // R4K LD PW,klmn
        if ( israbbit4k() ) r4k_ld_pd_klmn(opc);
        else if ( canz180()) TEST(a, isez80() ? 2 : 7);         // (Z180) TST A,A
        else st += israbbit() ? 4 : 8;
        break;
    case 0x3D:                                         // (ZXN) sub dehl,bc // (R4K) LD PZ,mn
        if ( israbbit4k() ) r4k_ldl_pd_mn(opc);
        else st += israbbit() ? 4 : 8;
        break;

    case 0x40:                                         // IN B,(C) // (R4K) LD HTR,A
        if ( israbbit4k()) r4k_ld_htr_a(opc);
        else if ( !israbbit()) INR(b);
        else st += 2;
        break;
    case 0x48:                                         // IN C,(C) // (R4k) CP HL,DE
        if (israbbit4k()) r4k_cp_hl_de(opc);
        else if ( !israbbit()) INR(c);
        else st += 2;
        break;
    case 0x50:                                         // IN D,(C) // (R4K) LD A,HTR
        if ( israbbit4k()) r4k_ld_a_htr(opc);
        else if ( !israbbit()) INR(d);
        else st += 2;
        break;
    case 0x58:                                         // IN E,(C) // (R4k) CP JKHL,BCDE
        if (israbbit4k()) r4k_cp_jkhl_bcde(opc);
        else if ( !israbbit()) INR(e);
        else st += 2;
        break;    
    case 0x60: INR(h); break;                          // IN H,(C)
    case 0x68: INR(l); break;                          // IN L,(C)
    case 0x70: INR(t); break;                          // IN X,(C)
    case 0x78: INR(a); break;                          // IN A,(C)
    case 0x41:                                         // OUT (C),B (RCM) LD BC',DE
        if ( israbbit() ) { // LD BC',DE
            b_ = d;
            c_ = e;
            st += 4;
        } else {
            OUTR(b);
        }
        break;
    case 0x49:                                         // OUT (C),C (RCM) LD BC',BC
        if ( israbbit() ) { // LD BC',BC
            b_ = b;
            c_ = c;
            st += 4;
        } else {
            OUTR(c);
        }
        break;
    case 0x51:                                         // OUT (C),D (RCM) LD DE',DE
        if ( israbbit() ) { // LD DE',DE
            d_ = d;
            e_ = e;
            st += 4;
        } else {
            OUTR(d);
        }
        break;
    case 0x59:                                         // OUT (C),E (RCM) LD DE',BC
        if ( israbbit() ) { // LD DE',BC
            d_ = b;
            e_ = c;
            st += 4;
        } else {
            OUTR(e);
        }
        break;
    case 0x61:                                         // OUT (C),H (RCM) LD HL',DE
        if ( israbbit() ) { // LD HL',DE
            h_ = d;
            l_ = e;
            st += 4;
        } else {
            OUTR(h);
        }
        break;
    case 0x69:                                         // OUT (C),EL(RCM) LD HL',BC
        if ( israbbit() ) { // LD HL',BC
            h_ = b;
            l_ = c;
            st += 4;
        } else {
            OUTR(l);
        }
        break;
    case 0x71: OUTR(0); break;                         // OUT (C),X
    case 0x79: OUTR(a); break;                         // OUT (C),A

    case 0x42: SBCHLRR(b, c); break;                   // SBC HL,BC
    case 0x52: SBCHLRR(d, e); break;                   // SBC HL,DE
    case 0x62: SBCHLRR(h, l); break;                   // SBC HL,HL
    case 0x72: st+= isez80() ? 2 : israbbit() ? 4 : isz180() ? 10 : 15;                                // SBC HL,SP
                v= (mp= l|h<<8)-sp-(ff>>8&1);
                ++mp;
                ff= v>>8;
                fa= h;
                fb= ~sp>>8;
                h= ff;
                l= v;
                fr= h | l<<8; break;
    case 0x4a: ADCHLRR(b, c); break;                   // ADC HL,BC
    case 0x5a: ADCHLRR(d, e); break;                   // ADC HL,DE
    case 0x6a: ADCHLRR(h, l); break;                   // ADC HL,HL
    case 0x7a: st+=isez80() ? 2 : israbbit() ? 4 : isz180() ? 10 : iskc160() ? 2 : 15;                 // ADC HL,SP
                v= (mp= l|h<<8)+sp+(ff>>8&1);
                ++mp;
                ff= v>>8;
                fa= h;
                fb= sp>>8;
                h= ff;
                l= v;
                fr= h | l<<8; break;
    case 0x43: LDPNNRR(b, c, isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : isr800() ? 6 : iskc160() ? 5 : 20); break;               // LD (NN),BC
    case 0x53: LDPNNRR(d, e, isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : isr800() ? 6 : iskc160() ? 5 : 20); break;               // LD (NN),DE
    case 0x63: LDPNNRR(h, l, isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : isr800() ? 6 : iskc160() ? 5 : 20); break;               // LD (NN),HL
    case 0x73: st+= isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : 20;                                // LD (NN),SP
                mp= get_memory_inst(pc++);
                put_memory(mp|= get_memory_inst(pc++)<<8, sp);
                put_memory(++mp,sp>>8); break;
    case 0x4b: LDRRPNN(b, c, isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : isr800() ? 6 : iskc160() ? 5 : 20); break;               // LD BC,(NN)
    case 0x5b: LDRRPNN(d, e, isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : isr800() ? 6 : iskc160() ? 5 : 20); break;               // LD DE,(NN)
    case 0x6b: LDRRPNN(h, l, isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : isr800() ? 6 : iskc160() ? 5 : 20); break;               // LD HL,(NN)
    case 0x7b: st+= isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : isr800() ? 6 : iskc160() ? 5 : 20;                                // LD SP,(NN)
                t= get_memory_inst(pc++);
                sp= get_memory_data(t|= get_memory_inst(pc++)<<8);
                sp|= get_memory_data(mp= t+1) << 8; break;







    case 0x4c:   // (Z180) MLT BC // (KC160) call3 lmn
        if ( iskc160() ) kc160_call3(opc);
        else if ( canz180() ) z180_mlt(opc);
        else UNDOCUMENTED_NEG();
        break;
    case 0x5c:   // (Z180) MLT DE
        if ( canz180() ) z180_mlt(opc);
         else UNDOCUMENTED_NEG();
        break;
    case 0x6c:   // (Z180) MLT HL // (R4K) LDP HL,(HL)
        if (israbbit()) rxk_ldp_hl_irr(opc, 0xed);
        else if ( canz180() ) z180_mlt(opc);
        else UNDOCUMENTED_NEG();
        break;
    case 0x7c:   // (R4k) EX JK',HL // (Z180) MLT SP // (KC160) DIVS HL,A
        if ( iskc160() ) kc160_divs_hl_a(opc);
        else if ( israbbit4k() ) r4k_ex_jk1_hl(opc);
        else if ( canz180() ) z180_mlt(opc);   // (Z180) MLT SP
        else UNDOCUMENTED_NEG();
        break;









    case 0x44:       // NEG
        st+= 8;
        fr= a= (ff= (fb= ~a)+1);
        fa= 0; 
        break;
    case 0x45:  // RETN // (RCM) LRET
        if (israbbit()) rxk_lret(opc);
        else RET(isz180() ? 12 : 14); 
        break;
    case 0x46:  // IM0 // (RCM) IPSET 0
        if (israbbit()) rxk_ipset(opc);
        else { st+= 8; im= 0; }
        break;
    case 0x47: // LD I,A // (RCM) LD EIR,A
        if (israbbit()) rxk_ld_eir_a(opc);
        else LDRR(i, a, i, israbbit() ? 4 : isz180() ? 6 : isr800() ? 2 : iskc160() ? 2 : 9); 
        break;
    case 0x4d:  // RETI
        RET(israbbit() ? 12 : isz180() ? 12 : 14); 
        break;
    case 0x4e:  // IM0 (undoc)  // (RCM) IPSET 2 // (KC160) IM 3
        if (iskc160()) kc160_im3(opc);
        else if (israbbit()) rxk_ipset(opc);
        else UNDOCUMENTED_IM0();
        break;
    case 0x4f: // LD R,A // (RCM) LD IIR, A
        if (israbbit()) rxk_ld_iir_a(opc); 
        else { LDRR(r, a, r, israbbit() ? 4 : isz180() ? 6 : isr800() ? 2 : iskc160() ? 2 : 9); r7= r; }
        break;
    case 0x54:	// (RCM) ex (sp),hl,  (EZ80) LEA IX,IY+d // (KC160) TRA
        if ( iskc160() ) kc160_tra(opc);
        else if ( israbbit() ) { // EX (SP),HL
            EXSPI(h, l);
            st += 4;
            break;
        } else if ( isez80() ) ez80_lea_xy_yd(opc); // LEA IX,IY+d
         else UNDOCUMENTED_NEG();
        break;
    case 0x55:    // (EZ80) LEA IY,IX+d // (R4K) SCALL/FSYSCALL // (KC160) RETN3
        if( iskc160()) kc160_retn3(opc);
        else if ( israbbit4k() )  r4k_fsyscall(opc);
        else if ( isez80() ) ez80_lea_xy_xd(opc); // LEA IY,IX+d
        else UNDOCUMENTED_RETN();
        break;
    case 0x56:  // IM1 // (RCM) IPSET 1
        if (israbbit()) rxk_ipset(opc);
        else { st+= 8; im= 1; }
        break;
    case 0x57:  // LD A,I // (RCM) LD A,EIR
        if ( israbbit() ) rxk_ld_a_eir(opc);
        else {
            st += israbbit() ? 4 : isz180() ? 6 : 9;
            ff=  ff&-256
                | (a= i);
            fr= !!a;
            fa= fb= iff<<7 & 128; 
        }
        break;
    case 0x5d:
        if ( israbbit() ) rxk_ipres(opc);
        else UNDOCUMENTED_RETN();
        break;
    case 0x5e: // IM2 // (RCM) IPSET 3
        if (israbbit()) rxk_ipset(opc);
        else { st+= 8; im= 2; }
        break;
    case 0x5f:  // LD A,R // (RCM) LD A,IIR
        if ( israbbit() ) rxk_ld_a_iir(opc);
        else {
            st += israbbit() ? 4 : isz180() ? 6 : isr800() ? 2 : iskc160() ? 2 : 9;
            ff=  ff&-256
                | (a= (r&127|r7&128));
            fr= !!a;
            fa= fb= iff<<7 & 128; 
        }
        break;
    case 0x65:    // (EZ80) PEA ix+d // (RCM) LDP (mn),HL
        if ( israbbit() ) rxk_ldp_inm_rr(opc, 0xed);
        else if ( isez80() ) ez80_pea_xyd(opc); // PEA IX+d
        else UNDOCUMENTED_RETN();
        break;
    case 0x66:    // (EZ80) PEA iy+d // (R3K) PUSH SU
        if ( isez80() ) ez80_pea_xyd(opc);  // PEA IY+d
        else if ((c_cpu & (CPU_R3K|CPU_R4K)) ) r3k_push_su(opc);
        else UNDOCUMENTED_IM0();
        break;
    case 0x67:  // RRD // (RCM) LD XPC,A
        if ( israbbit() ) rxk_ld_xpc_a(opc);
        else zilog_rrd(opc);
        break;
    case 0x6d:  // (EZ80) LD MB,A // (RCM) LD hl,(nmn) // RETN (UNDOC)
        if ( isez80() ) ez80_ld_mb_a(opc);
        else if (israbbit()) rxk_ldp_rr_inm(opc, 0xed);
        else UNDOCUMENTED_RETN();
        break;
    case 0x6e:  // IM 0 (undoc) // (R3K) POP SU // (EZ80) LD A,MB
        if ( isez80() ) ez80_ld_a_mb(opc);
        else if ((c_cpu & (CPU_R3K|CPU_R4K)) ) r3k_pop_su(opc);
        else UNDOCUMENTED_IM0();
        break;
    case 0x6f: // RLD  // (R3K) SETUSR
        if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_setusr(opc);
        else if ( !israbbit() ) zilog_rld(opc);
        break;
    case 0x74: 
        UNDOCUMENTED_NEG();
        break;
    case 0x75: 
        if (israbbit4k()) r4k_syscall(opc);
        else UNDOCUMENTED_RETN();
        break;
    case 0x76:  // IM1 (undoc) // (RCM) PUSH IP // (Z180) SLP // (KC160) MUL HL
        if  (iskc160()) kc160_mul_hl(opc);
        else if ( canz180() ) z180_slp(opc);
        else if ( israbbit()) rxk_push_ip(opc);
        else UNDOCUMENTED_IM1();
        break;
    case 0x77: // (RCM) LD A,XPC // (KC160) MUL DE,HL
        if ( iskc160() ) kc160_mul_de_hl(opc);
        else if ( israbbit() ) rxk_ld_a_xpc(opc);
        else st += 8;
        break;
    case 0x7d: // (R3K) SURES // (EZ80) STMIX // (KC160) DIVS DEHL,BC
        if ( iskc160()) kc160_divs_dehl_bc(opc);
        else if ( isez80() ) ez80_stmix(opc);
        else if ( c_cpu & (CPU_R3K|CPU_R4K)) r3k_sures(opc);
        else UNDOCUMENTED_RETN();
        break;
    case 0x7e: // IM 2  (undoc) / (RCM) POP IP // (EZ80) RSMIX // (KC160) MULS HL
        if ( iskc160()) kc160_muls_hl(opc);
        else if ( isez80() ) ez80_rsmix(opc);
        else if (israbbit()) rxk_pop_ip(opc);
        else UNDOCUMENTED_IM2();
        break;

    case 0x8a:                                         // (ZXN) push $xxxx // (EZ80) INDM / (KC160) LD IX,(SP+d)
        if ( iskc160() ) kc160_ld_xy_ixysd(opc); // LD IX,(SP+d);
        else if ( isez80() ) ez80_indm(opc);
        else if ( isz80n() ) z80n_push_mn();
        else st += 8;
        break;

    case 0xa0: // LDI
        st+= israbbit() ? 10 : isz180() ? 12 : isr800() ? 4 : iskc160() ? 4 : 16;
        // Only dest is affected by ioi/ioe on a rabbit
        {
            uint8_t s_ioi = ioi, s_ioe = ioe;
            ioi = ioe = 0;
            t =  get_memory_data(l | h<<8);
            ioi = s_ioi; ioe = s_ioe;
            put_memory(e | d<<8, t);
        }
        ++l || h++;
        ++e || d++;
        c-- || b--;
        fr && (fr= 1);
        t+= a;
        ff=  ff    & -41
        | t     &   8
        | t<<4  &  32;
        fa= 0;
        b|c && (fa= 128);
        fb= fa; 
        break;
    case 0xa8: // LDD
        st+= israbbit() ? 10 : isz180() ? 12 :  isr800() ? 4 : iskc160() ? 4 : 16;
        // On a rabbit only destination is affected by ioi/ioe
        {
            uint8_t s_ioi = ioi, s_ioe = ioe;
            ioi = ioe = 0;
            t = get_memory_data(l | h<<8);
            ioi = s_ioi; ioe = s_ioe;
            put_memory(e | d<<8, t);
        }
        l-- || h--;
        e-- || d--;
        c-- || b--;
        fr && (fr= 1);
        t+= a;
        ff=  ff    & -41
        | t     &   8
        | t<<4  &  32;
        fa= 0;
        b|c && (fa= 128);
        fb= fa; 
        break;
    case 0xb0: st+= israbbit() ? 7 : isz180() ? 12 :  isr800() ? 4 : iskc160() ? 4 : 16;                                // LDIR
        // On a rabbit only destination is affected by ioi/ioe
        {
            uint8_t s_ioi = ioi, s_ioe = ioe;
            ioi = ioe = 0;
            t = get_memory_data(l | h<<8);
            ioi = s_ioi; ioe = s_ioe;
            put_memory(e | d<<8, t);
        }
        ++l || h++;
        ++e || d++;
        c-- || b--;
        fr && (fr= 1);
        t+= a;
        ff=  ff    & -41
        | t     &   8
        | t<<4  &  32;
        fa= 0;
        b|c && ( fa= 128,
                st+= israbbit() ? 6 : isz180() ? 2 : 5,
                mp= --pc,
                --pc);
        if (ioe|ioi) --pc;  // Pick up the IO prefix again
        fb= fa; break;
    case 0xb8: st+= israbbit() ? 7 : isz180() ? 12 :  isr800() ? 4 : iskc160() ? 4 : 16;                                // LDDR
        // On a rabbit only destination is affected by ioi/ioe
        {
            uint8_t s_ioi = ioi, s_ioe = ioe;
            ioi = ioe = 0;
            t = get_memory_data(l | h<<8);
            ioi = s_ioi; ioe = s_ioe;
            put_memory(e | d<<8, t);
        }
        l-- || h--;
        e-- || d--;
        c-- || b--;
        fr && (fr= 1);
        t+= a;
        ff=  ff    & -41
        | t     &   8
        | t<<4  &  32;
        fa= 0;
        b|c && ( fa= 128,
                st+= israbbit() ? 6 : isz180() ? 2 : 5,
                mp= --pc,
                --pc);
        if (ioe|ioi) --pc;  // Pick up the IO prefix again
        fb= fa; break;
    case 0xa1:    // CPI
        if ( israbbit() ) RABBIT_UNDEFINED(0xeda1, "cpi", 4);
        else zilog_cpi(opc);
        break;
    case 0xa9:  // CPD
        if ( israbbit() ) RABBIT_UNDEFINED(0xeda9, "cpd", 4);
        else zilog_cpd(opc);
        break;
    case 0xb1: // CPIR // (R4K) SETSYSP mn
        if ( israbbit4k()) r4k_setsysp_mn(opc);
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedb1, "cpir", 4);
        else zilog_cpir(opc);
        break;
    case 0xb9: // CPDR
        if ( israbbit() ) RABBIT_UNDEFINED(0xedb9, "cpdr", 4);
        else zilog_cpdr(opc);
        break;
    case 0xa2:  // INI // (R4K) LLJP GT
        if ( israbbit4k() ) r4k_lljp(opc, F_GT(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xeda2, "ini", 4);
        else zilog_ini(opc);
        break;
    case 0xaa: // IND // (R4K) LLJP GTU
        if ( israbbit4k() ) r4k_lljp(opc, F_GTU(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedaa, "ind", 4);
        else zilog_ind(opc);
        break;
    case 0xb2:  // INIR // (R4K) LLJP LT
        if ( israbbit4k() ) r4k_lljp(opc, F_LT(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedb2, "inir", 4);
        else zilog_inir(opc);
        break;
    case 0xba:  // INDR // (R4K) LLJP V
        if ( israbbit4k() ) r4k_lljp(opc, F_V(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedba, "indr", 4);
        else zilog_indr(opc);
        break;
    case 0xa3:  // OUTI
        if ( israbbit4k() ) r4k_jre(opc, F_GT(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xeda3, "outi", 4);
        else zilog_outi(opc);
        break;
    case 0xab:  // OUTD
        if ( israbbit4k() ) r4k_jre(opc, F_GTU(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedab, "outd", 4);
        else zilog_outd(opc);
        break;
    case 0xb3:  // OTIR
        if ( israbbit4k() ) r4k_jre(opc, F_LT(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedb3, "otir", 4);
        else zilog_otir(opc);
        break;
    case 0xbb: // OTDR
        if ( israbbit4k() ) r4k_jre(opc, F_V(f()));
        else if ( israbbit() ) RABBIT_UNDEFINED(0xedbb, "otdr", 4);
        else zilog_otdr(opc);
        break;


    case 0xb5:  // (R4K) SETUSRP nm // (KC160) LD (IX+d),SP
        if ( iskc160() ) kc160_ld_ixysd_rr(opc); // LD (IX+d),SP
        else if (israbbit4k()) r4k_setusrp_mn(opc);
        else st += 8; 
        break;


    case 0xea: // (R4K) CALL (HL) // (KC160) IND X
        if ( iskc160() ) kc160_ind_x(opc);
        else if ( israbbit4k() ) {  // CALL (HL)
            st += 12;
            put_memory(--sp, pc >> 8);
            put_memory(--sp, pc);
            mp = pc = (h<<8)|l;
        } else {
            st += 8;
        }
        break;

    case 0xfd: 
        PatchZ80(); 
        break;
    case 0xfe:   // (R4K) LD HL,(SP+HL) 
        if ( israbbit4k() ) r4k_ld_hl_isphl(opc);
        else PatchZ80();
        break;

    }
}

static void handle_cb_page(void)
{
    uint8_t opc;
    r++;
    if( ih )
        switch( (opc = get_memory_inst(pc++)) ){
        case 0x00:  RLC(b,b_); break;                       // RLC B
        case 0x01:  RLC(c,c_); break;                       // RLC C
        case 0x02:  RLC(d,d_); break;                       // RLC D
        case 0x03:  RLC(e,e_); break;                       // RLC E
        case 0x04:  RLC(h,h_); break;                       // RLC H
        case 0x05:  RLC(l,l_); break;                       // RLC L
        case 0x06:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // RLC (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    RLC(u,u);
                    put_memory(t, u); break;
        case 0x07:  RLC(a,a_); break;                       // RLC A
        case 0x08:  RRC(b,b_); break;                       // RRC B
        case 0x09:  RRC(c,c_); break;                       // RRC C
        case 0x0a:  RRC(d,d_); break;                       // RRC D
        case 0x0b:  RRC(e,e_); break;                       // RRC E
        case 0x0c:  RRC(h,h_); break;                       // RRC H
        case 0x0d:  RRC(l,l_); break;                       // RRC L
        case 0x0e:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // RRC (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    RRC(u,u);
                    put_memory(t, u); break;
        case 0x0f:  RRC(a,a_); break;                       // RRC A
        case 0x10:  RL(b,b_); break;                        // RL B
        case 0x11:  RL(c,c_); break;                        // RL C
        case 0x12:  RL(d,d_); break;                        // RL D
        case 0x13:  RL(e,e_); break;                        // RL E
        case 0x14:  RL(h,h_); break;                        // RL H
        case 0x15:  RL(l,l_); break;                        // RL L
        case 0x16:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // RL (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    RL(u,u);
                    put_memory(t, u); break;
        case 0x17:  RL(a,a_); break;                        // RL A
        case 0x18:  RR(b,b_); break;                        // RR B
        case 0x19:  RR(c,c_); break;                        // RR C
        case 0x1a:  RR(d,d_); break;                        // RR D
        case 0x1b:  RR(e,e_); break;                        // RR E
        case 0x1c:  RR(h,h_); break;                        // RR H
        case 0x1d:  RR(l,l_); break;                        // RR L
        case 0x1e:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // RR (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    u=get_memory_data(t);
                    RR(u,u);
                    put_memory(t, u); break;
        case 0x1f:  RR(a,a_); break;                        // RR A
        case 0x20:  SLA(b,b_); break;                       // SLA B
        case 0x21:  SLA(c,c_); break;                       // SLA C
        case 0x22:  SLA(d,d_); break;                       // SLA D
        case 0x23:  SLA(e,e_); break;                       // SLA E
        case 0x24:  SLA(h,h_); break;                       // SLA H
        case 0x25:  SLA(l,l_); break;                       // SLA L
        case 0x26:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // SLA (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    SLA(u,u);
                    put_memory(t, u); break;
        case 0x27:  SLA(a,a_); break;                       // SLA A
        case 0x28:  SRA(b,b_); break;                       // SRA B
        case 0x29:  SRA(c,c_); break;                       // SRA C
        case 0x2a:  SRA(d,d_); break;                       // SRA D
        case 0x2b:  SRA(e,e_); break;                       // SRA E
        case 0x2c:  SRA(h,h_); break;                       // SRA H
        case 0x2d:  SRA(l,l_); break;                       // SRA L
        case 0x2e:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // SRA (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    SRA(u,u);
                    put_memory(t, u); break;
        case 0x2f:  SRA(a,a_); break;                       // SRA A
        case 0x30:  if ( isgbz80()) { SWAP(b); } else { SLL(b); } break;                       // SLL B,  SWAP B (gbz80)
        case 0x31:  if ( isgbz80()) { SWAP(c); } else { SLL(c); } break;                       // SLL C,  SWAP C (gbz80)
        case 0x32:  if ( isgbz80()) { SWAP(d); } else { SLL(d); } break;                       // SLL D,  SWAP D (gbz80)
        case 0x33:  if ( isgbz80()) { SWAP(e); } else { SLL(e); } break;                       // SLL E,  SWAP E (gbz80)
        case 0x34:  if ( isgbz80()) { SWAP(h); } else { SLL(h); } break;                       // SLL H,  SWAP H (gbz80)
        case 0x35:  if ( isgbz80()) { SWAP(l); } else { SLL(l); } break;                       // SLL L,  SWAP L (gbz80)
        case 0x36:                                       // SLL (HL),  SWAP (hl) (gbz80)
            if ( isgbz80() ) { // SWAP (HL)
                st += 8;
                t= l|h<<8;
                u=get_memory_data(t);
                SWAP(u);
                put_memory(t, u);
            } else if (cansll() ) {
                st+= 7;
                t= l|h<<8;
                u=get_memory_data(t);
                SLL(u);
                put_memory(t, u);
            }
            break;
        case 0x37:  if ( isgbz80()) { SWAP(a); } else { SLL(a); } break;                       // SLL A,  SWAP A (gbz80)
        case 0x38:  SRL(b,b_); break;                       // SRL B
        case 0x39:  SRL(c,c_); break;                       // SRL C
        case 0x3a:  SRL(d,d_); break;                       // SRL D
        case 0x3b:  SRL(e,e_); break;                       // SRL E
        case 0x3c:  SRL(h,h_); break;                       // SRL H
        case 0x3d:  SRL(l,l_); break;                       // SRL L
        case 0x3e:  st+= israbbit() ? 6 : isgbz80() ? 8 : isz180() ? 6 : 7;             // SRL (HL)
                    t= l|h<<8;
                    u=get_memory_data(t);
                    SRL(u,u);
                    put_memory(t, u); break;
        case 0x3f:  SRL(a,a_); break;                       // SRL A
        case 0x40:  BIT(1, b); break;                    // BIT 0,B
        case 0x41:  BIT(1, c); break;                    // BIT 0,C
        case 0x42:  BIT(1, d); break;                    // BIT 0,D
        case 0x43:  BIT(1, e); break;                    // BIT 0,E
        case 0x44:  BIT(1, h); break;                    // BIT 0,H
        case 0x45:  BIT(1, l); break;                    // BIT 0,L
        case 0x46:  BITHL(1); break;                     // BIT 0,(HL)
        case 0x47:  BIT(1, a); break;                    // BIT 0,A
        case 0x48:  BIT(2, b); break;                    // BIT 1,B
        case 0x49:  BIT(2, c); break;                    // BIT 1,C
        case 0x4a:  BIT(2, d); break;                    // BIT 1,D
        case 0x4b:  BIT(2, e); break;                    // BIT 1,E
        case 0x4c:  BIT(2, h); break;                    // BIT 1,H
        case 0x4d:  BIT(2, l); break;                    // BIT 1,L
        case 0x4e:  BITHL(2); break;                     // BIT 1,(HL)
        case 0x4f:  BIT(2, a); break;                    // BIT 1,A
        case 0x50:  BIT(4, b); break;                    // BIT 2,B
        case 0x51:  BIT(4, c); break;                    // BIT 2,C
        case 0x52:  BIT(4, d); break;                    // BIT 2,D
        case 0x53:  BIT(4, e); break;                    // BIT 2,E
        case 0x54:  BIT(4, h); break;                    // BIT 2,H
        case 0x55:  BIT(4, l); break;                    // BIT 2,L
        case 0x56:  BITHL(4); break;                     // BIT 2,(HL)
        case 0x57:  BIT(4, a); break;                    // BIT 2,A
        case 0x58:  BIT(8, b); break;                    // BIT 3,B
        case 0x59:  BIT(8, c); break;                    // BIT 3,C
        case 0x5a:  BIT(8, d); break;                    // BIT 3,D
        case 0x5b:  BIT(8, e); break;                    // BIT 3,E
        case 0x5c:  BIT(8, h); break;                    // BIT 3,H
        case 0x5d:  BIT(8, l); break;                    // BIT 3,L
        case 0x5e:  BITHL(8); break;                     // BIT 3,(HL)
        case 0x5f:  BIT(8, a); break;                    // BIT 3,A
        case 0x60:  BIT(16, b); break;                   // BIT 4,B
        case 0x61:  BIT(16, c); break;                   // BIT 4,C
        case 0x62:  BIT(16, d); break;                   // BIT 4,D
        case 0x63:  BIT(16, e); break;                   // BIT 4,E
        case 0x64:  BIT(16, h); break;                   // BIT 4,H
        case 0x65:  BIT(16, l); break;                   // BIT 4,L
        case 0x66:  BITHL(16); break;                    // BIT 4,(HL)
        case 0x67:  BIT(16, a); break;                   // BIT 4,A
        case 0x68:  BIT(32, b); break;                   // BIT 5,B
        case 0x69:  BIT(32, c); break;                   // BIT 5,C
        case 0x6a:  BIT(32, d); break;                   // BIT 5,D
        case 0x6b:  BIT(32, e); break;                   // BIT 5,E
        case 0x6c:  BIT(32, h); break;                   // BIT 5,H
        case 0x6d:  BIT(32, l); break;                   // BIT 5,L
        case 0x6e:  BITHL(32); break;                    // BIT 5,(HL)
        case 0x6f:  BIT(32, a); break;                   // BIT 5,A
        case 0x70:  BIT(64, b); break;                   // BIT 6,B
        case 0x71:  BIT(64, c); break;                   // BIT 6,C
        case 0x72:  BIT(64, d); break;                   // BIT 6,D
        case 0x73:  BIT(64, e); break;                   // BIT 6,E
        case 0x74:  BIT(64, h); break;                   // BIT 6,H
        case 0x75:  BIT(64, l); break;                   // BIT 6,L
        case 0x76:  BITHL(64); break;                    // BIT 6,(HL)
        case 0x77:  BIT(64, a); break;                   // BIT 6,A
        case 0x78:  BIT(128, b); break;                  // BIT 7,B
        case 0x79:  BIT(128, c); break;                  // BIT 7,C
        case 0x7a:  BIT(128, d); break;                  // BIT 7,D
        case 0x7b:  BIT(128, e); break;                  // BIT 7,E
        case 0x7c:  BIT(128, h); break;                  // BIT 7,H
        case 0x7d:  BIT(128, l); break;                  // BIT 7,L
        case 0x7e:  BITHL(128); break;                   // BIT 7,(HL)
        case 0x7f:  BIT(128, a); break;                  // BIT 7,A
        case 0x80:  RES(254, b); break;                  // RES 0,B
        case 0x81:  RES(254, c); break;                  // RES 0,C
        case 0x82:  RES(254, d); break;                  // RES 0,D
        case 0x83:  RES(254, e); break;                  // RES 0,E
        case 0x84:  RES(254, h); break;                  // RES 0,H
        case 0x85:  RES(254, l); break;                  // RES 0,L
        case 0x86:  RESHL(254); break;                   // RES 0,(HL)
        case 0x87:  RES(254, a); break;                  // RES 0,A
        case 0x88:  RES(253, b); break;                  // RES 1,B
        case 0x89:  RES(253, c); break;                  // RES 1,C
        case 0x8a:  RES(253, d); break;                  // RES 1,D
        case 0x8b:  RES(253, e); break;                  // RES 1,E
        case 0x8c:  RES(253, h); break;                  // RES 1,H
        case 0x8d:  RES(253, l); break;                  // RES 1,L
        case 0x8e:  RESHL(253); break;                   // RES 1,(HL)
        case 0x8f:  RES(253, a); break;                  // RES 1,A
        case 0x90:  RES(251, b); break;                  // RES 2,B
        case 0x91:  RES(251, c); break;                  // RES 2,C
        case 0x92:  RES(251, d); break;                  // RES 2,D
        case 0x93:  RES(251, e); break;                  // RES 2,E
        case 0x94:  RES(251, h); break;                  // RES 2,H
        case 0x95:  RES(251, l); break;                  // RES 2,L
        case 0x96:  RESHL(251); break;                   // RES 2,(HL)
        case 0x97:  RES(251, a); break;                  // RES 2,A
        case 0x98:  RES(247, b); break;                  // RES 3,B
        case 0x99:  RES(247, c); break;                  // RES 3,C
        case 0x9a:  RES(247, d); break;                  // RES 3,D
        case 0x9b:  RES(247, e); break;                  // RES 3,E
        case 0x9c:  RES(247, h); break;                  // RES 3,H
        case 0x9d:  RES(247, l); break;                  // RES 3,L
        case 0x9e:  RESHL(247); break;                   // RES 3,(HL)
        case 0x9f:  RES(247, a); break;                  // RES 3,A
        case 0xa0:  RES(239, b); break;                  // RES 4,B
        case 0xa1:  RES(239, c); break;                  // RES 4,C
        case 0xa2:  RES(239, d); break;                  // RES 4,D
        case 0xa3:  RES(239, e); break;                  // RES 4,E
        case 0xa4:  RES(239, h); break;                  // RES 4,H
        case 0xa5:  RES(239, l); break;                  // RES 4,L
        case 0xa6:  RESHL(239); break;                   // RES 4,(HL)
        case 0xa7:  RES(239, a); break;                  // RES 4,A
        case 0xa8:  RES(223, b); break;                  // RES 5,B
        case 0xa9:  RES(223, c); break;                  // RES 5,C
        case 0xaa:  RES(223, d); break;                  // RES 5,D
        case 0xab:  RES(223, e); break;                  // RES 5,E
        case 0xac:  RES(223, h); break;                  // RES 5,H
        case 0xad:  RES(223, l); break;                  // RES 5,L
        case 0xae:  RESHL(223); break;                   // RES 5,(HL)
        case 0xaf:  RES(223, a); break;                  // RES 5,A
        case 0xb0:  RES(191, b); break;                  // RES 6,B
        case 0xb1:  RES(191, c); break;                  // RES 6,C
        case 0xb2:  RES(191, d); break;                  // RES 6,D
        case 0xb3:  RES(191, e); break;                  // RES 6,E
        case 0xb4:  RES(191, h); break;                  // RES 6,H
        case 0xb5:  RES(191, l); break;                  // RES 6,L
        case 0xb6:  RESHL(191); break;                   // RES 6,(HL)
        case 0xb7:  RES(191, a); break;                  // RES 6,A
        case 0xb8:  RES(127, b); break;                  // RES 7,B
        case 0xb9:  RES(127, c); break;                  // RES 7,C
        case 0xba:  RES(127, d); break;                  // RES 7,D
        case 0xbb:  RES(127, e); break;                  // RES 7,E
        case 0xbc:  RES(127, h); break;                  // RES 7,H
        case 0xbd:  RES(127, l); break;                  // RES 7,L
        case 0xbe:  RESHL(127); break;                   // RES 7,(HL)
        case 0xbf:  RES(127, a); break;                  // RES 7,A
        case 0xc0:  SET(1, b); break;                    // SET 0,B
        case 0xc1:  SET(1, c); break;                    // SET 0,C
        case 0xc2:  SET(1, d); break;                    // SET 0,D
        case 0xc3:  SET(1, e); break;                    // SET 0,E
        case 0xc4:  SET(1, h); break;                    // SET 0,H
        case 0xc5:  SET(1, l); break;                    // SET 0,L
        case 0xc6:  SETHL(1); break;                     // SET 0,(HL)
        case 0xc7:  SET(1, a); break;                    // SET 0,A
        case 0xc8:  SET(2, b); break;                    // SET 1,B
        case 0xc9:  SET(2, c); break;                    // SET 1,C
        case 0xca:  SET(2, d); break;                    // SET 1,D
        case 0xcb:  SET(2, e); break;                    // SET 1,E
        case 0xcc:  SET(2, h); break;                    // SET 1,H
        case 0xcd:  SET(2, l); break;                    // SET 1,L
        case 0xce:  SETHL(2); break;                     // SET 1,(HL)
        case 0xcf:  SET(2, a); break;                    // SET 1,A
        case 0xd0:  SET(4, b); break;                    // SET 2,B
        case 0xd1:  SET(4, c); break;                    // SET 2,C
        case 0xd2:  SET(4, d); break;                    // SET 2,D
        case 0xd3:  SET(4, e); break;                    // SET 2,E
        case 0xd4:  SET(4, h); break;                    // SET 2,H
        case 0xd5:  SET(4, l); break;                    // SET 2,L
        case 0xd6:  SETHL(4); break;                     // SET 2,(HL)
        case 0xd7:  SET(4, a); break;                    // SET 2,A
        case 0xd8:  SET(8, b); break;                    // SET 3,B
        case 0xd9:  SET(8, c); break;                    // SET 3,C
        case 0xda:  SET(8, d); break;                    // SET 3,D
        case 0xdb:  SET(8, e); break;                    // SET 3,E
        case 0xdc:  SET(8, h); break;                    // SET 3,H
        case 0xdd:  SET(8, l); break;                    // SET 3,L
        case 0xde:  SETHL(8); break;                     // SET 3,(HL)
        case 0xdf:  SET(8, a); break;                    // SET 3,A
        case 0xe0:  SET(16, b); break;                   // SET 4,B
        case 0xe1:  SET(16, c); break;                   // SET 4,C
        case 0xe2:  SET(16, d); break;                   // SET 4,D
        case 0xe3:  SET(16, e); break;                   // SET 4,E
        case 0xe4:  SET(16, h); break;                   // SET 4,H
        case 0xe5:  SET(16, l); break;                   // SET 4,L
        case 0xe6:  SETHL(16); break;                    // SET 4,(HL)
        case 0xe7:  SET(16, a); break;                   // SET 4,A
        case 0xe8:  SET(32, b); break;                   // SET 5,B
        case 0xe9:  SET(32, c); break;                   // SET 5,C
        case 0xea:  SET(32, d); break;                   // SET 5,D
        case 0xeb:  SET(32, e); break;                   // SET 5,E
        case 0xec:  SET(32, h); break;                   // SET 5,H
        case 0xed:  SET(32, l); break;                   // SET 5,L
        case 0xee:  SETHL(32); break;                    // SET 5,(HL)
        case 0xef:  SET(32, a); break;                   // SET 5,A
        case 0xf0:  SET(64, b); break;                   // SET 6,B
        case 0xf1:  SET(64, c); break;                   // SET 6,C
        case 0xf2:  SET(64, d); break;                   // SET 6,D
        case 0xf3:  SET(64, e); break;                   // SET 6,E
        case 0xf4:  SET(64, h); break;                   // SET 6,H
        case 0xf5:  SET(64, l); break;                   // SET 6,L
        case 0xf6:  SETHL(64); break;                    // SET 6,(HL)
        case 0xf7:  SET(64, a); break;                   // SET 6,A
        case 0xf8:  SET(128, b); break;                  // SET 7,B
        case 0xf9:  SET(128, c); break;                  // SET 7,C
        case 0xfa:  SET(128, d); break;                  // SET 7,D
        case 0xfb:  SET(128, e); break;                  // SET 7,E
        case 0xfc:  SET(128, h); break;                  // SET 7,H
        case 0xfd:  SET(128, l); break;                  // SET 7,L
        case 0xfe:  SETHL(128); break;                   // SET 7,(HL)
        case 0xff:  SET(128, a); break;                  // SET 7,A
        }
    else{
        st+= isz180() ? 9 : 11;
        if( iy )
            t= get_memory_data(mp= ((get_memory_inst(pc++)^128)-128+(yl|yh<<8)));
        else
            t= get_memory_data(mp= ((get_memory_inst(pc++)^128)-128+(xl|xh<<8)));
        switch( get_memory_inst(pc++) ){
        case 0x00: RLC(t,t); put_memory(mp, b=t); break;         // LD B,RLC (IX+d) // LD B,RLC (IY+d)
        case 0x01: RLC(t,t); put_memory(mp, c=t); break;         // LD C,RLC (IX+d) // LD C,RLC (IY+d)
        case 0x02: RLC(t,t); put_memory(mp, d=t); break;         // LD D,RLC (IX+d) // LD D,RLC (IY+d)
        case 0x03: RLC(t,t); put_memory(mp, e=t); break;         // LD E,RLC (IX+d) // LD E,RLC (IY+d)
        case 0x04: RLC(t,t); put_memory(mp, h=t); break;         // LD H,RLC (IX+d) // LD H,RLC (IY+d)
        case 0x05: RLC(t,t); put_memory(mp, l=t); break;         // LD L,RLC (IX+d) // LD L,RLC (IY+d)
        case 0x06: RLC(t,t); put_memory(mp, t); break;            // RLC (IX+d) // RLC (IY+d)
        case 0x07: RLC(t,t); put_memory(mp, a=t); break;         // LD A,RLC (IX+d) // LD A,RLC (IY+d)
        case 0x08: RRC(t,t); put_memory(mp, b=t); break;         // LD B,RRC (IX+d) // LD B,RRC (IY+d)
        case 0x09: RRC(t,t); put_memory(mp, c=t); break;         // LD C,RRC (IX+d) // LD C,RRC (IY+d)
        case 0x0a: RRC(t,t); put_memory(mp, d=t); break;         // LD D,RRC (IX+d) // LD D,RRC (IY+d)
        case 0x0b: RRC(t,t); put_memory(mp, e=t); break;         // LD E,RRC (IX+d) // LD E,RRC (IY+d)
        case 0x0c: RRC(t,t); put_memory(mp, h=t); break;         // LD H,RRC (IX+d) // LD H,RRC (IY+d)
        case 0x0d: RRC(t,t); put_memory(mp, l=t); break;         // LD L,RRC (IX+d) // LD L,RRC (IY+d)
        case 0x0e: RRC(t,t); put_memory(mp, t); break;            // RRC (IX+d) // RRC (IY+d)
        case 0x0f: RRC(t,t); put_memory(mp, a=t); break;         // LD A,RRC (IX+d) // LD A,RRC (IY+d)
        case 0x10: RL(t,t); put_memory(mp, b=t); break;          // LD B,RL (IX+d) // LD B,RL (IY+d)
        case 0x11: RL(t,t); put_memory(mp, c=t); break;          // LD C,RL (IX+d) // LD C,RL (IY+d)
        case 0x12: RL(t,t); put_memory(mp, d=t); break;          // LD D,RL (IX+d) // LD D,RL (IY+d)
        case 0x13: RL(t,t); put_memory(mp, e=t); break;          // LD E,RL (IX+d) // LD E,RL (IY+d)
        case 0x14: RL(t,t); put_memory(mp, h=t); break;          // LD H,RL (IX+d) // LD H,RL (IY+d)
        case 0x15: RL(t,t); put_memory(mp, l=t); break;          // LD L,RL (IX+d) // LD L,RL (IY+d)
        case 0x16: RL(t,t); put_memory(mp, t); break;             // RL (IX+d) // RL (IY+d)
        case 0x17: RL(t,t); put_memory(mp, a=t); break;          // LD A,RL (IX+d) // LD A,RL (IY+d)
        case 0x18: RR(t,t); put_memory(mp, b=t); break;          // LD B,RR (IX+d) // LD B,RR (IY+d)
        case 0x19: RR(t,t); put_memory(mp, c=t); break;          // LD C,RR (IX+d) // LD C,RR (IY+d)
        case 0x1a: RR(t,t); put_memory(mp, d=t); break;          // LD D,RR (IX+d) // LD D,RR (IY+d)
        case 0x1b: RR(t,t); put_memory(mp, e=t); break;          // LD E,RR (IX+d) // LD E,RR (IY+d)
        case 0x1c: RR(t,t); put_memory(mp, h=t); break;          // LD H,RR (IX+d) // LD H,RR (IY+d)
        case 0x1d: RR(t,t); put_memory(mp, l=t); break;          // LD L,RR (IX+d) // LD L,RR (IY+d)
        case 0x1e: RR(t,t); put_memory(mp, t); break;             // RR (IX+d) // RR (IY+d)
        case 0x1f: RR(t,t); put_memory(mp, a=t); break;          // LD A,RR (IX+d) // LD A,RR (IY+d)
        case 0x20: SLA(t,t); put_memory(mp, b=t); break;         // LD B,SLA (IX+d) // LD B,SLA (IY+d)
        case 0x21: SLA(t,t); put_memory(mp, c=t); break;         // LD C,SLA (IX+d) // LD C,SLA (IY+d)
        case 0x22: SLA(t,t); put_memory(mp, d=t); break;         // LD D,SLA (IX+d) // LD D,SLA (IY+d)
        case 0x23: SLA(t,t); put_memory(mp, e=t); break;         // LD E,SLA (IX+d) // LD E,SLA (IY+d)
        case 0x24: SLA(t,t); put_memory(mp, h=t); break;         // LD H,SLA (IX+d) // LD H,SLA (IY+d)
        case 0x25: SLA(t,t); put_memory(mp, l=t); break;         // LD L,SLA (IX+d) // LD L,SLA (IY+d)
        case 0x26: SLA(t,t); put_memory(mp, t); break;            // SLA (IX+d) // SLA (IY+d)
        case 0x27: SLA(t,t); put_memory(mp, a=t); break;         // LD A,SLA (IX+d) // LD A,SLA (IY+d)
        case 0x28: SRA(t,t); put_memory(mp, b=t); break;         // LD B,SRA (IX+d) // LD B,SRA (IY+d)
        case 0x29: SRA(t,t); put_memory(mp, c=t); break;         // LD C,SRA (IX+d) // LD C,SRA (IY+d)
        case 0x2a: SRA(t,t); put_memory(mp, d=t); break;         // LD D,SRA (IX+d) // LD D,SRA (IY+d)
        case 0x2b: SRA(t,t); put_memory(mp, e=t); break;         // LD E,SRA (IX+d) // LD E,SRA (IY+d)
        case 0x2c: SRA(t,t); put_memory(mp, h=t); break;         // LD H,SRA (IX+d) // LD H,SRA (IY+d)
        case 0x2d: SRA(t,t); put_memory(mp, l=t); break;         // LD L,SRA (IX+d) // LD L,SRA (IY+d)
        case 0x2e: SRA(t,t); put_memory(mp, t); break;            // SRA (IX+d) // SRA (IY+d)
        case 0x2f: SRA(t,t); put_memory(mp, a=t); break;         // LD A,SRA (IX+d) // LD A,SRA (IY+d)
        case 0x30: SLL(t); put_memory(mp, b=t); break;         // LD B,SLL (IX+d) // LD B,SLL (IY+d)
        case 0x31: SLL(t); put_memory(mp, c=t); break;         // LD C,SLL (IX+d) // LD C,SLL (IY+d)
        case 0x32: SLL(t); put_memory(mp, d=t); break;         // LD D,SLL (IX+d) // LD D,SLL (IY+d)
        case 0x33: SLL(t); put_memory(mp, e=t); break;         // LD E,SLL (IX+d) // LD E,SLL (IY+d)
        case 0x34: SLL(t); put_memory(mp, h=t); break;         // LD H,SLL (IX+d) // LD H,SLL (IY+d)
        case 0x35: SLL(t); put_memory(mp, l=t); break;         // LD L,SLL (IX+d) // LD L,SLL (IY+d)
        case 0x36: SLL(t); put_memory(mp, t); break;            // SLL (IX+d) // SLL (IY+d)
        case 0x37: SLL(t); put_memory(mp, a=t); break;         // LD A,SLL (IX+d) // LD A,SLL (IY+d)
        case 0x38: SRL(t,t); put_memory(mp, b=t); break;         // LD B,SRL (IX+d) // LD B,SRL (IY+d)
        case 0x39: SRL(t,t); put_memory(mp, c=t); break;         // LD C,SRL (IX+d) // LD C,SRL (IY+d)
        case 0x3a: SRL(t,t); put_memory(mp, d=t); break;         // LD D,SRL (IX+d) // LD D,SRL (IY+d)
        case 0x3b: SRL(t,t); put_memory(mp, e=t); break;         // LD E,SRL (IX+d) // LD E,SRL (IY+d)
        case 0x3c: SRL(t,t); put_memory(mp, h=t); break;         // LD H,SRL (IX+d) // LD H,SRL (IY+d)
        case 0x3d: SRL(t,t); put_memory(mp, l=t); break;         // LD L,SRL (IX+d) // LD L,SRL (IY+d)
        case 0x3e: SRL(t,t); put_memory(mp, t); break;            // SRL (IX+d) // SRL (IY+d)
        case 0x3f: SRL(t,t); put_memory(mp, a=t); break;         // LD A,SRL (IX+d) // LD A,SRL (IY+d)
        case 0x40: case 0x41: case 0x42: case 0x43:      // BIT 0,(IX+d) // BIT 0,(IY+d)
        case 0x44: case 0x45: case 0x46: case 0x47:
                    BITI(1); break;
        case 0x48: case 0x49: case 0x4a: case 0x4b:      // BIT 1,(IX+d) // BIT 1,(IY+d)
        case 0x4c: case 0x4d: case 0x4e: case 0x4f:
                    BITI(2); break;
        case 0x50: case 0x51: case 0x52: case 0x53:      // BIT 2,(IX+d) // BIT 2,(IY+d)
        case 0x54: case 0x55: case 0x56: case 0x57:
                    BITI(4); break;
        case 0x58: case 0x59: case 0x5a: case 0x5b:      // BIT 3,(IX+d) // BIT 3,(IY+d)
        case 0x5c: case 0x5d: case 0x5e: case 0x5f:
                    BITI(8); break;
        case 0x60: case 0x61: case 0x62: case 0x63:      // BIT 4,(IX+d) // BIT 4,(IY+d)
        case 0x64: case 0x65: case 0x66: case 0x67:
                    BITI(16); break;
        case 0x68: case 0x69: case 0x6a: case 0x6b:      // BIT 5,(IX+d) // BIT 5,(IY+d)
        case 0x6c: case 0x6d: case 0x6e: case 0x6f:
                    BITI(32); break;
        case 0x70: case 0x71: case 0x72: case 0x73:      // BIT 6,(IX+d) // BIT 6,(IY+d)
        case 0x74: case 0x75: case 0x76: case 0x77:
                    BITI(64); break;
        case 0x78: case 0x79: case 0x7a: case 0x7b:      // BIT 7,(IX+d) // BIT 7,(IY+d)
        case 0x7c: case 0x7d: case 0x7e: case 0x7f:
                    BITI(128); break;
        case 0x80: RES(254, t); put_memory(mp, b=t); break;    // LD B,RES 0,(IX+d) // LD B,RES 0,(IY+d)
        case 0x81: RES(254, t); put_memory(mp, c=t); break;    // LD C,RES 0,(IX+d) // LD C,RES 0,(IY+d)
        case 0x82: RES(254, t); put_memory(mp, d=t); break;    // LD D,RES 0,(IX+d) // LD D,RES 0,(IY+d)
        case 0x83: RES(254, t); put_memory(mp, e=t); break;    // LD E,RES 0,(IX+d) // LD E,RES 0,(IY+d)
        case 0x84: RES(254, t); put_memory(mp, h=t); break;    // LD H,RES 0,(IX+d) // LD H,RES 0,(IY+d)
        case 0x85: RES(254, t); put_memory(mp, l=t); break;    // LD L,RES 0,(IX+d) // LD L,RES 0,(IY+d)
        case 0x86: RES(254, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 0,(IX+d) // RES 0,(IY+d)
        case 0x87: RES(254, t); put_memory(mp, a=t); break;    // LD A,RES 0,(IX+d) // LD A,RES 0,(IY+d)
        case 0x88: RES(253, t); put_memory(mp, b=t); break;    // LD B,RES 1,(IX+d) // LD B,RES 1,(IY+d)
        case 0x89: RES(253, t); put_memory(mp, c=t); break;    // LD C,RES 1,(IX+d) // LD C,RES 1,(IY+d)
        case 0x8a: RES(253, t); put_memory(mp, d=t); break;    // LD D,RES 1,(IX+d) // LD D,RES 1,(IY+d)
        case 0x8b: RES(253, t); put_memory(mp, e=t); break;    // LD E,RES 1,(IX+d) // LD E,RES 1,(IY+d)
        case 0x8c: RES(253, t); put_memory(mp, h=t); break;    // LD H,RES 1,(IX+d) // LD H,RES 1,(IY+d)
        case 0x8d: RES(253, t); put_memory(mp, l=t); break;    // LD L,RES 1,(IX+d) // LD L,RES 1,(IY+d)
        case 0x8e: RES(253, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 1,(IX+d) // RES 1,(IY+d)
        case 0x8f: RES(253, t); put_memory(mp, a=t); break;    // LD A,RES 1,(IX+d) // LD A,RES 1,(IY+d)
        case 0x90: RES(251, t); put_memory(mp, b=t); break;    // LD B,RES 2,(IX+d) // LD B,RES 2,(IY+d)
        case 0x91: RES(251, t); put_memory(mp, c=t); break;    // LD C,RES 2,(IX+d) // LD C,RES 2,(IY+d)
        case 0x92: RES(251, t); put_memory(mp, d=t); break;    // LD D,RES 2,(IX+d) // LD D,RES 2,(IY+d)
        case 0x93: RES(251, t); put_memory(mp, e=t); break;    // LD E,RES 2,(IX+d) // LD E,RES 2,(IY+d)
        case 0x94: RES(251, t); put_memory(mp, h=t); break;    // LD H,RES 2,(IX+d) // LD H,RES 2,(IY+d)
        case 0x95: RES(251, t); put_memory(mp, l=t); break;    // LD L,RES 2,(IX+d) // LD L,RES 2,(IY+d)
        case 0x96: RES(251, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 2,(IX+d) // RES 2,(IY+d)
        case 0x97: RES(251, t); put_memory(mp, a=t); break;    // LD A,RES 2,(IX+d) // LD A,RES 2,(IY+d)
        case 0x98: RES(247, t); put_memory(mp, b=t); break;    // LD B,RES 3,(IX+d) // LD B,RES 3,(IY+d)
        case 0x99: RES(247, t); put_memory(mp, c=t); break;    // LD C,RES 3,(IX+d) // LD C,RES 3,(IY+d)
        case 0x9a: RES(247, t); put_memory(mp, d=t); break;    // LD D,RES 3,(IX+d) // LD D,RES 3,(IY+d)
        case 0x9b: RES(247, t); put_memory(mp, e=t); break;    // LD E,RES 3,(IX+d) // LD E,RES 3,(IY+d)
        case 0x9c: RES(247, t); put_memory(mp, h=t); break;    // LD H,RES 3,(IX+d) // LD H,RES 3,(IY+d)
        case 0x9d: RES(247, t); put_memory(mp, l=t); break;    // LD L,RES 3,(IX+d) // LD L,RES 3,(IY+d)
        case 0x9e: RES(247, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 3,(IX+d) // RES 3,(IY+d)
        case 0x9f: RES(247, t); put_memory(mp, a=t); break;    // LD A,RES 3,(IX+d) // LD A,RES 3,(IY+d)
        case 0xa0: RES(239, t); put_memory(mp, b=t); break;    // LD B,RES 4,(IX+d) // LD B,RES 4,(IY+d)
        case 0xa1: RES(239, t); put_memory(mp, c=t); break;    // LD C,RES 4,(IX+d) // LD C,RES 4,(IY+d)
        case 0xa2: RES(239, t); put_memory(mp, d=t); break;    // LD D,RES 4,(IX+d) // LD D,RES 4,(IY+d)
        case 0xa3: RES(239, t); put_memory(mp, e=t); break;    // LD E,RES 4,(IX+d) // LD E,RES 4,(IY+d)
        case 0xa4: RES(239, t); put_memory(mp, h=t); break;    // LD H,RES 4,(IX+d) // LD H,RES 4,(IY+d)
        case 0xa5: RES(239, t); put_memory(mp, l=t); break;    // LD L,RES 4,(IX+d) // LD L,RES 4,(IY+d)
        case 0xa6: RES(239, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 4,(IX+d) // RES 4,(IY+d)
        case 0xa7: RES(239, t); put_memory(mp, a=t); break;    // LD A,RES 4,(IX+d) // LD A,RES 4,(IY+d)
        case 0xa8: RES(223, t); put_memory(mp, b=t); break;    // LD B,RES 5,(IX+d) // LD B,RES 5,(IY+d)
        case 0xa9: RES(223, t); put_memory(mp, c=t); break;    // LD C,RES 5,(IX+d) // LD C,RES 5,(IY+d)
        case 0xaa: RES(223, t); put_memory(mp, d=t); break;    // LD D,RES 5,(IX+d) // LD D,RES 5,(IY+d)
        case 0xab: RES(223, t); put_memory(mp, e=t); break;    // LD E,RES 5,(IX+d) // LD E,RES 5,(IY+d)
        case 0xac: RES(223, t); put_memory(mp, h=t); break;    // LD H,RES 5,(IX+d) // LD H,RES 5,(IY+d)
        case 0xad: RES(223, t); put_memory(mp, l=t); break;    // LD L,RES 5,(IX+d) // LD L,RES 5,(IY+d)
        case 0xae: RES(223, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 5,(IX+d) // RES 5,(IY+d)
        case 0xaf: RES(223, t); put_memory(mp, a=t); break;    // LD A,RES 5,(IX+d) // LD A,RES 5,(IY+d)
        case 0xb0: RES(191, t); put_memory(mp, b=t); break;    // LD B,RES 6,(IX+d) // LD B,RES 6,(IY+d)
        case 0xb1: RES(191, t); put_memory(mp, c=t); break;    // LD C,RES 6,(IX+d) // LD C,RES 6,(IY+d)
        case 0xb2: RES(191, t); put_memory(mp, d=t); break;    // LD D,RES 6,(IX+d) // LD D,RES 6,(IY+d)
        case 0xb3: RES(191, t); put_memory(mp, e=t); break;    // LD E,RES 6,(IX+d) // LD E,RES 6,(IY+d)
        case 0xb4: RES(191, t); put_memory(mp, h=t); break;    // LD H,RES 6,(IX+d) // LD H,RES 6,(IY+d)
        case 0xb5: RES(191, t); put_memory(mp, l=t); break;    // LD L,RES 6,(IX+d) // LD L,RES 6,(IY+d)
        case 0xb6: RES(191, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 6,(IX+d) // RES 6,(IY+d)
        case 0xb7: RES(191, t); put_memory(mp, a=t); break;    // LD A,RES 6,(IX+d) // LD A,RES 6,(IY+d)
        case 0xb8: RES(127, t); put_memory(mp, b=t); break;    // LD B,RES 7,(IX+d) // LD B,RES 7,(IY+d)
        case 0xb9: RES(127, t); put_memory(mp, c=t); break;    // LD C,RES 7,(IX+d) // LD C,RES 7,(IY+d)
        case 0xba: RES(127, t); put_memory(mp, d=t); break;    // LD D,RES 7,(IX+d) // LD D,RES 7,(IY+d)
        case 0xbb: RES(127, t); put_memory(mp, e=t); break;    // LD E,RES 7,(IX+d) // LD E,RES 7,(IY+d)
        case 0xbc: RES(127, t); put_memory(mp, h=t); break;    // LD H,RES 7,(IX+d) // LD H,RES 7,(IY+d)
        case 0xbd: RES(127, t); put_memory(mp, l=t); break;    // LD L,RES 7,(IX+d) // LD L,RES 7,(IY+d)
        case 0xbe: RES(127, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // RES 7,(IX+d) // RES 7,(IY+d)
        case 0xbf: RES(127, t); put_memory(mp, a=t); break;    // LD A,RES 7,(IX+d) // LD A,RES 7,(IY+d)
        case 0xc0: SET(1, t); put_memory(mp, b=t); break;      // LD B,SET 0,(IX+d) // LD B,SET 0,(IY+d)
        case 0xc1: SET(1, t); put_memory(mp, c=t); break;      // LD C,SET 0,(IX+d) // LD C,SET 0,(IY+d)
        case 0xc2: SET(1, t); put_memory(mp, d=t); break;      // LD D,SET 0,(IX+d) // LD D,SET 0,(IY+d)
        case 0xc3: SET(1, t); put_memory(mp, e=t); break;      // LD E,SET 0,(IX+d) // LD E,SET 0,(IY+d)
        case 0xc4: SET(1, t); put_memory(mp, h=t); break;      // LD H,SET 0,(IX+d) // LD H,SET 0,(IY+d)
        case 0xc5: SET(1, t); put_memory(mp, l=t); break;      // LD L,SET 0,(IX+d) // LD L,SET 0,(IY+d)
        case 0xc6: SET(1, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;         // SET 0,(IX+d) // SET 0,(IY+d)
        case 0xc7: SET(1, t); put_memory(mp, a=t); break;      // LD A,SET 0,(IX+d) // LD A,SET 0,(IY+d)
        case 0xc8: SET(2, t); put_memory(mp, b=t); break;      // LD B,SET 1,(IX+d) // LD B,SET 1,(IY+d)
        case 0xc9: SET(2, t); put_memory(mp, c=t); break;      // LD C,SET 1,(IX+d) // LD C,SET 1,(IY+d)
        case 0xca: SET(2, t); put_memory(mp, d=t); break;      // LD D,SET 1,(IX+d) // LD D,SET 1,(IY+d)
        case 0xcb: SET(2, t); put_memory(mp, e=t); break;      // LD E,SET 1,(IX+d) // LD E,SET 1,(IY+d)
        case 0xcc: SET(2, t); put_memory(mp, h=t); break;      // LD H,SET 1,(IX+d) // LD H,SET 1,(IY+d)
        case 0xcd: SET(2, t); put_memory(mp, l=t); break;      // LD L,SET 1,(IX+d) // LD L,SET 1,(IY+d)
        case 0xce: SET(2, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;         // SET 1,(IX+d) // SET 1,(IY+d)
        case 0xcf: SET(2, t); put_memory(mp, a=t); break;      // LD A,SET 1,(IX+d) // LD A,SET 1,(IY+d)
        case 0xd0: SET(4, t); put_memory(mp, b=t); break;      // LD B,SET 2,(IX+d) // LD B,SET 2,(IY+d)
        case 0xd1: SET(4, t); put_memory(mp, c=t); break;      // LD C,SET 2,(IX+d) // LD C,SET 2,(IY+d)
        case 0xd2: SET(4, t); put_memory(mp, d=t); break;      // LD D,SET 2,(IX+d) // LD D,SET 2,(IY+d)
        case 0xd3: SET(4, t); put_memory(mp, e=t); break;      // LD E,SET 2,(IX+d) // LD E,SET 2,(IY+d)
        case 0xd4: SET(4, t); put_memory(mp, h=t); break;      // LD H,SET 2,(IX+d) // LD H,SET 2,(IY+d)
        case 0xd5: SET(4, t); put_memory(mp, l=t); break;      // LD L,SET 2,(IX+d) // LD L,SET 2,(IY+d)
        case 0xd6: SET(4, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;         // SET 2,(IX+d) // SET 2,(IY+d)
        case 0xd7: SET(4, t); put_memory(mp, a=t); break;      // LD A,SET 2,(IX+d) // LD A,SET 2,(IY+d)
        case 0xd8: SET(8, t); put_memory(mp, b=t); break;      // LD B,SET 3,(IX+d) // LD B,SET 3,(IY+d)
        case 0xd9: SET(8, t); put_memory(mp, c=t); break;      // LD C,SET 3,(IX+d) // LD C,SET 3,(IY+d)
        case 0xda: SET(8, t); put_memory(mp, d=t); break;      // LD D,SET 3,(IX+d) // LD D,SET 3,(IY+d)
        case 0xdb: SET(8, t); put_memory(mp, e=t); break;      // LD E,SET 3,(IX+d) // LD E,SET 3,(IY+d)
        case 0xdc: SET(8, t); put_memory(mp, h=t); break;      // LD H,SET 3,(IX+d) // LD H,SET 3,(IY+d)
        case 0xdd: SET(8, t); put_memory(mp, l=t); break;      // LD L,SET 3,(IX+d) // LD L,SET 3,(IY+d)
        case 0xde: SET(8, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;         // SET 3,(IX+d) // SET 3,(IY+d)
        case 0xdf: SET(8, t); put_memory(mp, a=t); break;      // LD A,SET 3,(IX+d) // LD A,SET 3,(IY+d)
        case 0xe0: SET(16, t); put_memory(mp, b=t); break;     // LD B,SET 4,(IX+d) // LD B,SET 4,(IY+d)
        case 0xe1: SET(16, t); put_memory(mp, c=t); break;     // LD C,SET 4,(IX+d) // LD C,SET 4,(IY+d)
        case 0xe2: SET(16, t); put_memory(mp, d=t); break;     // LD D,SET 4,(IX+d) // LD D,SET 4,(IY+d)
        case 0xe3: SET(16, t); put_memory(mp, e=t); break;     // LD E,SET 4,(IX+d) // LD E,SET 4,(IY+d)
        case 0xe4: SET(16, t); put_memory(mp, h=t); break;     // LD H,SET 4,(IX+d) // LD H,SET 4,(IY+d)
        case 0xe5: SET(16, t); put_memory(mp, l=t); break;     // LD L,SET 4,(IX+d) // LD L,SET 4,(IY+d)
        case 0xe6: SET(16, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;        // SET 4,(IX+d) // SET 4,(IY+d)
        case 0xe7: SET(16, t); put_memory(mp, a=t); break;     // LD A,SET 4,(IX+d) // LD A,SET 4,(IY+d)
        case 0xe8: SET(32, t); put_memory(mp, b=t); break;     // LD B,SET 5,(IX+d) // LD B,SET 5,(IY+d)
        case 0xe9: SET(32, t); put_memory(mp, c=t); break;     // LD C,SET 5,(IX+d) // LD C,SET 5,(IY+d)
        case 0xea: SET(32, t); put_memory(mp, d=t); break;     // LD D,SET 5,(IX+d) // LD D,SET 5,(IY+d)
        case 0xeb: SET(32, t); put_memory(mp, e=t); break;     // LD E,SET 5,(IX+d) // LD E,SET 5,(IY+d)
        case 0xec: SET(32, t); put_memory(mp, h=t); break;     // LD H,SET 5,(IX+d) // LD H,SET 5,(IY+d)
        case 0xed: SET(32, t); put_memory(mp, l=t); break;     // LD L,SET 5,(IX+d) // LD L,SET 5,(IY+d)
        case 0xee: SET(32, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;        // SET 5,(IX+d) // SET 5,(IY+d)
        case 0xef: SET(32, t); put_memory(mp, a=t); break;     // LD A,SET 5,(IX+d) // LD A,SET 5,(IY+d)
        case 0xf0: SET(64, t); put_memory(mp, b=t); break;     // LD B,SET 6,(IX+d) // LD B,SET 6,(IY+d)
        case 0xf1: SET(64, t); put_memory(mp, c=t); break;     // LD C,SET 6,(IX+d) // LD C,SET 6,(IY+d)
        case 0xf2: SET(64, t); put_memory(mp, d=t); break;     // LD D,SET 6,(IX+d) // LD D,SET 6,(IY+d)
        case 0xf3: SET(64, t); put_memory(mp, e=t); break;     // LD E,SET 6,(IX+d) // LD E,SET 6,(IY+d)
        case 0xf4: SET(64, t); put_memory(mp, h=t); break;     // LD H,SET 6,(IX+d) // LD H,SET 6,(IY+d)
        case 0xf5: SET(64, t); put_memory(mp, l=t); break;     // LD L,SET 6,(IX+d) // LD L,SET 6,(IY+d)
        case 0xf6: SET(64, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;        // SET 6,(IX+d) // SET 6,(IY+d)
        case 0xf7: SET(64, t); put_memory(mp, a=t); break;     // LD A,SET 6,(IX+d) // LD A,SET 6,(IY+d)
        case 0xf8: SET(128, t); put_memory(mp, b=t); break;    // LD B,SET 7,(IX+d) // LD B,SET 7,(IY+d)
        case 0xf9: SET(128, t); put_memory(mp, c=t); break;    // LD C,SET 7,(IX+d) // LD C,SET 7,(IY+d)
        case 0xfa: SET(128, t); put_memory(mp, d=t); break;    // LD D,SET 7,(IX+d) // LD D,SET 7,(IY+d)
        case 0xfb: SET(128, t); put_memory(mp, e=t); break;    // LD E,SET 7,(IX+d) // LD E,SET 7,(IY+d)
        case 0xfc: SET(128, t); put_memory(mp, h=t); break;    // LD H,SET 7,(IX+d) // LD H,SET 7,(IY+d)
        case 0xfd: SET(128, t); put_memory(mp, l=t); break;    // LD L,SET 7,(IX+d) // LD L,SET 7,(IY+d)
        case 0xfe: SET(128, t); put_memory(mp, t); if ( israbbit() ) st -= 9; break;       // SET 7,(IX+d) // SET 7,(IY+d)
        case 0xff: SET(128, t); put_memory(mp, a=t); break;    // LD A,SET 7,(IX+d) // LD A,SET 7,(IY+d)
        }
    }
}
