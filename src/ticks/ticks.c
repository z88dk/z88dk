#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ticks.h"

#if defined(_WIN32) || defined(WIN32)
#define strcasecmp(a,b) stricmp(a,b)
#endif




// fr = zero, ff&256 = carry, ff&128 = s/p

// TODO: Setting P flag
#define BOOL(hi, lo, hia, loa, isalt) do {                \
          if ( isalt ) {                  \
            loa = fr_ = hi|lo ? 1 : 0; hia = 0; ff_ &= ~256; \
          } else {                       \
            lo = fr = hi|lo ? 1 : 0; hi = 0; ff &= ~256; \
          }                              \
        } while (0)
          
#define LDRIM(r)                \
          st += isez80() ? 2 : israbbit() ? 2 : isz180() ? 6 : 7, \
          r= get_memory(pc++)

#define LDRRIM(a, b)            \
          st += isez80() ? 3 : israbbit() ? 6 : isz180() ? 9 : 10, \
          b= get_memory(pc++),         \
          a= get_memory(pc++)

#define LDRP(a, b, r)           \
          st += isez80() ? 2 : israbbit() ? (&a == &h) ? 2 : 6 : 7, \
          r= get_memory(mp= b|a<<8),   \
          ++mp

#define LDRPI(a, b, r)          \
          st += isez80() ? 3 : israbbit() ? 7 : isz180() ? 11 : 15, \
          r= get_memory(((get_memory(pc++)^128)-128+(b|a<<8))&65535)

#define LEA(r1, r2, s1, s2, t) do { \
    uint16_t offs = ((get_memory(pc++)^128)-128+(s1|s2<<8))&65535; \
    r2 = get_memory(offs); \
    r1 = get_memory(offs+1); \
    st += t; \
} while (0)

#define LDPR(a, b, r)           \
          st += isez80() ? 2 : israbbit() ? (&a == &h) ? 6 : 7 : 7, \
          put_memory(b|a<<8,r),       \
          mp= b+1&255 | a<<8

#define LDPRI(a, b, r)          \
          st += isez80() ? 3 : israbbit() ? 11 : 15, \
          put_memory(((get_memory(pc++)^128)-128+(b|a<<8))&65535,r)

// ld r,r'
#define LDRR(dr, sr, dr_, n) do {          \
            st+= n;               \
            if ( altd ) dr_ = sr; \
            else dr = sr; \
          } while(0)
            
#define LDPNNRR(a, b, n)        \
          st+= n,               \
          t= get_memory(pc++),         \
          put_memory(t|= get_memory(pc++)<<8, b), \
          put_memory(mp= t+1,a)

#define LDPIN(a, b)             \
          st+= 15,              \
          t= get_memory(pc++),         \
          put_memory(((t^128)-128+(b|a<<8))&65535, get_memory(pc++))

#define INCW(a, b)              \
          st +=isez80() ? 1 : israbbit() ? 2 : 6, \
          ++b || a++

#define DECW(a, b)              \
          st += isez80() ? 1 : israbbit() ? 2 : 6, \
          b-- || a--

// TODO: Should affect alternate flags if altd
#define INC(r)                  \
          st +=isez80() ? 1 : israbbit() ? 2 : 4, \
          ff= ff&256            \
            | (fr= r= (fa= r)+(fb= 1))

// TODO: Should affect alternate flags if altd
#define DEC(r)                  \
          st +=isez80() ? 1 : israbbit() ? 2 : 4, \
          ff= ff&256            \
            | (fr= r= (fa= r)+(fb= -1))

// TODO: Should affect alternate flags if altd
#define INCPI(a, b)             \
          st +=isez80() ? 5 : israbbit() ? 12 : 19, \
          fa= get_memory(t= (get_memory(pc++)^128)-128+(b|a<<8)), \
          ff= ff&256            \
            | (fr= put_memory(t,fa+(fb=1)))

// TODO: Should affect alternate flags if altd
#define DECPI(a, b)             \
          st +=isez80() ? 5 : israbbit() ? 12 : 19, \
          fa= get_memory(t= (get_memory(pc++)^128)-128+(b|a<<8)), \
          ff= ff&256            \
            | (fr= put_memory(t,fa+(fb=-1)))

#define ADDRRRR(a, b, c, d)     \
          st+= isez80() ? 1 :israbbit() ? 2 :11,              \
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
            st+= isez80() ? 3 : 12,            \
            pc+= (get_memory(pc)^128)-127; \
          else                  \
            st+= isez80() ? 2 : 7,             \
            pc++

#define JRC(c)                  \
          if(c)                 \
            st+= isez80() ? 2 : 7,             \
            pc++;               \
          else                  \
            st+= isez80() ? 3 : 12,            \
            pc+= (get_memory(pc)^128)-127

#define LDRRPNN(a, b, n)        \
          st+= n,               \
          t= get_memory(pc++),         \
          b= get_memory(t|= get_memory(pc++)<<8), \
          a= get_memory(mp= t+1)

#define ADDISP(a, b)            \
          st+= isez80() ? 1 : 11,              \
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
      } while (0)

#define ADC(b, n)  do {         \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= b)+(ff_>>8&1)); \
          fr= a= (ff= (fa= a)+(fb= b)+(ff>>8&1)); \
        } while (0)

#define SUB(b, n)  do {         \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= ~b)+1); \
          else fr= a= (ff= (fa= a)+(fb= ~b)+1); \
        } while (0)

#define SBC(b, n) do {             \
          st+= n;               \
          if ( altd ) fr_= a_= (ff_= (fa_= a)+(fb_= ~b)+(ff_>>8&1^1)); \
          else fr= a= (ff= (fa= a)+(fb= ~b)+(ff>>8&1^1)); \
        } while (0)

#define AND(b, n) do {          \
          st+= n;               \
          if ( altd ) { fa_= ~(a_= ff_= fr_= a&b); fb_= 0;} \
          else { fa= ~(a= ff= fr= a&b);  fb= 0; } \
      } while (0)

// TODO: Flags not right
#define AND2(r1, r2, ra) do {            \
          if ( altd ) {                  \
            fa_= ~(ra= ff_= fr_= r1&r2); \
            fb_= 0;                      \
          } else {                       \
            fa= ~(r1= ff= fr= r1&r2);    \
            fb= 0;                       \
          }                              \
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
        } while (0)

// TODO: Flags not right
#define OR2(r1, r2)             \
          fa= 256               \
            | (ff= fr= r1|= r2),  \
          fb= 0

#define CP(b, n)                \
          st+= n,               \
          fr= (fa= a)-b,        \
          fb= ~b,               \
          ff= fr  & -41         \
            | b   &  40,        \
          fr&= 255

#define RET(n)                  \
          st+= n,               \
          mp= get_memory(sp++),        \
          pc= mp|= get_memory(sp++)<<8

#define RETC(c)                 \
          if(c)                 \
            st+= isez80() ? 2 : israbbit() ? 2 : 5;             \
          else                  \
            st+= isez80() ? 6 :  israbbit() ? 8 : 11,            \
            mp= get_memory(sp++),      \
            pc= mp|= get_memory(sp++)<<8

#define RETCI(c)                \
          if(c)                 \
            st+= isez80() ? 6 :israbbit() ? 8 : 11,            \
            mp= get_memory(sp++),      \
            pc= mp|= get_memory(sp++)<<8; \
          else                  \
            st+= isez80() ? 2 : israbbit() ? 2 : 5

#define PUSH(a, b)              \
          st+= isez80() ? 3 :israbbit() ? 10 : 11,              \
          put_memory(--sp,a),   \
          put_memory(--sp,b)

#define POP(a, b)               \
          st+= isez80() ? 3 : israbbit() ? 7 : isz180() ? 9 : 10,              \
          b= get_memory(sp++),  \
          a= get_memory(sp++)

#define JPC(c)                  \
          st+= isez80() ? 3 : israbbit() ? 7 : isz180() ? 6 : 10;              \
          if(c)                 \
            pc+= 2;             \
          else                  \
            st += isez80() ? 1 : isz180() ? 3 : 0,  \
            pc= get_memory(pc) | get_memory(pc+1)<<8

#define JPCI(c)                 \
          st+= isez80() ? 3 : israbbit() ? 7 : isz180() ? 6 : 10;              \
          if(c)                 \
            st += isez80() ? 1 : isz180() ? 3 : 0,  \
            pc= get_memory(pc) | get_memory(pc+1)<<8; \
          else                  \
            pc+= 2

#define CALLC(c)                \
          if(c)                 \
            st+= isez80() ? 3 : isz180() ? 6 : 10,            \
            pc+= 2;             \
          else                  \
            st+= isez80() ? 6 : isz180() ? 16 : 17,            \
            t= pc+2,            \
            mp= pc= get_memory(pc) | get_memory(pc+1)<<8, \
            put_memory(--sp,t>>8),    \
            put_memory(--sp,t)

#define CALLCI(c)               \
          if(c)                 \
            st+= isez80() ? 6 : isz180() ? 16 : 17,            \
            t= pc+2,            \
            mp= pc= get_memory(pc) | get_memory(pc+1)<<8, \
            put_memory(--sp,t>>8),    \
            put_memory(--sp,t);    \
          else                  \
            st+= isez80() ? 3 : isz180() ? 6 : 10,            \
            pc+= 2

#define RST(n)                  \
          st+= isez80() ? 5 :israbbit() ? 8 : 11,              \
          put_memory(--sp,pc>>8),     \
          put_memory(--sp,pc),        \
          mp= pc= n

#define EXSPI(a, b)             \
          st+= isez80() ? 5 : israbbit() ? 13 : isz180() ? 16 : 19,              \
          t= get_memory(sp),    \
          put_memory(sp++,b),   \
          b= t,                 \
          t= get_memory(sp),    \
          put_memory(sp--,a),   \
          a= t,                 \
          mp= b | a<<8

#define RLC(r)                  \
          st+= isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff= r*257>>7,         \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define RRC(r)                  \
          st+= isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff=  r >> 1           \
              | ((r&1)+1 ^ 1)<<7, \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define RL(r)                   \
          st+= isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff= r << 1            \
            | ff  >> 8 & 1,     \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define RR(r)                   \
          st+=isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff= (r*513 | ff&256)>>1, \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define SLA(r)                  \
          st+=isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff= r<<1,             \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define SRA(r)                  \
          st+=isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff= (r*513+128^128)>>1, \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define SLL(r)                  \
          if ( cansll() )       \
            st+= 8,             \
            ff= r<<1 | 1,       \
            fa= 256             \
              | (fr= r= ff),    \
            fb= 0

#define SRL(r)                  \
          st+=isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8,               \
          ff= r*513 >> 1,       \
          fa= 256               \
            | (fr= r= ff),      \
          fb= 0

#define BIT(n, r)               \
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 6 : 8, \
          ff= ff  & -256        \
            | r   &   40        \
            | (fr= r & n),      \
          fa= ~fr,              \
          fb= 0

#define BITHL(n)                \
          st += isez80() ? 3 : israbbit() ? 7 : isz180() ? 9 : 12, \
          t = get_memory(l | h<<8),     \
          ff= ff    & -256      \
            | mp>>8 &   40      \
            | -41   & (t&= n),  \
          fa= ~(fr= t),         \
          fb= 0

// 11T has already been added + index flag
#define BITI(n) do {               \
          st += isez80() ? -7 :israbbit() ? -1 : isz180() ? 4 : 5; \
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
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8, \
          r&= n

#define RESHL(n)                \
          st += isez80() ? 3 : israbbit() ? 10 : isz180() ? 13 : 15, \
          t = l|h<<8, \
          put_memory(t, get_memory(t) & n) 
          
#define SET(n, r)               \
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 7 : 8, \
          r|= n

#define SETHL(n)                \
          st += isez80() ? 3 : israbbit() ? 10 : isz180() ? 13 : 15, \
          t = l|h<<8, \
          put_memory(t, get_memory(t) | n)
          
#define INR(r)                  \
          st+= 12,              \
          r= in(mp= b<<8 | c),  \
          ++mp,                 \
          ff= ff & -256         \
            | (fr= r),          \
          fa= r | 256,          \
          fb= 0

#define OUTR(r)                 \
          st+= 12,              \
          out(mp= c | b<<8, r), \
          ++mp

#define SBCHLRR(a, b)           \
          st += isez80() ? 2 : israbbit() ? 4 : isz180() ? 10 : 15, \
          v= l-b+((h-a)<<8)-(ff>>8&1),\
          mp= l+1+(h<<8),       \
          ff= v>>8,             \
          fa= h,                \
          fb= ~a,               \
          h= ff,                \
          l= v,                 \
          fr= h|l<<8

#define ADCHLRR(a, b)           \
          st += isez80() ? 2 :israbbit() ? 4 : isz180() ? 10 : 15, \
          v= l+b+(h+a<<8)+(ff>>8&1),\
          mp= l+1+(h<<8),       \
          ff= v>>8,             \
          fa= h,                \
          fb= a,                \
          h= ff,                \
          l= v,                 \
          fr= h|l<<8

#define TEST(v, ticks) do {  \
      uint8_t olda = a;        \
      AND(v, 0);\
      a = olda;                \
      st += ticks;             \
    } while (0)

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
      , a_= 0
      , b_= 0
      , c_= 0
      , d_= 0
      , e_= 0
      , h_= 0
      , l_= 0
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


char   cmd_arguments[255];
int    cmd_arguments_len = 0;

int    c_cpu = CPU_Z80;


static const uint8_t mirror_table[] = {
    0x0, 0x8, 0x4, 0xC,  /*  0-3  */
    0x2, 0xA, 0x6, 0xE,  /*  4-7  */
    0x1, 0x9, 0x5, 0xD,  /*  8-11 */
    0x3, 0xB, 0x7, 0xF   /* 12-15 */
};

long tapcycles(void){
  mues= 1;
  wavpos!=0x20000 && (ear^= 64);
  if( wavpos>0x1f000 )
    fseek( ft, wavpos-0x20000, SEEK_CUR ),
    wavlen-= wavpos,
    wavpos= 0,
    (void)fread(tapbuf, 1, 0x20000, ft);
  while( (tapbuf[++wavpos]^ear<<1)&0x80 && wavpos<0x20000 )
    mues+= 81;  // correct value must be 79.365, adjusted to simulate contention in Alkatraz
  if( wavlen<=wavpos )
    return 0;
  else
    return mues;
}

int in(int port){
  return port&1 ? 255 : ear;
}

void out(int port, int value){
  memory_handle_paging(port, value);
}

int f(void){
  return  ff & 168  // S, 5, 3: bits 7, 5, 3
        | ff >> 8 & 1 // C bit 0, so value 256
        | !fr << 6    // Z, bit 6
        | fb >> 8 & 2 // N (subtract flag) bit 1, value 512
        | (fr ^ fa ^ fb ^ fb >> 8) & 16 // H (half carry) bit 4
        | (fa & -256 
            ? 154020 >> ((fr ^ fr >> 4) & 15)
            : ((fr ^ fa) & (fr ^ fb)) >> 5) & 4; // P/V bit 2
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
}



int main (int argc, char **argv){
  int size= 0, start= 0, end= 0, intr= 0, tap= 0, alarmtime = 0, load_address = 0;
  char * output= NULL;
  char  *memory_model = "standard";
  FILE * fh;

  hook_init();
  debugger_init();

  tapbuf= (unsigned char *) malloc (0x20000);
  if( argc==1 )
    printf("Ticks v0.14c beta, a silent Z80 emulator by Antonio Villena, 10 Jan 2013\n\n"),
    printf("  ticks <input_file> [-pc X] [-start X] [-end X] [-counter X] [-output <file>]\n\n"),
    printf("  <input_file>   File between 1 and 65536 bytes with Z80 machine code\n"),
    printf("  -tape <file>   emulates ZX tape in port $FE from a .WAV file\n"),
    printf("  -trace         outputs register values and disassembly while executing\n"),
    printf("  -pc X          X in hexadecimal is the initial PC value\n"),
    printf("  -start X       X in hexadecimal is the PC condition to start the counter\n"),
    printf("  -end X         X in hexadecimal is the PC condition to exit\n"),
    printf("  -counter X     X in decimal is another condition to exit\n"),
    printf("  -int X         X in decimal are number of cycles for periodic interrupts\n"),
    printf("  -w X           Maximum amount of running time (400000000 cycles per unit)\n"),
    printf("  -d             Enable debugger\n"),
    printf("  -l X           Load file to address\n"),
    printf("  -b <model>     Memory model (zxn/zx)\n"),
    printf("  -mz80          Emulate a z80\n"),
    printf("  -mz180         Emulate a z180\n"),
    printf("  -mr2k          Emulate a Rabbit 2000\n"),
    printf("  -mz80n         Emulate a Spectrum Next z80n\n"),
    printf("  -mez80         Emulate an ez80 (z80 mode) \n"),
    printf("  -x <file>      Symbol file to read\n"),
    printf("  -ide0 <file>   Set file to be ide device 0\n"),
    printf("  -ide1 <file>   Set file to be ide device 1\n"),
    printf("  -output <file> dumps the RAM content to a 64K file\n\n"),
    printf("  Default values for -pc, -start and -end are 0000 if ommited. When the program "),
    printf("exits, it'll show the number of cycles between start and end trigger in decimal\n\n"),
    exit(0);
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
          pc= strtol(argv[1], NULL, 16);
          break;
        case 's':
          start= strtol(argv[1], NULL, 16);
          break;
        case 'e':
          end= strtol(argv[1], NULL, 16);
          break;
        case 'i':
          if ( strcmp(&argv[0][1], "ide0") == 0 ) {
            hook_io_set_ide_device(0, argv[1]);
          } else if ( strcmp(&argv[0][1], "ide1") == 0 ) {
            hook_io_set_ide_device(1, argv[1]);
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
          argv--;
          argc++;
          break;
        case 'x':
          read_symbol_file(argv[1]);
          break;
        case 'm':
          if ( strcmp(&argv[0][1],"mz80") == 0 ) {
            c_cpu = CPU_Z80;
          } else if ( strcmp(&argv[0][1],"mz180") == 0 ) {
            c_cpu = CPU_Z180;
          } else if ( strcmp(&argv[0][1],"mz80n") == 0 ) {
            c_cpu = CPU_Z80N;
            memory_model = "zxn";
          } else if ( strcmp(&argv[0][1],"mr2k") == 0 ) {
            c_cpu = CPU_R2K;
          } else if ( strcmp(&argv[0][1],"mez80") == 0 ) {
            c_cpu = CPU_EZ80;
          } else {
            printf("Unknown CPU: %s\n",&argv[0][1]);
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
              printf("\nTape file not found: %s\n", argv[1]),
              exit(-1);
            (void)fread(tapbuf, 1, 0x20000, ft);
            memcpy(&wavlen, tapbuf+4, 4);
            wavlen+= 8;
            if( *(int*) tapbuf != 0x46464952 )
              printf("\nInvalid WAV header\n"),
              exit(-1);
            if( *(int*)(tapbuf+16) != 16 )
              printf("\nInvalid subchunk size\n"),
              exit(-1);
            if( *(int*)(tapbuf+20) != 0x10001 )
              printf("\nInvalid number of channels or compression (only Mono and PCM allowed)\n"),
              exit(-1);
            if( *(int*)(tapbuf+24) != 44100 )
              printf("\nInvalid sample rate (only 44100Hz allowed)\n"),
              exit(-1);
            if( *(int*)(tapbuf+32) != 0x80001 )
              printf("\nInvalid align or bits per sample (only 8-bits samples allowed)\n"),
              exit(-1);
            if( *(int*)(tapbuf+40)+44 != wavlen )
              printf("\nInvalid header size\n"),
              exit(-1);
            wavpos= 44;
          }
          else if (strcmp(&argv[0][1], "trace") == 0) {
            debugger_active = 0;
            trace = 1;
            argv--;
            argc++;
          }
          else {
            printf("\nWrong Argument: %s\n", argv[0]);
            exit(-1);
          }
          break;
        case '-':
          while ( argc > 1 ) {
            // I think windows is now comformant with snprintf? Either way, we can't grow the arugment buffer...
            cmd_arguments_len += snprintf(cmd_arguments + cmd_arguments_len, sizeof(cmd_arguments) - cmd_arguments_len, "%s%s",cmd_arguments_len > 0 ? " " : "", argv[1]);
            argc--;
            argv++;
          }
          put_memory(65280,cmd_arguments_len % 256);
          memcpy(get_memory_addr(65281), cmd_arguments, cmd_arguments_len % 256);
          break;
        default:
          printf("\nWrong Argument: %s\n", argv[0]);
          exit(-1);
      }
    else{
      memory_init(memory_model);

      fh= fopen(argv[1], "rb");
      if( !fh )
        printf("\nFile not found: %s\n", argv[1]),
        exit(-1);
      fseek(fh, 0, SEEK_END);
      size= ftell(fh);
      rewind(fh);
      if( size>65536 && size!=65574 )
        printf("\nIncorrect length: %d\n", size),
        exit(-1);
      else if( !strcasecmp(strchr(argv[1], '.'), ".com" ) ){
        *get_memory_addr(5) = 0xED;
        *get_memory_addr(6) = 0xFE;
        *get_memory_addr(7) = 0xC9;
       pc = 256;
        // CP/M emulator
        (void)fread(get_memory_addr(256), 1, size, fh);

      } else if( !strcasecmp(strchr(argv[1], '.'), ".sna" ) && size==49179 ){
        FILE *fk= fopen("48.rom", "rb");
        if( !fk )
          printf("\nZX Spectrum ROM file not found: 48.rom\n"),
          exit(-1);
        (void)fread(get_memory_addr(0), 1, 16384, fk);
        fclose(fk);
        (void)fread(&i, 1, 1, fh);
        (void)fread(&l_, 1, 1, fh);
        (void)fread(&h_, 1, 1, fh);
        (void)fread(&e_, 1, 1, fh);
        (void)fread(&d_, 1, 1, fh);
        (void)fread(&c_, 1, 1, fh);
        (void)fread(&b_, 1, 1, fh);
        (void)fread(&w, 1, 1, fh);
        setf(w);
        ff_= ff;
        fr_= fr;
        fa_= fa;
        fb_= fb;
        (void)fread(&a_, 1, 1, fh);
        (void)fread(&l, 1, 1, fh);
        (void)fread(&h, 1, 1, fh);
        (void)fread(&e, 1, 1, fh);
        (void)fread(&d, 1, 1, fh);
        (void)fread(&c, 1, 1, fh);
        (void)fread(&b, 1, 1, fh);
        (void)fread(&yl, 1, 1, fh);
        (void)fread(&yh, 1, 1, fh);
        (void)fread(&xl, 1, 1, fh);
        (void)fread(&xh, 1, 1, fh);
        (void)fread(&iff, 1, 1, fh);
        iff>>= 2;
        (void)fread(&r, 1, 1, fh);
        r7= r;
        (void)fread(&w, 1, 1, fh);
        setf(w);
        (void)fread(&a, 1, 1, fh);
        (void)fread(&sp, 2, 1, fh);
        (void)fread(&im, 1, 1, fh);
        (void)fread(&w, 1, 1, fh);
        (void)fread(get_memory_addr(0x4000), 1, 0xc000, fh);
        RET(0);
      }
      else if( size==65574 )
        (void)fread(get_memory_addr(0), 1, 65536, fh),
        (void)fread(&w, 1, 1, fh),
        u= w,
        (void)fread(&a, 1, 1, fh),
        (void)fread(&c, 1, 1, fh),
        (void)fread(&b, 1, 1, fh),
        (void)fread(&l, 1, 1, fh),
        (void)fread(&h, 1, 1, fh),
        (void)fread(&pc, 2, 1, fh),
        (void)fread(&sp, 2, 1, fh),
        (void)fread(&i, 1, 1, fh),
        (void)fread(&r, 1, 1, fh),
        r7= r,
        (void)fread(&e, 1, 1, fh),
        (void)fread(&d, 1, 1, fh),
        (void)fread(&c_, 1, 1, fh),
        (void)fread(&b_, 1, 1, fh),
        (void)fread(&e_, 1, 1, fh),
        (void)fread(&d_, 1, 1, fh),
        (void)fread(&l_, 1, 1, fh),
        (void)fread(&h_, 1, 1, fh),
        (void)fread(&w, 1, 1, fh),
        setf(w),
        ff_= ff,
        fr_= fr,
        fa_= fa,
        fb_= fb,
        setf(u),
        (void)fread(&a_, 1, 1, fh),
        (void)fread(&yl, 1, 1, fh),
        (void)fread(&yh, 1, 1, fh),
        (void)fread(&xl, 1, 1, fh),
        (void)fread(&xh, 1, 1, fh),
        (void)fread(&iff, 1, 1, fh),
        (void)fread(&im, 1, 1, fh),
        (void)fread(&mp, 2, 1, fh);
      else {
        int l;
        for ( l = 0; l < size; l++ ) {
          *get_memory_addr(load_address+l) = fgetc(fh);
        }
      }
    }
    ++argv;
    --argc;
  }
  if( size==65574 ){
    (void)fread(&wavpos, 4, 1, fh);
    ear= wavpos<<6 | 191;
    wavpos>>= 1;
    if( wavpos && ft )
      fseek(ft, wavlen-wavpos, SEEK_SET),
      wavlen= wavpos,
      wavpos= 0,
      (void)fread(tapbuf, 1, 0x20000, ft);
    (void)fread(&sttap, 4, 1, fh);
    tap= sttap;
  }
  else
    sttap= tap= tapcycles();
  fclose(fh);
  if( !size )
    printf("File not specified or zero length\n");
  stint= intr;


  do{
    char buf[256];
    if ( ih ) debugger();
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
            pc= get_memory(t= 255 | i << 8);
            pc|= get_memory(++t) << 8;
            st+= 19;
        }
      }
    }
    if( tap && st>sttap )
      sttap= st+( tap= tapcycles() );
    r++;
    switch( get_memory(pc++) ){
      case 0x00: // NOP
        st+= israbbit() ? 2 : isz180() ? 3 : 4;
        ih=1;altd=0;ioi=0;ioe=0;break;
        break;
      case 0x40: // LD B,B
        if ( altd ) { b_ = b; st += 2; break; }
      case 0x49: // LD C,C
        if ( altd ) { c_ = c; st += 2; break; }
      case 0x52: // LD D,D
        if ( altd ) { d_ = d; st += 2; break; }
      case 0x5b: // LD E,E
        if ( altd ) { e_ = e; st += 2; break; }
      case 0x64: // LD H,H
        if ( altd ) { h_ = h; st += 2; break; }
      case 0x6d: // LD L,L
        if ( altd ) { l_ = l; st += 2; break; }
      case 0x7f: // LD A,A
        if ( altd ) { a_ = a; st += 2; break; }
        st+= israbbit() ? 2 : 4;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x76: // HALT
        if ( israbbit()) {
          altd = 1;
          st += 2;
        } else {
          st+= 4;
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
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 5;
            if ( iy == 0 ) {  // ld iy,(ix+d)
                yl = get_memory(t+(xl|xh<<8));
                yh = get_memory(t+(xl|xh<<8) + 1);
            } else {  // ld ix,(iy+d)
                xl = get_memory(t+(yl|yh<<8));
                xh = get_memory(t+(yl|yh<<8) + 1);
            }
            break;
        }
        st+= israbbit() ? 6 : 10;
        sp= get_memory(pc++);
        sp|= get_memory(pc++)<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x02: // LD (BC),A
        LDPR(b, c, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x12: // LD (DE),A
        LDPR(d, e, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0a: // LD A,(BC)
        if ( altd ) LDRP(b, c, a_);
        else LDRP(b, c, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1a: // LD A,(DE)
        if ( altd ) LDRP(d, e, a_);
        else LDRP(d, e, a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x22: // LD (nn),HL // LD (nn),IX // LD (nn),IY
        if( ih )
          LDPNNRR(h, l,isez80() ? 5 : israbbit() ? 13 : 16);
        else if( iy )
          LDPNNRR(yh, yl,isez80() ? 5 : israbbit() ? 13 : 16);
        else
          LDPNNRR(xh, xl, isez80() ? 5 :israbbit() ? 13 : 16);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x32: // LD (nn),A
        st+= isez80() ? 4 : israbbit() ? 10 : 13;
        t= get_memory(pc++);
        put_memory(t|= get_memory(pc++)<<8,a);
        mp= t+1 & 255
          | a<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2a: // LD HL,(nn) // LD IX,(nn) // LD IY,(nn)
        if( ih ) {
          if ( altd ) LDRRPNN(h_, l_, 11);
          else LDRRPNN(h, l, isez80() ? 5 : israbbit() ? 11 : isz180() ? 15 : 16);
        } else if( iy )
          LDRRPNN(yh, yl, isez80() ? 65: israbbit() ? 13 : isz180() ? 15 : 16);
        else
          LDRRPNN(xh, xl, isez80() ? 5 : israbbit() ? 13 : isz180() ? 15 : 16);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3a: // LD A,(nn)
        st+= isez80() ? 4 : israbbit() ? 9 : 13;
        mp= get_memory(pc++);
        if ( altd ) a_ = get_memory(mp|= get_memory(pc++)<<8);
        else a= get_memory(mp|= get_memory(pc++)<<8);
        ++mp;
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
        st+= isez80() ? 1 : 6;
        sp++;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0b: // DEC BC
        if ( altd ) DECW(b_,c_);
        else DECW(b, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1b: // DEC DE
        if ( altd ) DECW(d_,e_);
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
        st+= isez80() ? 1 : 6;
        sp--;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x04: // INC B
        if ( altd ) INC(b_);
        else INC(b);
        ih=1;altd=0;ioi=0;ioe=0;break;
        break;
      case 0x0c: // INC C
        if ( altd ) INC(c_);
        else INC(c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x14: // INC D
        if ( altd ) INC(d_);
        else INC(d);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1c: // INC E
        if ( altd ) INC(e_);
        else INC(e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x24: // INC H // INC IXh // INC IYh
        if( ih ) {
          if ( altd ) INC(h_);
          else INC(h);
        } else if( iy && canixh() )
          INC(yh);
        else if ( canixh() )
          INC(xh);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2c: // INC L // INC IXl // INC IYl
        if( ih ) {
          if ( altd ) INC(l_);
          else INC(l);
        } else if( iy && canixh() )
          INC(yl);
        else if ( canixh() )
          INC(xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x34: // INC (HL) // INC (IX+d) // INC (IY+d)
        if( ih ) 
          st+=isez80() ? 4 : israbbit() ? 8 : 11,
          fa= get_memory(t= l | h<<8),
          ff= ff&256
            | (fr= put_memory(t,fa+(fb=+1)));
        else if( iy )
          INCPI(yh, yl);
        else
          INCPI(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3c: // INC A
        INC(a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x05: // DEC B
        DEC(b);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0d: // DEC C
        DEC(c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x15: // DEC D
        DEC(d);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1d: // DEC E
        DEC(e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x25: // DEC H // DEC IXh // DEC IYh
        if( ih )
          DEC(h);
        else if( iy )
          DEC(yh);
        else
          DEC(xh);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2d: // DEC L // DEC IXl // DEC IYl
        if( ih )
          DEC(l);
        else if( iy )
          DEC(yl);
        else
          DEC(xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x35: // DEC (HL) // DEC (IX+d) // DEC (IY+d)
        if( ih )
          st+=isez80() ? 4 : israbbit() ? 8 : 11,
          fa= get_memory(t= l | h<<8),
          ff= ff&256
            | (fr= put_memory(t,fa+(fb=-1)));
        else if( iy )
          DECPI(yh, yl);
        else
          DECPI(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3d: // DEC A
        if ( altd ) DEC(a_);
        else DEC(a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x06: // LD B,n
        if ( altd ) LDRIM(b_);
        else LDRIM(b);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0e: // LD C,n
        if ( altd ) LDRIM(c_);
        else LDRIM(c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x16: // LD D,n
        if ( altd ) LDRIM(d_);
        else LDRIM(d);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1e: // LD E,n
        if ( altd ) LDRIM(e_);
        else LDRIM(e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x26: // LD H,n // LD IXh,n // LD IYh,n
        if( ih ) {
          if ( altd ) LDRIM(h_);
          else LDRIM(h);
        } else if( iy && canixh() )
          LDRIM(yh);
        else if ( canixh() )
          LDRIM(xh);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2e: // LD L,n // LD IXl,n // LD IYl,n
        if( ih ) {
          if ( altd ) LDRIM(l_);
          else LDRIM(l);
        } else if( iy && canixh() )
          LDRIM(yl);
        else if ( canixh() )
          LDRIM(xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x36: // LD (HL),n // LD (IX+d),n // LD (IY+d),n
        if( ih )
          st+= israbbit() ? 7 : 10,
          put_memory(l|h<<8,get_memory(pc++));
        else if( iy )
          LDPIN(yh, yl);
        else
          LDPIN(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3e: // LD A,n / (EZ80) ld (ix+d),iy (prefixed)
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 4;
            if ( iy == 0 ) {  // ld (ix+d),iy
                put_memory(t+(xl|xh<<8),yl);
                put_memory(t+(xl|xh<<8) + 1,yh);
            } else {  // ld (iy+d),iy
                put_memory(t+(yl|yh<<8),xl);
                put_memory(t+(yl|yh<<8) + 1,xh);
            }
            break;
        }
        if ( altd ) LDRIM(a_);
        else LDRIM(a);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x07: // RLCA / (EZ80) ld bc,(ix+d) (prefixed)
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 4;
            if ( iy == 0 ) {  // ld bc,(ix+d)
                c = get_memory(t+(xl|xh<<8));
                b = get_memory(t+(xl|xh<<8) + 1);
            } else {  // ld bc,(iy+d)
                c = get_memory(t+(yl|yh<<8));
                b = get_memory(t+(yl|yh<<8) + 1);
            }
            break;
        }
	st+= isez80() ? 1 :  israbbit() ? 2 : isz180() ? 3 : 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x0f: // RRCA / (EZ80) ld (ix+d),bc (prefixed)
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 4;
            if ( iy == 0 ) {  // ld (ix+d),bc
                put_memory(t+(xl|xh<<8),c);
                put_memory(t+(xl|xh<<8) + 1,b);
            } else {  // ld (iy+d),bc
                put_memory(t+(yl|yh<<8),c);
                put_memory(t+(yl|yh<<8) + 1,b);
            }
            break;
        }
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x17: // RLA,  (EZ80) ld de,(ix+d) (prefixed)
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 4;
            if ( iy == 0 ) {  // ld de,(ix+d)
                e = get_memory(t+(xl|xh<<8));
                d = get_memory(t+(xl|xh<<8) + 1);
            } else {  // ld de,(iy+d)
                e = get_memory(t+(yl|yh<<8));
                d = get_memory(t+(yl|yh<<8) + 1);
            }
            break;
        }
        st+= isez80() ? 1 :  israbbit() ? 2 : isz180() ? 3 : 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x1f: // RRA / (EZ80) ld (ix+d),de (prefixed)
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 4;
            if ( iy == 0 ) {  // ld (ix+d),de
                put_memory(t+(xl|xh<<8),e);
                put_memory(t+(xl|xh<<8) + 1,d);
            } else {  // ld (iy+d),de
                put_memory(t+(yl|yh<<8),e);
                put_memory(t+(yl|yh<<8) + 1,d);
            }
            break;
        }
        st+= isez80() ? 1 : israbbit() ? 2 :isz180() ? 3 : 4;
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
        st+= isez80() ? 3 :12;
        mp= pc+= (get_memory(pc)^128)-127;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x20: // JR NZ,s8
        JRCI(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x28: // JR Z,s8
        JRC(fr);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x30: // JR NC,s8
        JRC(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x38: // JR C,s8
        JRCI(ff&256);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x08: // EX AF,AF'
        st+= 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x10: // DJNZ
        if( ( altd && --b_) || ( altd == 0 && --b) )
          st+= isez80() ? 4 :israbbit() ? 5 : 13,
          mp= pc+= (get_memory(pc)^128)-127;
        else
          st+= isez80() ? 2 : israbbit() ? 5 : 8,
          pc++;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x27: // DAA / (RCM) add sp,d / (EZ80) ld hl,(ix+d) (prefixed)
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 5;
            if ( iy == 0 ) {  // ld hl,(ix+d)
                l = get_memory(t+(xl|xh<<8));
                h = get_memory(t+(xl|xh<<8) + 1);
            } else {  // ld hl,(iy+d)
                l = get_memory(t+(yl|yh<<8));
                h = get_memory(t+(yl|yh<<8) + 1);
            }
            break;
        }
        if ( israbbit()) {
          st += 4;
          sp += (get_memory(pc++)^128)-128; // TODO: Carry
        } else {
          st+= isez80() ? 1 : 4;
          t= (fr^fa^fb^fb>>8) & 16;  // H flag
          u= 0;		// incr
          if ( isz180() ) {
            if ( t || (!(fb&512) && (a&0x0f) > 0x9) )
               u |= 6;
            if ( (ff & 256) || (!(fb&512) && a > 0x99) )
               u |= 0x160;
          } else {
            (a |ff&256)>0x99 && (u= 0x160); 
            (a&15 | t)>9 && (u+= 6);
          }
          fa= a|256;
          if( fb&512) // N (subtract) flag set
            a-= u,
            fb= ~u;
          else
            a+= fb= u;
          ff= (fr= a)
            | u&256;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x2f: // CPL / (EZ80) ld (ix+d),hl
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 5;
            if ( iy == 0 ) {  // ld (ix+d),hl
                put_memory(t+(xl|xh<<8),l);
                put_memory(t+(xl|xh<<8) + 1,h);
            } else {  // ld (iy+d),hl
                put_memory(t+(yl|yh<<8),l);
                put_memory(t+(yl|yh<<8) + 1,h);
            }
            break;
        }
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x37: // SCF/ (EZ80) ld ix,(ix+d) (prefixed)
        if ( isez80() && ih == 0) {
            t = (get_memory(pc++)^128)-128;
            st += 5;
            if ( iy == 0 ) {  // ld ix,(ix+d)
                unsigned char tl;
                tl = get_memory(t+(xl|xh<<8));
                xh = get_memory(t+(xl|xh<<8) + 1);
                xl = tl;
            } else {  // ld iy,(iy+d)
                unsigned char tl;
                tl = get_memory(t+(yl|yh<<8));
                yh = get_memory(t+(yl|yh<<8) + 1);
                yl = tl;
            }
            break;
        }
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x3f: // CCF / (EZ80) ld (ix+d),ix
        if ( isez80() && ih == 0 ) {
            t = (get_memory(pc++)^128)-128;
            st += 5;
            if ( iy == 0 ) {  // ld (ix+d),ix
                put_memory(t+(xl|xh<<8),xl);
                put_memory(t+(xl|xh<<8) + 1,xh);
            } else {  // ld (iy+d),iy
                put_memory(t+(yl|yh<<8),yl);
                put_memory(t+(yl|yh<<8) + 1,yh);
            }
            break;
        }
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
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
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x41: // LD B,C
        LDRR(b, c, b_, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x42: // LD B,D
        LDRR(b, d, b_, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x43: // LD B,E
        LDRR(b, e, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x44: // LD B,H // LD B,IXh // LD B,IYh
        if( ih ) {
          LDRR(b, h, h_,isez80() ? 1 : israbbit() ? 2 : 4);
        } else if( iy && canixh() )
          LDRR(b, yh, b,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(b, xh, b,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x45: // LD B,L // LD B,IXl // LD B,IYl
        if( ih ) {
          LDRR(b, l, b_,isez80() ? 1 : israbbit() ? 2 : 4);
        } else if( iy && canixh() )
          LDRR(b, yl, b,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(b, xl, b,isez80() ? 1 : 4);
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
        LDRR(b, a, b_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x48: // LD C,B
        LDRR(c, b, c_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4a: // LD C,D
        LDRR(c, d, c_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4b: // LD C,E
        LDRR(c, e,c_, israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4c: // LD C,H // LD C,IXh // LD C,IYh
        if( ih )
          LDRR(c, h, c_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(c, yh, c,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(c, xh, c,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4d: // LD C,L // LD C,IXl // LD C,IYl
        if( ih )
          LDRR(c, l, c_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(c, yl, c,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(c, xl, c,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4e: // LD C,(HL) // LD C,(IX+d) // LD C,(IY+d)
        if( ih )
          LDRP(h, l, c);
        else if( iy )
          LDRPI(yh, yl, c);
        else
          LDRPI(xh, xl, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x4f: // LD C,A
        LDRR(c, a, c_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x50: // LD D,B
        LDRR(d, b, d_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x51: // LD D,C
        LDRR(d, c,  d_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x53: // LD D,E
        LDRR(d, e,  d_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x54: // LD D,H // LD D,IXh // LD D,IYh
        if( ih )
          LDRR(d, h,  d_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(d, yh, d,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(d, xh, d,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x55: // LD D,L // LD D,IXl // LD D,IYl
        if( ih )
          LDRR(d, l,  d_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(d, yl, d,isez80() ? 1 : 4);
        else if (canixh() )
          LDRR(d, xl, d,isez80() ? 1 : 4);
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
        LDRR(d, a,  d_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x58: // LD E,B
        LDRR(e, b, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x59: // LD E,C
        LDRR(e, c, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5a: // LD E,D
        LDRR(e, d, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5c: // LD E,H // LD E,IXh // LD E,IYh
        if( ih )
          LDRR(e, h, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(e, yh, e,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(e, xh, e,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x5d: // LD E,L // LD E,IXl // LD E,IYl
        if( ih )
          LDRR(e, l, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(e, yl, e,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(e, xl, e,isez80() ? 1 : 4);
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
        LDRR(e, a, e_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x60: // LD H,B // LD IXh,B // LD IYh,B
        if( ih )
          LDRR(h, b, h_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yh, b, yh,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, b, xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x61: // LD H,C // LD IXh,C // LD IYh,C
        if( ih )
          LDRR(h, c, h_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yh, c, yh,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, c, xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x62: // LD H,D // LD IXh,D // LD IYh,D
        if( ih )
          LDRR(h, d,  h_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yh, d, yh,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, d, xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x63: // LD H,E // LD IXh,E // LD IYh,E
        if( ih )
          LDRR(h, e,  h_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yh, e, yh,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, e, xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x65: // LD H,L // LD IXh,IXl // LD IYh,IYl
        if( ih )
          LDRR(h, l, h_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yh, yl, yh,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, yl, xh,isez80() ? 1 : 4);
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
          LDRR(h, a, h_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yh, a, yh,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xh, a, xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x68: // LD L,B // LD IXl,B // LD IYl,B
        if( ih )
          LDRR(l, b, l_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yl, b, yl,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, b, xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x69: // LD L,C // LD IXl,C // LD IYl,C
        if( ih )
          LDRR(l, c, l_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yl, c, yl,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, c, xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6a: // LD L,D // LD IXl,D // LD IYl,D
        if( ih )
          LDRR(l, d, l_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yl, d, yl,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, d, xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6b: // LD L,E // LD IXl,E // LD IYl,E
        if( ih )
          LDRR(l, e, l_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yl, e, yl,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, e, xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x6c: // LD L,H // LD IXl,IXh // LD IYl,IYh
        if( ih )
          LDRR(l, h, l_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yl, yh, yl,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, xh, xl,isez80() ? 1 : 4);
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
        if( ih )
          LDRR(l, a, l_,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          LDRR(yl, a, yl,isez80() ? 1 : 4);
        else if ( canixh() )
          LDRR(xl, a, xl,isez80() ? 1 : 4);
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
        LDRR(a, b, a_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x79: // LD A,C
        LDRR(a, c, a_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7a: // LD A,D
        LDRR(a, d, a_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7b: // LD A,E
        LDRR(a, e, a_,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7c: // LD A,H // LD A,IXh // LD A,IYh (RCM) LD HL,IX LD HL,IY
        if ( israbbit()) {
          if ( ih ) {
             LDRR(a,h,a_, 2);
          } else if ( iy ) {
            if ( altd ) { h_ = yh; l_ = yl; }
            else { h = yh; l = yl; }
            st += 4;
          } else {
            if ( altd ) { h_ = xh; l_ = xl; }
            else { h = xh; l = xl; }
            st += 4;
          }
        } else {
          if( ih )
            LDRR(a, h, a,isez80() ? 1 : 4);
          else if( iy )
            LDRR(a, yh, a,isez80() ? 1 : 4);
          else
            LDRR(a, xh, a,isez80() ? 1 : 4);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x7d: // LD A,L // LD A,IXl // LD A,IYl
        if( ih ) {
          LDRR(a, l, a_,isez80() ? 1 : israbbit() ? 2 : 4);
        } else if( iy ) {
          if ( israbbit() ) {
              yl = l; yh = h;      // LD IY,HL
              st += 4;
          } else {
              LDRR(a, yl, a,isez80() ? 1 : 4);
          }
        } else {
          if ( israbbit() ) {
              xl = l; xh = h;     // LD IX,HL
              st += 4;
          } else {
              LDRR(a, xl, a,isez80() ? 1 : 4);
          }
        }
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
        ADD(b,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x81: // ADD A,C
        ADD(c,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x82: // ADD A,D
        ADD(d,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x83: // ADD A,E
        ADD(e,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x84: // ADD A,H // ADD A,IXh // ADD A,IYh
        if( ih )
          ADD(h,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          ADD(yh,isez80() ? 1 : 4);
        else if ( canixh() )
          ADD(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x85: // ADD A,L // ADD A,IXl // ADD A,IYl
        if( ih )
          ADD(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          ADD(yl,isez80() ? 1 : 4);
        else if ( canixh() )
          ADD(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x86: // ADD A,(HL) // ADD A,(IX+d) // ADD A,(IY+d)
        if( ih )
          ADD(get_memory(l|h<<8),isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          ADD(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535),isez80() ? 3 : 7);
        else
          ADD(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535),isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x87: // ADD A,A
        st+= isez80() ? 1 : israbbit() ? 2 : 4;
        if ( altd ) fr_= a_= (ff_= 2*(fa_= fb_= a));
        else fr= a= (ff= 2*(fa= fb= a));
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x88: // ADC A,B
        ADC(b,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x89: // ADC A,C
        ADC(c,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8a: // ADC A,D
        ADC(d,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8b: // ADC A,E
        ADC(e,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8c: // ADC A,H // ADC A,IXh // ADC A,IYh
        if( ih )
          ADC(h,isez80() ? 1 :israbbit() ? 2 : 4);
        else if( iy && canixh() )
          ADC(yh,isez80() ? 1 : 4);
        else if ( canixh() )
          ADC(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8d: // ADC A,L // ADC A,IXl // ADC A,IYl
        if( ih )
          ADC(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          ADC(yl,isez80() ? 1 : 4);
        else if ( canixh() )
          ADC(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8e: // ADC A,(HL) // ADC A,(IX+d) // ADC A,(IY+d)
        if( ih )
          ADC(get_memory(l|h<<8),isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          ADC(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535),isez80() ? 3 : 7);
        else
          ADC(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535),isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x8f: // ADC A,A
        st+=isez80() ? 1 : israbbit() ? 2 : 4;
        if ( altd ) fr_= a_= (ff_= 2*(fa_= fb_= a)+(ff_>>8&1));
        else fr= a= (ff= 2*(fa= fb= a)+(ff>>8&1));
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x90: // SUB B
        SUB(b,isez80() ? 1 :israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x91: // SUB C
        SUB(c,isez80() ? 1 :israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x92: // SUB D
        SUB(d,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x93: // SUB E
        SUB(e,isez80() ? 1 :israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x94: // SUB H // SUB IXh // SUB IYh
        if( ih )
          SUB(h,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          SUB(yh,isez80() ? 1 : 4);
        else if ( canixh() )
          SUB(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x95: // SUB L // SUB IXl // SUB IYl
        if( ih )
          SUB(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          SUB(yl,isez80() ? 1 : 4);
        else if ( canixh() )
          SUB(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x96: // SUB (HL) // SUB (IX+d) // SUB (IY+d)
        if( ih )
          SUB(get_memory(l|h<<8),isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          SUB(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535),isez80() ? 3 :  7);
        else
          SUB(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535),isez80() ? 3 :  7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x97: // SUB A
        st+=isez80() ? 1 : israbbit() ? 2 : 4;
        if ( altd ) {
          fb_= ~(fa_= a);
          fr_= a_= ff_= 0;
        } else {
          fb= ~(fa= a);
          fr= a= ff= 0;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x98: // SBC A,B
        SBC(b, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x99: // SBC A,C
        SBC(c, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9a: // SBC A,D
        SBC(d, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9b: // SBC A,E
        SBC(e, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9c: // SBC A,H // SBC A,IXh // SBC A,IYh
        if( ih )
          SBC(h,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          SBC(yh,isez80() ? 1 : 4);
        else if ( canixh() )
          SBC(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9d: // SBC A,L // SBC A,IXl // SBC A,IYl
        if( ih )
          SBC(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          SBC(yl,isez80() ? 1 : 4);
        else if ( canixh() )
          SBC(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9e: // SBC A,(HL) // SBC A,(IX+d) // SBC A,(IY+d)
        if( ih )
          SBC(get_memory(l|h<<8),isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          SBC(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535), isez80() ? 3 : 7);
        else
          SBC(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535), isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0x9f: // SBC A,A
        st+= isez80() ? 1 : israbbit() ? 2 : 4;
        if ( altd ) {
          fb_= ~(fa_= a);
          fr_= a_= (ff_= (ff_&256)/-256);
        } else {
          fb= ~(fa= a);
          fr= a= (ff= (ff&256)/-256);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa0: // AND B
        AND(b, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa1: // AND C
        AND(c, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa2: // AND D
        AND(d, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa3: // AND E
        AND(e, isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa4: // AND H // AND IXh // AND IYh
        if( ih )
          AND(h,  isez80() ? 1 :israbbit() ? 2 : 4);
        else if( iy && canixh() )
          AND(yh, isez80() ? 1 : 4);
        else if ( canixh() )
          AND(xh, isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa5: // AND L // AND IXl // AND IYl
        if( ih )
          AND(l, isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          AND(yl, isez80() ? 1 : 4);
        else if ( canixh() )
          AND(xl, isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa6: // AND (HL) // AND (IX+d) // AND (IY+d)
        if( ih )
          AND(get_memory(l|h<<8), isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          AND(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535), isez80() ? 3 : 7);
        else
          AND(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535), isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa7: // AND A
        st+=isez80() ? 1 : israbbit() ? 2 : 4;
        if ( altd ) {
          fa_= ~(ff_= fr_= a_);
          fb_= 0;
        } else {
          fa= ~(ff= fr= a);
          fb= 0;
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa8: // XOR B
        XOR(b,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xa9: // XOR C
        XOR(c,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xaa: // XOR D
        XOR(d,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xab: // XOR E
        XOR(e,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xac: // XOR H // XOR IXh // XOR IYh
        if( ih )
          XOR(h,isez80() ? 1 : 4);
        else if( iy )
          XOR(yh,isez80() ? 1 : 4);
        else
          XOR(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xad: // XOR L // XOR IXl // XOR IYl
        if( ih )
          XOR(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          XOR(yl,isez80() ? 1 : 4);
        else if ( canixh() )
          XOR(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xae: // XOR (HL) // XOR (IX+d) // XOR (IY+d)
        if( ih )
          XOR(get_memory(l|h<<8),isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          XOR(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535),isez80() ? 3 : 7);
        else
          XOR(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535),isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xaf: // XOR A
        st+=isez80() ? 1 : israbbit() ? 2 : 4;
        a= ff= fr= fb= 0;
        fa= 256;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb0: // OR B
        OR(b,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb1: // OR C
        OR(c,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb2: // OR D
        OR(d,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb3: // OR E
        OR(e,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb4: // OR H // OR IXh // OR IYh
        if( ih )
          OR(h,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          OR(yh,isez80() ? 1 : 4);
        else if ( canixh() )
          OR(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb5: // OR L // OR IXl // OR IYl
        if( ih )
          OR(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          OR(yl,isez80() ? 1 : 4);
        else if ( canixh() )
          OR(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb6: // OR (HL) // OR (IX+d) // OR (IY+d)
        if( ih )
          OR(get_memory(l|h<<8),isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          OR(get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535),isez80() ? 3 : 7);
        else
          OR(get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535),isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb7: // OR A
        st+=isez80() ? 1 : israbbit() ? 2 : 4;
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
        CP(b,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xb9: // CP C
        CP(c,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xba: // CP D
        CP(d,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbb: // CP E
        CP(e,isez80() ? 1 : israbbit() ? 2 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbc: // CP H // CP IXh // CP IYh
        if( ih )
          CP(h,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          CP(yh,isez80() ? 1 : 4);
        else if ( canixh() )
          CP(xh,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbd: // CP L // CP IXl // CP IYl
        if( ih )
          CP(l,isez80() ? 1 : israbbit() ? 2 : 4);
        else if( iy && canixh() )
          CP(yl,isez80() ? 1 : 4);
        else if (canixh())
          CP(xl,isez80() ? 1 : 4);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbe: // CP (HL) // CP (IX+d) // CP (IY+d)
        if( ih )
          w= get_memory(l|h<<8),
          CP(w,isez80() ? 2 : israbbit() ? 5 : 7);
        else if( iy )
          w= get_memory(((get_memory(pc++)^128)-128+(yl|yh<<8))&65535),
          CP(w,isez80() ? 3 : 7);
        else
          w= get_memory(((get_memory(pc++)^128)-128+(xl|xh<<8))&65535),
          CP(w,isez80() ? 3 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xbf: // CP A
        st+=isez80() ? 1 : israbbit() ? 2 : 4;  
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
      case 0xc9: // RET
        RET(isez80() ? 5 : israbbit() ?  8 : isz180() ? 9 : 10);
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
        RETC(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe8: // RET PE
        RETCI(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf0: // RET P
        RETC(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf8: // RET M
        RETCI(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc1: // POP BC
        POP(b, c);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd1: // POP DE
        POP(d, e);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe1: // POP HL // POP IX // POP IY
        if( ih )
          POP(h, l);
        else if( iy )
          POP(yh, yl);
        else
          POP(xh, xl);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf1: // POP AF
        st+= isez80() ? 3 : 10;
        setf(get_memory(sp++));
        a= get_memory(sp++);
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
        PUSH(a, f());
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc3: // JP nn
        st+= isez80() ? 4 : israbbit() ? 3 : israbbit() ? 7 : isz180() ? 9 : 10;
        mp= pc= get_memory(pc) | get_memory(pc+1)<<8;
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
        JPC(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xea: // JP PE
        JPCI(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf2: // JP P
        JPC(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xfa: // JP M
        JPCI(ff&128);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xcd: // CALL nn
        st+= isez80() ? 5 : israbbit() ? 12 : isz180() ? 16 : 17;
        t= pc+2;
        mp= pc= get_memory(pc) | get_memory(pc+1)<<8;
        put_memory(--sp,t>>8);
        put_memory(--sp,t);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc4: // CALL NZ / (RCM) LD HL,(SP+N)
        if ( israbbit()) {
          int     offset = sp + get_memory(pc++);
          st += 9;
          if ( ih ) {
            l = get_memory(offset++);
            h = get_memory(offset);
          } else if ( iy ) {
            yl = get_memory(offset++);
            yh = get_memory(offset);
          } else {
            xl = get_memory(offset++);
            xh = get_memory(offset);
          }
        } else {
          CALLCI(fr);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xcc: // CALL Z / (RCM) BOOL HL
        if ( israbbit()) {
          if ( ih ) {
            BOOL(h,l, h_, l_, altd);
          } else if ( iy ) {
            BOOL(yh, yl, yh, yl, 0);
          } else {
            BOOL(xh,xl,xh,xl, 0);
          }
          st += 2;
        } else {
          CALLC(fr);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd4: // CALL NC / (RCM) LD (SP+N),HL
        if ( israbbit()) {
          int     offset = sp + get_memory(pc++);
          st += 9;

          if ( ih ) {
            put_memory(offset++,l);
            put_memory(offset, h);
          } else if ( iy ) {
            put_memory(offset++,yl);
            put_memory(offset, yh);
          } else {
            put_memory(offset++,xl);
            put_memory(offset, xh);
          }
        } else {
          CALLC(ff&256);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xdc: // CALL C / (RCM) AND HL,DE
        if ( israbbit()) {
          if ( ih ) { 
            AND2(h,d,h_);
            AND2(l,e,e_);
          } else if ( iy ) {
            AND2(yh, d, yh);
            AND2(yl, e, yl);
          } else {
            AND2(xh, d, xh);
            AND2(xl, e, xl);
          }
          st += 2;
        } else {
          CALLCI(ff&256);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe4: // CALL PO / (RCM) LD HL,(IX+D)
        if ( israbbit()) {
          t = (get_memory(pc++)^128)-128;
          st += 11;
          if ( ih ) {    // ld hl,(ix+d)
            l = get_memory(t+(xl|xh<<8));
            h = get_memory(t+(xl|xh<<8) + 1);
          } else if ( iy ) { // ld hl,(iy+d)
            l = get_memory(t+(yl|yh<<8));
            h = get_memory(t+(yl|yh<<8) + 1);
          } else { // ld hl,(hl+d)
            unsigned char lt;
            lt = get_memory(t+(l|h<<8));
            h = get_memory(t+(l|h<<8) + 1);
            l = lt;
          }
        } else {
          CALLC(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xec: // CALL PE / (RCM) OR HL,DE
        if ( israbbit()) {
          if ( ih ) { 
            OR2(h,d);
            OR2(l,e);
          } else if ( iy ) {
            OR2(yh, d);
            OR2(yl, e);
          } else {
            OR2(xh, d);
            OR2(xl, e);
          }
          st += 2;
        } else {
          CALLCI(fa&256?38505>>((fr^fr>>4)&15)&1:(fr^fa)&(fr^fb)&128);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf4: // CALL P or (RCM) LD (IX+D),HL
        if ( israbbit()) {
          t = (get_memory(pc++)^128)-128;
          st += 11;
          if ( ih ) {    // ld (ix+d),hl
            put_memory(t+(xl|xh<<8),l);
            put_memory(t+(xl|xh<<8) + 1,h);
          } else if ( iy ) { // ld (iy+d),hl
            put_memory(t+(yl|yh<<8),l);
            put_memory(t+(yl|yh<<8) + 1,h);
          } else { // ld (hl+d),hl
            int addr = t+(l|h<<8);
            put_memory(addr,l);
            put_memory(addr + 1, h);
          }
        } else {
          CALLC(ff&128);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xfc: // CALL M  / (RCM) RR HL
        if ( israbbit()) {
          long long savest = st;
          if ( ih ) {
            RR(h);
            RR(l);
          } else if ( iy ) {
            RR(yh);
            RR(yl);
          } else {
            RR(xh);
            RR(xl);            
          }
          st = savest;
          st += 2;
        } else {
          CALLCI(ff&128);
        }
        ih=1;altd=0;ioi=0;ioe=0;
        break;
      case 0xc6: // ADD A,n
        ADD(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xce: // ADC A,n
        ADC(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd6: // SUB n
        SUB(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xde: // SBC A,n
        SBC(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe6: // AND n
        AND(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xee: // XOR A,n
        XOR(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf6: // OR n
        OR(get_memory(pc++), isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xfe: // CP A,n
        w= get_memory(pc++);
        CP(w, isez80() ? 2 : israbbit() ? 4 : 7);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xc7: // RST 0x00  (RCM) LJP
        RST(0);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xcf: // RST 0x08 (RCM) LCALL
        RST(8);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd7: // RST 0x10
        RST(0x10);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xdf: // RST 0x18
        RST(0x18);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe7: // RST 0x20
        RST(0x20);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xef: // RST 0x28
        RST(0x28);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf7: // RST 0x30, (RCM) mul
        if ( israbbit()) {
          // HL:BC = BC • DE
          int32_t result = (( d * 256 ) + e) * (( b * 256 ) + c);
          h = (result >> 24);
          l = (result >> 16) & 0xff;
          b  = (result >> 8 ) & 0xff;
          c = result & 0xff;
          st += 12;
        } else {
          RST(0x30);
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xff: // RST 0x38
        RST(0x38);
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd3: // OUT (n),A
        if ( israbbit()) {
          ioi=1;
          st+=2;
        } else {
          st+= 11;
          out(mp= get_memory(pc++) | a<<8, a);
          mp= mp&65280
            | ++mp;
          ih=1;altd=0;ioi=0;ioe=0;
        }
        break;
      case 0xdb: // IN A,(n) // (RCM) ioe
        if ( israbbit()) {
          ioe=1;
          st+=2;
        } else {
          st+= 11;
          a= in(mp= get_memory(pc++) | a<<8);
          ++mp;
          ih=1;altd=0;ioi=0;ioe=0;
        }
        break;
      case 0xf3: // DI  / (RCM) RL DE
        if ( israbbit()) {
          long long savest = st;
          RL(e);
          RL(d);
          st = savest;
          st += 2;
        } else {
          st+= isez80() ? 1 : isz180() ? 3 : 4;
          iff= 0;
          ih=1;altd=0;ioi=0;ioe=0;
        }
        break;
      case 0xfb: // EI / (RCM) RR DE
        if ( israbbit()) {
          long long savest = st;
          RR(d);
          RR(e);
          st = savest;
          st += 2;
        } else {
          st+= isez80() ? 1 : isz180() ? 3 : 4;
          iff= 1;
        }
        ih=1;altd=0;ioi=0;ioe=0;
        break;
      case 0xeb: // EX DE,HL
        st+= isez80() ? 1 : israbbit() ? 2 : 4;
        t= d;
        d= h;
        h= t;
        t= e;
        e= l;
        l= t;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xd9: // EXX
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
        t = b;
        b = b_;
        b_= t;
        t = c;
        c = c_;
        c_= t;
        t = d;
        d = d_;
        d_= t;
        t = e;
        e = e_;
        e_= t;
        t = h;
        h = h_;
        h_= t;
        t = l;
        l = l_;
        l_= t;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xe3: // EX (SP),HL // EX (SP),IX // EX (SP),IY or (RCM) EX DE',HL
        if ( israbbit() && ih ) {
          t = h;
          h = d_;
          d_ = t;
          t = l;
          l = e_;
          e_ = l;
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
        st+= isez80() ? 3 : isz180() ? 3 : 4;
        if( ih )
          pc= l | h<<8;
        else if( iy )
          pc= yl | yh<<8;
        else
          pc= xl | xh<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xf9: // LD SP,HL
        st+= isez80() ? 1 : israbbit() ? 2 : 4;
        if( ih )
          sp= l | h<<8;
        else if( iy )
          sp= yl | yh<<8;
        else
          sp= xl | xh<<8;
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xdd: // OP DD
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
        ih= iy= 0;
        ih=0;break;
      case 0xfd: // OP FD
        st+= isez80() ? 1 : israbbit() ? 2 : isz180() ? 3 : 4;
        ih= 0;
        iy= 1;
        ih=0;break;
      case 0xcb: // OP CB
        r++;
        if( ih )
          switch( get_memory(pc++) ){
            case 0x00:  RLC(b); break;                       // RLC B
            case 0x01:  RLC(c); break;                       // RLC C
            case 0x02:  RLC(d); break;                       // RLC D
            case 0x03:  RLC(e); break;                       // RLC E
            case 0x04:  RLC(h); break;                       // RLC H
            case 0x05:  RLC(l); break;                       // RLC L
            case 0x06:  st+= israbbit() ? 6 : 7;             // RLC (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        RLC(u);
                        put_memory(t, u); break;                        
            case 0x07:  RLC(a); break;                       // RLC A
            case 0x08:  RRC(b); break;                       // RRC B
            case 0x09:  RRC(c); break;                       // RRC C
            case 0x0a:  RRC(d); break;                       // RRC D
            case 0x0b:  RRC(e); break;                       // RRC E
            case 0x0c:  RRC(h); break;                       // RRC H
            case 0x0d:  RRC(l); break;                       // RRC L
            case 0x0e:  st+= israbbit() ? 6 : 7;             // RRC (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        RRC(u);
                        put_memory(t, u); break;                        
            case 0x0f:  RRC(a); break;                       // RRC A
            case 0x10:  RL(b); break;                        // RL B
            case 0x11:  RL(c); break;                        // RL C
            case 0x12:  RL(d); break;                        // RL D
            case 0x13:  RL(e); break;                        // RL E
            case 0x14:  RL(h); break;                        // RL H
            case 0x15:  RL(l); break;                        // RL L
            case 0x16:  st+= israbbit() ? 6 : 7;             // RL (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        RL(u);
                        put_memory(t, u); break;                        
            case 0x17:  RL(a); break;                        // RL A
            case 0x18:  RR(b); break;                        // RR B
            case 0x19:  RR(c); break;                        // RR C
            case 0x1a:  RR(d); break;                        // RR D
            case 0x1b:  RR(e); break;                        // RR E
            case 0x1c:  RR(h); break;                        // RR H
            case 0x1d:  RR(l); break;                        // RR L
            case 0x1e:  st+= israbbit() ? 6 : 7;             // RR (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        u=get_memory(t);
                        RR(u);
                        put_memory(t, u); break;                        
            case 0x1f:  RR(a); break;                        // RR A
            case 0x20:  SLA(b); break;                       // SLA B
            case 0x21:  SLA(c); break;                       // SLA C
            case 0x22:  SLA(d); break;                       // SLA D
            case 0x23:  SLA(e); break;                       // SLA E
            case 0x24:  SLA(h); break;                       // SLA H
            case 0x25:  SLA(l); break;                       // SLA L
            case 0x26:  st+= israbbit() ? 6 : 7;             // SLA (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        SLA(u);
                        put_memory(t, u); break;                        
            case 0x27:  SLA(a); break;                       // SLA A
            case 0x28:  SRA(b); break;                       // SRA B
            case 0x29:  SRA(c); break;                       // SRA C
            case 0x2a:  SRA(d); break;                       // SRA D
            case 0x2b:  SRA(e); break;                       // SRA E
            case 0x2c:  SRA(h); break;                       // SRA H
            case 0x2d:  SRA(l); break;                       // SRA L
            case 0x2e:  st+= israbbit() ? 6 : 7;             // SRA (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        SRA(u);
                        put_memory(t, u); break;                        
            case 0x2f:  SRA(a); break;                       // SRA A
            case 0x30:  SLL(b); break;                       // SLL B
            case 0x31:  SLL(c); break;                       // SLL C
            case 0x32:  SLL(d); break;                       // SLL D
            case 0x33:  SLL(e); break;                       // SLL E
            case 0x34:  SLL(h); break;                       // SLL H
            case 0x35:  SLL(l); break;                       // SLL L
            case 0x36:                                       // SLL (HL)
                        if (cansll() ) {
                          st+= 7; 
                          t= l|h<<8;
                          u=get_memory(t);
                          SLL(u);
                          put_memory(t, u); 
                        }
                        break;                        
            case 0x37:  SLL(a); break;                       // SLL A
            case 0x38:  SRL(b); break;                       // SRL B
            case 0x39:  SRL(c); break;                       // SRL C
            case 0x3a:  SRL(d); break;                       // SRL D
            case 0x3b:  SRL(e); break;                       // SRL E
            case 0x3c:  SRL(h); break;                       // SRL H
            case 0x3d:  SRL(l); break;                       // SRL L
            case 0x3e:  st+= israbbit() ? 6 : 7;             // SRL (HL)
                        t= l|h<<8;
                        u=get_memory(t);
                        SRL(u);
                        put_memory(t, u); break;                        
            case 0x3f:  SRL(a); break;                       // SRL A
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
          st+= 11;
          if( iy )
            t= get_memory(mp= ((get_memory(pc++)^128)-128+(yl|yh<<8)));
          else
            t= get_memory(mp= ((get_memory(pc++)^128)-128+(xl|xh<<8)));
          switch( get_memory(pc++) ){
            case 0x00: RLC(t); put_memory(mp, b=t); break;         // LD B,RLC (IX+d) // LD B,RLC (IY+d)
            case 0x01: RLC(t); put_memory(mp, c=t); break;         // LD C,RLC (IX+d) // LD C,RLC (IY+d)
            case 0x02: RLC(t); put_memory(mp, d=t); break;         // LD D,RLC (IX+d) // LD D,RLC (IY+d)
            case 0x03: RLC(t); put_memory(mp, e=t); break;         // LD E,RLC (IX+d) // LD E,RLC (IY+d)
            case 0x04: RLC(t); put_memory(mp, h=t); break;         // LD H,RLC (IX+d) // LD H,RLC (IY+d)
            case 0x05: RLC(t); put_memory(mp, l=t); break;         // LD L,RLC (IX+d) // LD L,RLC (IY+d)
            case 0x06: RLC(t); put_memory(mp, t); break;            // RLC (IX+d) // RLC (IY+d)
            case 0x07: RLC(t); put_memory(mp, a=t); break;         // LD A,RLC (IX+d) // LD A,RLC (IY+d)
            case 0x08: RRC(t); put_memory(mp, b=t); break;         // LD B,RRC (IX+d) // LD B,RRC (IY+d)
            case 0x09: RRC(t); put_memory(mp, c=t); break;         // LD C,RRC (IX+d) // LD C,RRC (IY+d)
            case 0x0a: RRC(t); put_memory(mp, d=t); break;         // LD D,RRC (IX+d) // LD D,RRC (IY+d)
            case 0x0b: RRC(t); put_memory(mp, e=t); break;         // LD E,RRC (IX+d) // LD E,RRC (IY+d)
            case 0x0c: RRC(t); put_memory(mp, h=t); break;         // LD H,RRC (IX+d) // LD H,RRC (IY+d)
            case 0x0d: RRC(t); put_memory(mp, l=t); break;         // LD L,RRC (IX+d) // LD L,RRC (IY+d)
            case 0x0e: RRC(t); put_memory(mp, t); break;            // RRC (IX+d) // RRC (IY+d)
            case 0x0f: RRC(t); put_memory(mp, a=t); break;         // LD A,RRC (IX+d) // LD A,RRC (IY+d)
            case 0x10: RL(t); put_memory(mp, b=t); break;          // LD B,RL (IX+d) // LD B,RL (IY+d)
            case 0x11: RL(t); put_memory(mp, c=t); break;          // LD C,RL (IX+d) // LD C,RL (IY+d)
            case 0x12: RL(t); put_memory(mp, d=t); break;          // LD D,RL (IX+d) // LD D,RL (IY+d)
            case 0x13: RL(t); put_memory(mp, e=t); break;          // LD E,RL (IX+d) // LD E,RL (IY+d)
            case 0x14: RL(t); put_memory(mp, h=t); break;          // LD H,RL (IX+d) // LD H,RL (IY+d)
            case 0x15: RL(t); put_memory(mp, l=t); break;          // LD L,RL (IX+d) // LD L,RL (IY+d)
            case 0x16: RL(t); put_memory(mp, t); break;             // RL (IX+d) // RL (IY+d)
            case 0x17: RL(t); put_memory(mp, a=t); break;          // LD A,RL (IX+d) // LD A,RL (IY+d)
            case 0x18: RR(t); put_memory(mp, b=t); break;          // LD B,RR (IX+d) // LD B,RR (IY+d)
            case 0x19: RR(t); put_memory(mp, c=t); break;          // LD C,RR (IX+d) // LD C,RR (IY+d)
            case 0x1a: RR(t); put_memory(mp, d=t); break;          // LD D,RR (IX+d) // LD D,RR (IY+d)
            case 0x1b: RR(t); put_memory(mp, e=t); break;          // LD E,RR (IX+d) // LD E,RR (IY+d)
            case 0x1c: RR(t); put_memory(mp, h=t); break;          // LD H,RR (IX+d) // LD H,RR (IY+d)
            case 0x1d: RR(t); put_memory(mp, l=t); break;          // LD L,RR (IX+d) // LD L,RR (IY+d)
            case 0x1e: RR(t); put_memory(mp, t); break;             // RR (IX+d) // RR (IY+d)
            case 0x1f: RR(t); put_memory(mp, a=t); break;          // LD A,RR (IX+d) // LD A,RR (IY+d)
            case 0x20: SLA(t); put_memory(mp, b=t); break;         // LD B,SLA (IX+d) // LD B,SLA (IY+d)
            case 0x21: SLA(t); put_memory(mp, c=t); break;         // LD C,SLA (IX+d) // LD C,SLA (IY+d)
            case 0x22: SLA(t); put_memory(mp, d=t); break;         // LD D,SLA (IX+d) // LD D,SLA (IY+d)
            case 0x23: SLA(t); put_memory(mp, e=t); break;         // LD E,SLA (IX+d) // LD E,SLA (IY+d)
            case 0x24: SLA(t); put_memory(mp, h=t); break;         // LD H,SLA (IX+d) // LD H,SLA (IY+d)
            case 0x25: SLA(t); put_memory(mp, l=t); break;         // LD L,SLA (IX+d) // LD L,SLA (IY+d)
            case 0x26: SLA(t); put_memory(mp, t); break;            // SLA (IX+d) // SLA (IY+d)
            case 0x27: SLA(t); put_memory(mp, a=t); break;         // LD A,SLA (IX+d) // LD A,SLA (IY+d)
            case 0x28: SRA(t); put_memory(mp, b=t); break;         // LD B,SRA (IX+d) // LD B,SRA (IY+d)
            case 0x29: SRA(t); put_memory(mp, c=t); break;         // LD C,SRA (IX+d) // LD C,SRA (IY+d)
            case 0x2a: SRA(t); put_memory(mp, d=t); break;         // LD D,SRA (IX+d) // LD D,SRA (IY+d)
            case 0x2b: SRA(t); put_memory(mp, e=t); break;         // LD E,SRA (IX+d) // LD E,SRA (IY+d)
            case 0x2c: SRA(t); put_memory(mp, h=t); break;         // LD H,SRA (IX+d) // LD H,SRA (IY+d)
            case 0x2d: SRA(t); put_memory(mp, l=t); break;         // LD L,SRA (IX+d) // LD L,SRA (IY+d)
            case 0x2e: SRA(t); put_memory(mp, t); break;            // SRA (IX+d) // SRA (IY+d)
            case 0x2f: SRA(t); put_memory(mp, a=t); break;         // LD A,SRA (IX+d) // LD A,SRA (IY+d)
            case 0x30: SLL(t); put_memory(mp, b=t); break;         // LD B,SLL (IX+d) // LD B,SLL (IY+d)
            case 0x31: SLL(t); put_memory(mp, c=t); break;         // LD C,SLL (IX+d) // LD C,SLL (IY+d)
            case 0x32: SLL(t); put_memory(mp, d=t); break;         // LD D,SLL (IX+d) // LD D,SLL (IY+d)
            case 0x33: SLL(t); put_memory(mp, e=t); break;         // LD E,SLL (IX+d) // LD E,SLL (IY+d)
            case 0x34: SLL(t); put_memory(mp, h=t); break;         // LD H,SLL (IX+d) // LD H,SLL (IY+d)
            case 0x35: SLL(t); put_memory(mp, l=t); break;         // LD L,SLL (IX+d) // LD L,SLL (IY+d)
            case 0x36: SLL(t); put_memory(mp, t); break;            // SLL (IX+d) // SLL (IY+d)
            case 0x37: SLL(t); put_memory(mp, a=t); break;         // LD A,SLL (IX+d) // LD A,SLL (IY+d)
            case 0x38: SRL(t); put_memory(mp, b=t); break;         // LD B,SRL (IX+d) // LD B,SRL (IY+d)
            case 0x39: SRL(t); put_memory(mp, c=t); break;         // LD C,SRL (IX+d) // LD C,SRL (IY+d)
            case 0x3a: SRL(t); put_memory(mp, d=t); break;         // LD D,SRL (IX+d) // LD D,SRL (IY+d)
            case 0x3b: SRL(t); put_memory(mp, e=t); break;         // LD E,SRL (IX+d) // LD E,SRL (IY+d)
            case 0x3c: SRL(t); put_memory(mp, h=t); break;         // LD H,SRL (IX+d) // LD H,SRL (IY+d)
            case 0x3d: SRL(t); put_memory(mp, l=t); break;         // LD L,SRL (IX+d) // LD L,SRL (IY+d)
            case 0x3e: SRL(t); put_memory(mp, t); break;            // SRL (IX+d) // SRL (IY+d)
            case 0x3f: SRL(t); put_memory(mp, a=t); break;         // LD A,SRL (IX+d) // LD A,SRL (IY+d)
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
            case 0xae: RES(223, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;       // RES 5,(IX+d) // RES 5,(IY+d)
            case 0xaf: RES(223, t); put_memory(mp, a=t); break;    // LD A,RES 5,(IX+d) // LD A,RES 5,(IY+d)
            case 0xb0: RES(191, t); put_memory(mp, b=t); break;    // LD B,RES 6,(IX+d) // LD B,RES 6,(IY+d)
            case 0xb1: RES(191, t); put_memory(mp, c=t); break;    // LD C,RES 6,(IX+d) // LD C,RES 6,(IY+d)
            case 0xb2: RES(191, t); put_memory(mp, d=t); break;    // LD D,RES 6,(IX+d) // LD D,RES 6,(IY+d)
            case 0xb3: RES(191, t); put_memory(mp, e=t); break;    // LD E,RES 6,(IX+d) // LD E,RES 6,(IY+d)
            case 0xb4: RES(191, t); put_memory(mp, h=t); break;    // LD H,RES 6,(IX+d) // LD H,RES 6,(IY+d)
            case 0xb5: RES(191, t); put_memory(mp, l=t); break;    // LD L,RES 6,(IX+d) // LD L,RES 6,(IY+d)
            case 0xb6: RES(191, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;       // RES 6,(IX+d) // RES 6,(IY+d)
            case 0xb7: RES(191, t); put_memory(mp, a=t); break;    // LD A,RES 6,(IX+d) // LD A,RES 6,(IY+d)
            case 0xb8: RES(127, t); put_memory(mp, b=t); break;    // LD B,RES 7,(IX+d) // LD B,RES 7,(IY+d)
            case 0xb9: RES(127, t); put_memory(mp, c=t); break;    // LD C,RES 7,(IX+d) // LD C,RES 7,(IY+d)
            case 0xba: RES(127, t); put_memory(mp, d=t); break;    // LD D,RES 7,(IX+d) // LD D,RES 7,(IY+d)
            case 0xbb: RES(127, t); put_memory(mp, e=t); break;    // LD E,RES 7,(IX+d) // LD E,RES 7,(IY+d)
            case 0xbc: RES(127, t); put_memory(mp, h=t); break;    // LD H,RES 7,(IX+d) // LD H,RES 7,(IY+d)
            case 0xbd: RES(127, t); put_memory(mp, l=t); break;    // LD L,RES 7,(IX+d) // LD L,RES 7,(IY+d)
            case 0xbe: RES(127, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;       // RES 7,(IX+d) // RES 7,(IY+d)
            case 0xbf: RES(127, t); put_memory(mp, a=t); break;    // LD A,RES 7,(IX+d) // LD A,RES 7,(IY+d)
            case 0xc0: SET(1, t); put_memory(mp, b=t); break;      // LD B,SET 0,(IX+d) // LD B,SET 0,(IY+d)
            case 0xc1: SET(1, t); put_memory(mp, c=t); break;      // LD C,SET 0,(IX+d) // LD C,SET 0,(IY+d)
            case 0xc2: SET(1, t); put_memory(mp, d=t); break;      // LD D,SET 0,(IX+d) // LD D,SET 0,(IY+d)
            case 0xc3: SET(1, t); put_memory(mp, e=t); break;      // LD E,SET 0,(IX+d) // LD E,SET 0,(IY+d)
            case 0xc4: SET(1, t); put_memory(mp, h=t); break;      // LD H,SET 0,(IX+d) // LD H,SET 0,(IY+d)
            case 0xc5: SET(1, t); put_memory(mp, l=t); break;      // LD L,SET 0,(IX+d) // LD L,SET 0,(IY+d)
            case 0xc6: SET(1, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;         // SET 0,(IX+d) // SET 0,(IY+d)
            case 0xc7: SET(1, t); put_memory(mp, a=t); break;      // LD A,SET 0,(IX+d) // LD A,SET 0,(IY+d)
            case 0xc8: SET(2, t); put_memory(mp, b=t); break;      // LD B,SET 1,(IX+d) // LD B,SET 1,(IY+d)
            case 0xc9: SET(2, t); put_memory(mp, c=t); break;      // LD C,SET 1,(IX+d) // LD C,SET 1,(IY+d)
            case 0xca: SET(2, t); put_memory(mp, d=t); break;      // LD D,SET 1,(IX+d) // LD D,SET 1,(IY+d)
            case 0xcb: SET(2, t); put_memory(mp, e=t); break;      // LD E,SET 1,(IX+d) // LD E,SET 1,(IY+d)
            case 0xcc: SET(2, t); put_memory(mp, h=t); break;      // LD H,SET 1,(IX+d) // LD H,SET 1,(IY+d)
            case 0xcd: SET(2, t); put_memory(mp, l=t); break;      // LD L,SET 1,(IX+d) // LD L,SET 1,(IY+d)
            case 0xce: SET(2, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;         // SET 1,(IX+d) // SET 1,(IY+d)
            case 0xcf: SET(2, t); put_memory(mp, a=t); break;      // LD A,SET 1,(IX+d) // LD A,SET 1,(IY+d)
            case 0xd0: SET(4, t); put_memory(mp, b=t); break;      // LD B,SET 2,(IX+d) // LD B,SET 2,(IY+d)
            case 0xd1: SET(4, t); put_memory(mp, c=t); break;      // LD C,SET 2,(IX+d) // LD C,SET 2,(IY+d)
            case 0xd2: SET(4, t); put_memory(mp, d=t); break;      // LD D,SET 2,(IX+d) // LD D,SET 2,(IY+d)
            case 0xd3: SET(4, t); put_memory(mp, e=t); break;      // LD E,SET 2,(IX+d) // LD E,SET 2,(IY+d)
            case 0xd4: SET(4, t); put_memory(mp, h=t); break;      // LD H,SET 2,(IX+d) // LD H,SET 2,(IY+d)
            case 0xd5: SET(4, t); put_memory(mp, l=t); break;      // LD L,SET 2,(IX+d) // LD L,SET 2,(IY+d)
            case 0xd6: SET(4, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;         // SET 2,(IX+d) // SET 2,(IY+d)
            case 0xd7: SET(4, t); put_memory(mp, a=t); break;      // LD A,SET 2,(IX+d) // LD A,SET 2,(IY+d)
            case 0xd8: SET(8, t); put_memory(mp, b=t); break;      // LD B,SET 3,(IX+d) // LD B,SET 3,(IY+d)
            case 0xd9: SET(8, t); put_memory(mp, c=t); break;      // LD C,SET 3,(IX+d) // LD C,SET 3,(IY+d)
            case 0xda: SET(8, t); put_memory(mp, d=t); break;      // LD D,SET 3,(IX+d) // LD D,SET 3,(IY+d)
            case 0xdb: SET(8, t); put_memory(mp, e=t); break;      // LD E,SET 3,(IX+d) // LD E,SET 3,(IY+d)
            case 0xdc: SET(8, t); put_memory(mp, h=t); break;      // LD H,SET 3,(IX+d) // LD H,SET 3,(IY+d)
            case 0xdd: SET(8, t); put_memory(mp, l=t); break;      // LD L,SET 3,(IX+d) // LD L,SET 3,(IY+d)
            case 0xde: SET(8, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;         // SET 3,(IX+d) // SET 3,(IY+d)
            case 0xdf: SET(8, t); put_memory(mp, a=t); break;      // LD A,SET 3,(IX+d) // LD A,SET 3,(IY+d)
            case 0xe0: SET(16, t); put_memory(mp, b=t); break;     // LD B,SET 4,(IX+d) // LD B,SET 4,(IY+d)
            case 0xe1: SET(16, t); put_memory(mp, c=t); break;     // LD C,SET 4,(IX+d) // LD C,SET 4,(IY+d)
            case 0xe2: SET(16, t); put_memory(mp, d=t); break;     // LD D,SET 4,(IX+d) // LD D,SET 4,(IY+d)
            case 0xe3: SET(16, t); put_memory(mp, e=t); break;     // LD E,SET 4,(IX+d) // LD E,SET 4,(IY+d)
            case 0xe4: SET(16, t); put_memory(mp, h=t); break;     // LD H,SET 4,(IX+d) // LD H,SET 4,(IY+d)
            case 0xe5: SET(16, t); put_memory(mp, l=t); break;     // LD L,SET 4,(IX+d) // LD L,SET 4,(IY+d)
            case 0xe6: SET(16, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;        // SET 4,(IX+d) // SET 4,(IY+d)
            case 0xe7: SET(16, t); put_memory(mp, a=t); break;     // LD A,SET 4,(IX+d) // LD A,SET 4,(IY+d)
            case 0xe8: SET(32, t); put_memory(mp, b=t); break;     // LD B,SET 5,(IX+d) // LD B,SET 5,(IY+d)
            case 0xe9: SET(32, t); put_memory(mp, c=t); break;     // LD C,SET 5,(IX+d) // LD C,SET 5,(IY+d)
            case 0xea: SET(32, t); put_memory(mp, d=t); break;     // LD D,SET 5,(IX+d) // LD D,SET 5,(IY+d)
            case 0xeb: SET(32, t); put_memory(mp, e=t); break;     // LD E,SET 5,(IX+d) // LD E,SET 5,(IY+d)
            case 0xec: SET(32, t); put_memory(mp, h=t); break;     // LD H,SET 5,(IX+d) // LD H,SET 5,(IY+d)
            case 0xed: SET(32, t); put_memory(mp, l=t); break;     // LD L,SET 5,(IX+d) // LD L,SET 5,(IY+d)
            case 0xee: SET(32, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;        // SET 5,(IX+d) // SET 5,(IY+d)
            case 0xef: SET(32, t); put_memory(mp, a=t); break;     // LD A,SET 5,(IX+d) // LD A,SET 5,(IY+d)
            case 0xf0: SET(64, t); put_memory(mp, b=t); break;     // LD B,SET 6,(IX+d) // LD B,SET 6,(IY+d)
            case 0xf1: SET(64, t); put_memory(mp, c=t); break;     // LD C,SET 6,(IX+d) // LD C,SET 6,(IY+d)
            case 0xf2: SET(64, t); put_memory(mp, d=t); break;     // LD D,SET 6,(IX+d) // LD D,SET 6,(IY+d)
            case 0xf3: SET(64, t); put_memory(mp, e=t); break;     // LD E,SET 6,(IX+d) // LD E,SET 6,(IY+d)
            case 0xf4: SET(64, t); put_memory(mp, h=t); break;     // LD H,SET 6,(IX+d) // LD H,SET 6,(IY+d)
            case 0xf5: SET(64, t); put_memory(mp, l=t); break;     // LD L,SET 6,(IX+d) // LD L,SET 6,(IY+d)
            case 0xf6: SET(64, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;        // SET 6,(IX+d) // SET 6,(IY+d)
            case 0xf7: SET(64, t); put_memory(mp, a=t); break;     // LD A,SET 6,(IX+d) // LD A,SET 6,(IY+d)
            case 0xf8: SET(128, t); put_memory(mp, b=t); break;    // LD B,SET 7,(IX+d) // LD B,SET 7,(IY+d)
            case 0xf9: SET(128, t); put_memory(mp, c=t); break;    // LD C,SET 7,(IX+d) // LD C,SET 7,(IY+d)
            case 0xfa: SET(128, t); put_memory(mp, d=t); break;    // LD D,SET 7,(IX+d) // LD D,SET 7,(IY+d)
            case 0xfb: SET(128, t); put_memory(mp, e=t); break;    // LD E,SET 7,(IX+d) // LD E,SET 7,(IY+d)
            case 0xfc: SET(128, t); put_memory(mp, h=t); break;    // LD H,SET 7,(IX+d) // LD H,SET 7,(IY+d)
            case 0xfd: SET(128, t); put_memory(mp, l=t); break;    // LD L,SET 7,(IX+d) // LD L,SET 7,(IY+d)
            case 0xfe: SET(128, t); put_memory(mp, t); if ( israbbit()) st -= 9; break;       // SET 7,(IX+d) // SET 7,(IY+d)
            case 0xff: SET(128, t); put_memory(mp, a=t); break;    // LD A,SET 7,(IX+d) // LD A,SET 7,(IY+d)
          }
        }
        ih=1;altd=0;ioi=0;ioe=0;break;
      case 0xed: // OP ED
        r++;
        switch( get_memory(pc++) ){
          case 0x02:    // (EZ80) LEA BC,IX+d
            if ( isez80() ) {
                LEA(b, c, xh, xl, 3);
            } else {
              st += 8;
            }
            break;
          case 0x03:    // (EZ80) LEA BC,IY+d
            if ( isez80() ) {
                LEA(b, c, yh, yl, 3);
            } else {
              st += 8;
            }
            break;
          case 0x04:    // (Z180) TST A,B
            if ( canz180() ) {
              TEST(b, isez80() ? 2 : 7);
            } else {
              st += 8;
            }
            break;
          case 0x07:    // (EZ80) ld bc,(hl)
            if ( isez80() ) {
              st += 4;
              c = get_memory((l|h<<8));
              b = get_memory((l|h<<8) + 1);
            } else {
              st += 8;
            }
            break;
          case 0x0c:    // (Z180) TST A,C
            if ( canz180() ) {
              TEST(c, isez80() ? 2 : 7);
            } else {
              st += 8;
            }
            break;
          case 0x0f:    // (EZ80) ld (hl),bc
            if ( isez80() ) {
              st += 4;
              put_memory((l|h<<8),c);
              put_memory((l|h<<8) + 1,b);
            } else {
              st += 8;
            }
            break;
          case 0x12:    // (EZ80) LEA DE,IX+d
            if ( isez80() ) {
                LEA(d, e, xh, xl, 3);
            } else {
              st += 8;
            }
            break;
          case 0x13:    // (EZ80) LEA DE,IY+d
            if ( isez80() ) {
                LEA(d, e, yh, yl, 3);
            } else {
              st += 8;
            }
            break;
          case 0x14:    // (Z180) TST A,D
            if ( canz180() ) {
              TEST(d, isez80() ? 2 : 7);
            } else {
              st += 8;
            }
            break;
          case 0x17:    // (EZ80) ld de,(hl)
            if ( isez80() ) {
              st += 4;
              e = get_memory((l|h<<8));
              d = get_memory((l|h<<8) + 1);
            } else {
              st += 8;
            }
            break;
          case 0x1c:    // (Z180) TST A,E
            if ( canz180() ) {
              TEST(e, isez80() ? 2 : 7);
            } else {
              st += 8;
            }
            break;
          case 0x1f:    // (EZ80) ld (hl),de
            if ( isez80() ) {
              st += 4;
              put_memory((l|h<<8),e);
              put_memory((l|h<<8) + 1,d);
            } else {
              st += 8;
            }
            break;
          case 0x22:    // (EZ80) LEA HL,IX+d
            if ( isez80() ) {
                LEA(h, l, xh, xl, 3);
            } else {
              st += 8;
            }
            break;
          case 0x23:    // (EZ80) LEA HL,IY+d, (ZXN) swapnib
            if ( isez80() ) {
                LEA(h, l, yh, yl, 3);
            } else if ( c_cpu == CPU_Z80N ) {
              a = (( a & 0xf0) >> 4) | (( a & 0x0f) << 4);
              st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x24:    // (Z180) TST A,D
            if ( canz180() ) {
              TEST(h, isez80() ? 2 : 7);
            } else if ( c_cpu == CPU_Z80N ) {   // (ZXN) mirror a
              a = mirror_table[a & 0x0f] << 4 | mirror_table[(a & 0xf0) >> 4];
              st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x28:    // (ZXN) bsla de,b
            if ( c_cpu == CPU_Z80N ) {
                int count;
                for ( count  = 0 ; count < (b & 0x0f); count++ ) {
                    SLA(e);
                    RL(d);
                }
                st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x29:    // (ZXN) bsra de,b
            if ( c_cpu == CPU_Z80N ) {
                int count;
                for ( count  = 0 ; count < (b & 0x0f); count++ ) {
                    SRA(d);
                    RR(e);
                }
                st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x2a:    // (ZXN) bsrl de,b
            if ( c_cpu == CPU_Z80N ) {
                int count;
                for ( count  = 0 ; count < (b & 0x0f); count++ ) {
                    SRL(d);
                    RR(e);
                }
                st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x2b:    // (ZXN) bsrf de,b
            if ( c_cpu == CPU_Z80N ) {
                int count;
                for ( count  = 0 ; count < (b & 0x0f); count++ ) {
                    RR(d);
                    d |= 128;
                    RR(e);
                }
                st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x2c:    // (Z180) TST A,E (ZXN) brlc de,b
            if ( canz180() ) {
              TEST(l, isez80() ? 2 : 7);
            } else if ( c_cpu == CPU_Z80N ) {
                int count;
                for ( count  = 0 ; count < (b & 0x07); count++ ) {
                    ff |= ( d & 128) ? 256 : 0;
                    RL(e);
                    RL(d);
                }
                st += 8;

            } else {
              st += 8;
            }
            break;
          case 0x2f:    // (EZ80) ld (hl),hl
            if ( isez80() ) {
              st += 4;
              put_memory((l|h<<8),l);
              put_memory((l|h<<8) + 1,h);
            } else {
              st += 8;
            }
            break;
          case 0x32:    // (EZ80) LEA IX,IX+d, (ZXN) add de,a
            if ( isez80() ) {
                LEA(xh, xl, xh, xl, 3);
            } else if ( c_cpu == CPU_Z80N ) {
              int16_t result = (( d * 256 ) + e) + a;
              d  = (result >> 8 ) & 0xff;
              e = result & 0xff;
              st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x33:    // (EZ80) LEA IY,IY+d, (ZXN) add bc,a
            if ( isez80() ) {
                LEA(yh, yl, yh, yl, 3);
            } else if ( c_cpu == CPU_Z80N ) {
              int16_t result = (( b * 256 ) + c) + a;
              b  = (result >> 8 ) & 0xff;
              c = result & 0xff;
              st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x3e:    // (EZ80) ld (hl),ix
            if ( isez80() ) {
              st += 4;
              put_memory((l|h<<8),xl);
              put_memory((l|h<<8) + 1,xh);
            } else {
              st += 8;
            }
            break;
          case 0x3f:    // (EZ80) ld (hl),iy
            if ( isez80() ) {
              st += 4;
              put_memory((l|h<<8),yl);
              put_memory((l|h<<8) + 1,yh);
            } else {
              st += 8;
            }
            break;
          case 0x64:    // (Z180) TST A,n
            if ( canz180() ) {
              uint8_t v = get_memory(pc++);
              TEST(v, isez80() ? 3 : 9);
            } else {    // Z80 (Undocumented NEG)
              st+= 8;
              fr= a= (ff= (fb= ~a)+1);
              fa= 0; break;
            }
            break;
          case 0x91:
            if ( c_cpu == CPU_Z80N ) {
              uint8_t v = get_memory(pc++);
              uint8_t r = get_memory(pc++);
              out(0x243b, v);
              out(0x253b, r);
              st += 16;
            } else {
              st+= 8; break;
            }
            break;
          case 0x92:
            if ( c_cpu == CPU_Z80N ) {
              uint8_t v = get_memory(pc++);
              out(0x243b, v);
              out(0x253b, a);
              st += 12;
            } else {
              st+= 8; break;
            }
            break;
          case 0x00: case 0x01:       // NOP
          case 0x05: case 0x06: 
          case 0x08: case 0x09: case 0x0a: case 0x0b:
          case 0x0d: case 0x0e: 
          case 0x10: case 0x11: 
          case 0x15: case 0x16: 
          case 0x18: case 0x19: case 0x1a: case 0x1b:
          case 0x1d: case 0x1e: 
          case 0x20: case 0x21:
          case 0x2d: case 0x2e: 
          case 0x77: case 0x7f:
          case 0x80: case 0x81: case 0x82: case 0x83:
          case 0x84: case 0x85: case 0x86: case 0x87:
          case 0x88: case 0x89: 
          case 0x8c: case 0x8d: case 0x8e: case 0x8f:
          case 0x90: case 0x93:
          case 0x94: case 0x95: case 0x96: case 0x97:
          case 0x98: case 0x99: case 0x9a: case 0x9b:
          case 0x9c: case 0x9d: case 0x9e: case 0x9f:
          case 0xa5: case 0xa6: case 0xa7:
          case 0xad: case 0xae: case 0xaf:
          case 0xb6: case 0xb7:
          case 0xbd: case 0xbe: case 0xbf:
          case 0xc0: case 0xc1: case 0xc2: case 0xc3:
          case 0xc4: case 0xc5: case 0xc6: case 0xc7:
          case 0xc8: case 0xc9: case 0xca: case 0xcb:
          case 0xcc: case 0xcd: case 0xce: case 0xcf:
          case 0xd0: case 0xd1: case 0xd2: case 0xd3:
          case 0xd4: case 0xd5: case 0xd6: case 0xd7:
          case 0xd8: case 0xd9: case 0xda: case 0xdb:
          case 0xdc: case 0xdd: case 0xde: case 0xdf:
          case 0xe0: case 0xe1: case 0xe2: case 0xe3:
          case 0xe4: case 0xe5: case 0xe6: case 0xe7:
          case 0xe8: case 0xe9: case 0xea: case 0xeb:
          case 0xec: case 0xed: case 0xee: case 0xef:
          case 0xf0: case 0xf1: case 0xf2: case 0xf3:
          case 0xf4: case 0xf5: case 0xf6: case 0xf7:
          case 0xf8: case 0xf9: case 0xfa: case 0xfb:
          case 0xfc: case 0xfd: case 0xff:
            st+= 8; break;
          case 0x26:                                         // (ZXN) mirror de
            if ( c_cpu != CPU_Z80N) { st += 8; break; }
#if 0
            t = (mirror_table[e & 0x0f] << 4) | mirror_table[(e & 0xf0) >> 4];
            e = d;
            d = t;
            e = (mirror_table[e & 0x0f] << 4) | mirror_table[(e & 0xf0) >> 4];
#endif
            st += 8;
            break;
          case 0x30:                                         // (ZXN) mul d,e
            if ( c_cpu == CPU_Z80N ) {
              int16_t result = d * e;
              d  = (result >> 8 ) & 0xff;
              e = result & 0xff;
              st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x31:                                         // (ZXN) add hl,a
            if ( c_cpu == CPU_Z80N ) {
              int16_t result = (( h * 256 ) + l) + a;
              h  = (result >> 8 ) & 0xff;
              l = result & 0xff;
              st += 8;
            } else {
              st += 8;
            }
            break;
          case 0x34:                                         // (ZXN) add hl,$xxxx
            if ( c_cpu == CPU_Z80N ) {
              uint8_t lsb = get_memory(pc++);
              uint8_t msb = get_memory(pc++);
              int16_t result = (( h * 256 ) + l) + ( lsb + msb * 256);
              h  = (result >> 8 ) & 0xff;
              l = result & 0xff;
              st += 16;
            } else if ( canz180() ) {			// (Z180/EZ80) TST A,(HL)
              uint8_t v = get_memory(l | h << 8);
              TEST(v, isez80() ? 3 : 10);
            } else {
              st += 8;
            }
            break;
          case 0x35:                                         // (ZXN) add de,$xxxx
            if ( c_cpu == CPU_Z80N ) {
              uint8_t lsb = get_memory(pc++);
              uint8_t msb = get_memory(pc++);
              int16_t result = (( d * 256 ) + e) + ( lsb + msb * 256);
              d  = (result >> 8 ) & 0xff;
              e = result & 0xff;
              st += 16;
            } else {
              st += 8;
            }
            break;
          case 0x36:                                         // (ZXN) add bc,$xxxx/ (EZ80) ld iy,(hl)
            if ( isez80() ) {
              st += 4;
              yl = get_memory((l|h<<8));
              yh = get_memory((l|h<<8) + 1);
            } else if ( c_cpu == CPU_Z80N ) {
              uint8_t lsb = get_memory(pc++);
              uint8_t msb = get_memory(pc++);
              int16_t result = (( b * 256 ) + c) + ( lsb + msb * 256);
              b = (result >> 8 ) & 0xff;
              c = result & 0xff;
              st += 16;
            } else {
              st += 8;
            }
            break;
          case 0x25:                                        
            st += 8;
            break;
          case 0x37:                                         // (ZXN) inc dehl / (EZ80) ld ix,(hl)
            if ( isez80() ) {
              st += 4;
              xl = get_memory((l|h<<8));
              xh = get_memory((l|h<<8) + 1);
            } else {
              st += 8;
            }
            break;
          case 0x38:                                         // (ZXN) dec dehl
            st += 8;
            break;
          case 0x39:                                         // (ZXN) add dehl,a
            st += 8;
            break;
          case 0x3A:                                         // (ZXN) add dehl,bc
            st += 8;
            break;
          case 0x3B:                                         // (ZXN) add dehl,$XXXX
            st += 8;
            break;
          case 0x3C:                                         // (ZXN) sub dehl,a
            if ( canz180()) {                                // (Z180) TST A,A
              TEST(a, isez80() ? 2 : 7);
            } else {
              st += 8;
            }
            break;
          case 0x3D:                                         // (ZXN) sub dehl,bc
            st += 8;
            break;
          case 0x8a:                                         // (ZXN) push $xxxx
            if ( c_cpu == CPU_Z80N ) {
              uint8_t lsb = get_memory(pc++);
              uint8_t msb = get_memory(pc++);
              PUSH(msb,lsb);
              st += 19  ;
            } else {
              st += 8;
            }
            break;
          case 0x8b:                                         // (ZXN) popx
            st += 8;
            break;
          case 0x27:                                         // (ZXN) tst $xx (EZ80) ld hl,(hl)
            if ( isez80() ) {
              unsigned char tl;
              st += 4;
              tl = get_memory((l|h<<8));
              h = get_memory((l|h<<8) + 1);
              l = tl;
            } else if ( c_cpu == CPU_Z80N ) {
              uint8_t v = get_memory(pc++);
              TEST(v, 7);
              st += 11;
            } else {
              st += 8;
            }
            break;
          case 0xa4:                                        // (ZXN) ldix
            if ( c_cpu != CPU_Z80N ) { st+= 8; break; }
            st += 16;
            t = get_memory(l | h<<8);
            if ( t != a ) {
              put_memory(e | d<<8, t= get_memory(l | h<<8));
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
            b|c && (st += 5, fa= 128);
            fb= fa; break;
          case 0xac:                                       // (ZXN) lddx
            if ( c_cpu != CPU_Z80N ) { st+= 8; break; }
            t = get_memory(l | h<<8);
            st += 16;
            if ( t != a ) {
                put_memory(e | d<<8, t= get_memory(l | h<<8));
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
            b|c && (st += 5, fa= 128);
            fb= fa; break;
          case 0xb4:                                        // (ZXN) ldirx
            if ( c_cpu != CPU_Z80N ) { st+= 8; break; }
            t = get_memory(l | h<<8);
            st += 16;
            if ( t != a ) {
                put_memory(e | d<<8, t= get_memory(l | h<<8));
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
                     st+= 5,
                     mp= --pc,
                            --pc);
                   fb= fa; break;
          case 0xb5:                                         // (ZXN) fillde
            st += 8; break;
          case 0xbc:                                         // (ZXN) LDDRX
            if ( c_cpu != CPU_Z80N ) { st+= 8; break; }
            t = get_memory(l | h<<8);
            st += 16;
            if ( t != a ) {
                put_memory(e | d<<8, t= get_memory(l | h<<8));
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
                     st+= 5,
                     mp= --pc,
                     --pc);
            fb= fa; break;
          case 0xfe: PatchZ80(); break;
          case 0x40: INR(b); break;                          // IN B,(C)
          case 0x48: INR(c); break;                          // IN C,(C)
          case 0x50: INR(d); break;                          // IN D,(C)
          case 0x58: INR(e); break;                          // IN E,(C)
          case 0x60: INR(h); break;                          // IN H,(C)
          case 0x68: INR(l); break;                          // IN L,(C)
          case 0x70: INR(t); break;                          // IN X,(C)
          case 0x78: INR(a); break;                          // IN A,(C)
          case 0x41:                                         // OUT (C),B (RCM) LD BC',DE
            if ( israbbit()) {
                b_ = d;
                c_ = e;
                st += 4;
            } else {
              OUTR(b);
            } 
            break;                        
          case 0x49:                                         // OUT (C),C (RCM) LD BC',BC
            if ( israbbit()) {
                b_ = b;
                c_ = c;
                st += 4;
            } else {
              OUTR(c);
            }
            break;
          case 0x51:                                         // OUT (C),D (RCM) LD DE',DE
            if ( israbbit()) {
                d_ = d;
                e_ = e;
                st += 4;
            } else {
              OUTR(d);
            }
            break;
          case 0x59:                                         // OUT (C),E (RCM) LD DE',BC
            if ( israbbit()) {
                d_ = b;
                e_ = c;
                st += 4;
            } else {
              OUTR(e);
            }
            break;
          case 0x61:                                         // OUT (C),H (RCM) LD HL',DE
            if ( israbbit()) {
                h_ = d;
                l_ = e;
                st += 4;
            } else {
              OUTR(h);
            }
            break;          
          case 0x69:                                         // OUT (C),EL(RCM) LD HL',BC
            if ( israbbit()) {
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
          case 0x7a: st+=isez80() ? 2 : israbbit() ? 4 : isz180() ? 10 : 15;                                // ADC HL,SP
                     v= (mp= l|h<<8)+sp+(ff>>8&1);
                     ++mp;
                     ff= v>>8;
                     fa= h;
                     fb= sp>>8;
                     h= ff;
                     l= v;
                     fr= h | l<<8; break;
          case 0x43: LDPNNRR(b, c, isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : 20); break;               // LD (NN),BC
          case 0x53: LDPNNRR(d, e, isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : 20); break;               // LD (NN),DE
          case 0x63: LDPNNRR(h, l, isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : 20); break;               // LD (NN),HL
          case 0x73: st+= isez80() ? 6 : israbbit() ? 15 : isz180() ? 19 : 20;                                // LD (NN),SP
                     mp= get_memory(pc++);
                     put_memory(mp|= get_memory(pc++)<<8, sp);
                     put_memory(++mp,sp>>8); break;
          case 0x4b: LDRRPNN(b, c, isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : 20); break;               // LD BC,(NN)
          case 0x5b: LDRRPNN(d, e, isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : 20); break;               // LD DE,(NN)
          case 0x6b: LDRRPNN(h, l, isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : 20); break;               // LD HL,(NN)
          case 0x7b: st+= isez80() ? 6 : israbbit() ? 13 : isz180() ? 18 : 20;                                // LD SP,(NN)
                     t= get_memory(pc++);
                     sp= get_memory(t|= get_memory(pc++)<<8);
                     sp|= get_memory(mp= t+1) << 8; break;
          case 0x4c:                                         // (Z180) MLT BC
            if ( canz180() ) {
              uint16_t v = b * c;
              b = v >> 8;
              c = v;
              st += isez80() ? 6 : 17;
            } else {  // (Z80) Undocumented NEG
                st+= 8;
                fr= a= (ff= (fb= ~a)+1);
                fa= 0;
            }
            break;
          case 0x5c:                                         // (Z180) MLT DE
            if ( canz180() ) {
              uint16_t v = d * e;
              d = v >> 8;
              e = v;
              st += isez80() ? 6 : 17;
            } else {  // (Z80) Undocumented NEG
                st+= 8;
                fr= a= (ff= (fb= ~a)+1);
                fa= 0;
            }
            break;
          case 0x6c:                                         // (Z180) MLT HL
            if ( canz180() ) {
              uint16_t v = h * l;
              h = v >> 8;
              l = v;
              st += isez80() ? 6 : 17;
            } else {  // (Z80) Undocumented NEG
                st+= 8;
                fr= a= (ff= (fb= ~a)+1);
                fa= 0;
            }
            break;
          case 0x54:	// (RCM) ex (sp),hl,  (EZ80) LEA IX,IY+d
            if ( israbbit()) {
              EXSPI(h, l);
              st += 2;
              break;
            } else if ( isez80() ) {
                LEA(xh, xl, yh, yl, 3);
                break;
            }
            // Fall through for z80 case
          case 0x44:       // NEG
          case 0x74: case 0x7c:
                     st+= 8;
                     fr= a= (ff= (fb= ~a)+1);
                     fa= 0; break;
          case 0x55:    // (EZ80) LEA IX,IX+d
            if ( isez80() ) {
                LEA(xh, xl, xh, xl, 3);
                break;
            }
            // Fall through for z80 case
          case 0x65:    // (EZ80) PEA ix+d
            if ( isez80() ) { 
               uint16_t tv = ((get_memory(pc++)^128)-128+(xl|xh<<8))&65535;
               st += 5;
               put_memory(--sp, tv / 256);
               put_memory(--sp, tv % 256);
               break;
            }
            // Fall through
          case 0x45: case 0x4d: case 0x5d:        // RETI // RETN
          case 0x6d: case 0x75: case 0x7d:
                     RET(israbbit() ? 12 : 14); break;
          case 0x66:    // (EZ80) PEA iy+d
            if (isez80() ) { 
               uint16_t tv = ((get_memory(pc++)^128)-128+(yl|yh<<8))&65535;
               st += 5;
               put_memory(--sp, tv / 256);
               put_memory(--sp, tv % 256);
               break;
            }
            // Fall through
          case 0x46: case 0x4e: case 0x6e:        // IM 0
                     st+= 8; im= 0; break;
          case 0x56: case 0x76:                              // IM 1
                     st+= 8; im= 1; break;
          case 0x5e: case 0x7e:                              // IM 2
                     st+= 8; im= 2; break;
          case 0x47: LDRR(i, a, i, israbbit() ? 4 : 9); break;                   // LD I,A
          case 0x4f: LDRR(r, a, r, israbbit() ? 4 : 9); r7= r; break;            // LD R,A
          case 0x57: st += israbbit() ? 4 : 9;                                 // LD A,I
                     ff=  ff&-256
                        | (a= i);
                     fr= !!a;
                     fa= fb= iff<<7 & 128; break;
          case 0x5f: st += israbbit() ? 4 : 9;                                     // LD A,R
                     ff=  ff&-256
                        | (a= (r&127|r7&128));
                     fr= !!a;
                     fa= fb= iff<<7 & 128; break;
          case 0x67: st+= 18;                                // RRD
                     t= get_memory(mp= l|h<<8)
                      | a<<8;
                     a= (a &240)
                      | (t & 15);
                     ff=  ff&-256
                        | (fr= a);
                     fa= a|256;
                     fb= 0;
                     put_memory(mp++,t>>4); break;
          case 0x6f: st+= 18;                                // RLD
                     t= get_memory(mp= l|h<<8)<<4
                      | (a&15);
                     a= (a &240)
                      | t>>8;
                     ff=  ff&-256
                        | (fr= a);
                     fa= a|256;
                     fb= 0;
                     put_memory(mp++,t); break;
          case 0xa0: st+= israbbit() ? 10 :  16;                               // LDI
                     put_memory(e | d<<8, t= get_memory(l | h<<8));
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
                     fb= fa; break;
          case 0xa8: st+= israbbit() ? 10 :  16;                                // LDD
                     put_memory(e | d<<8, t= get_memory(l | h<<8));
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
                     fb= fa; break;
          case 0xb0: st+= israbbit() ? 7 :  16;                                // LDIR
                     put_memory(e | d<<8, t= get_memory(l | h<<8));
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
                              st+= israbbit() ? 6 :  5,
                              mp= --pc,
                              --pc);
                     fb= fa; break;
          case 0xb8: st+= israbbit() ? 7 : 16;                                // LDDR
                     put_memory(e | d<<8, t= get_memory(l | h<<8));
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
                              st+= israbbit() ? 6 : 5,
                              mp= --pc,
                              --pc);
                     fb= fa; break;
          case 0xa1: st+= 16;                                // CPI
                     w= a-(t= get_memory(l|h<<8));
                     ++l || h++;
                     c-- || b--;
                     ++mp;
                     fr=  w & 127
                        | w>>7;
                     fb= ~(t|128);
                     fa= a&127;
                     b|c && ( fa|= 128,
                              fb|= 128);
                     ff=  ff  & -256
                        | w   &  -41;
                    (w^t^a) & 16 && w--;
                    ff|= w<<4 & 32
                       | w    &  8; break;
          case 0xa9: st+= 16;                                // CPD
                     w= a-(t= get_memory(l|h<<8));
                     l-- || h--;
                     c-- || b--;
                     --mp;
                     fr=  w & 127
                        | w>>7;
                     fb= ~(t|128);
                     fa= a&127;
                     b|c && ( fa|= 128,
                              fb|= 128);
                     ff=  ff  & -256
                        | w   &  -41;
                    (w^t^a) & 16 && w--;
                    ff|= w<<4 & 32
                       | w    &  8; break;
          case 0xb1: st+= 16;                                // CPIR
                     w= a-(t= get_memory(l|h<<8));
                     ++l || h++;
                     c-- || b--;
                     ++mp;
                     fr=  w & 127
                        | w>>7;
                     fb= ~(t|128);
                     fa= a&127;
                     b|c && ( fa|= 128,
                              fb|= 128,
                              w && (st+= 5, mp=--pc, --pc));
                     ff=  ff  & -256
                        | w   &  -41;
                    (w^t^a) & 16 && w--;
                    ff|= w<<4 & 32
                       | w    &  8; break;
          case 0xb9: st+= 16;                                // CPDR
                     w= a-(t= get_memory(l|h<<8));
                     l-- || h--;
                     c-- || b--;
                     --mp;
                     fr=  w & 127
                        | w>>7;
                     fb= ~(t|128);
                     fa= a&127;
                     b|c && ( fa|= 128,
                              fb|= 128,
                              w && (st+= 5, mp=--pc, --pc));
                     ff=  ff  & -256
                        | w   &  -41;
                    (w^t^a) & 16 && w--;
                    ff|= w<<4 & 32
                       | w    &  8; break;
          case 0xa2: st+= 16;                                // INI
                     put_memory(l | h<<8,t= in(mp= c | b<<8));
                     ++l || h++;
                     ++mp;
                     u= t+(c+1&255);
                     --b;
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xaa: st+= 16;                                // IND
                     put_memory(l | h<<8, t= in(mp= c | b<<8));
                     l-- || h--;
                     --mp;
                     u= t+(c-1&255);
                     --b;
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xb2: st+= 16;                                // INIR
                     put_memory(l | h<<8, t= in(mp= c | b<<8));
                     ++l || h++;
                     ++mp;
                     u= t+(c+1&255);
                     --b && (st+= 5, mp= --pc, --pc);
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xba: st+= 16;                                // INDR
                     put_memory(l | h<<8, t= in(mp= c | b<<8));
                     l-- || h--;
                     --mp;
                     u= t+(c-1&255);
                     --b && (st+= 5, mp= --pc, --pc);
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xa3: st+= 16;                                // OUTI
                     --b;
                     out( mp= c | b<<8,
                          t = get_memory(l | h<<8));
                     ++mp;
                     ++l || h++;
                     u= t+l;
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xab: st+= 16;                                // OUTD
                     --b;
                     out( mp= c | b<<8,
                          t = get_memory(l | h<<8));
                     --mp;
                     l-- || h--;
                     u= t+l;
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xb3: st+= 16;                                // OTIR
                     --b;
                     out( mp= c | b<<8,
                          t = get_memory(l | h<<8));
                     ++mp;
                     ++l || h++;
                     u= t+l;
                     b && (st+= 5, mp= --pc, --pc);
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
          case 0xbb: st+= 16;                                // OTDR
                     --b;
                     out( mp= c | b<<8,
                          t = get_memory(l | h<<8));
                     --mp;
                     l-- || h--;
                     u= t+l;
                     b && (st+= 5, mp= --pc, --pc);
                     fb= u&7^b;
                     ff= b | (u&= 256);
                     fa= (fr= b)^128;
                     fb=  (4928640>>((fb^fb>>4)&15)^b)&128
                        | u>>4
                        | (t&128)<<2; break;
        }
        ih=1;altd=0;ioi=0;ioe=0;//break;
    }
  } while ( pc != end && st < counter  );
  if ( alarmtime != 0 ) {
      /* We running as a test, we should never reach the end, so exit with error */
      exit(1);
  }
  if( tap && st>sttap )
    sttap= st+( tap= tapcycles() );
  if ( counter != -1 )
    printf("%llu\n", st);
  if( output ){
    fh= fopen(output, "wb+");
    if( !fh )
      printf("\nCannot create or write in file: %s\n", output),
      exit(-1);
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
      fwrite(get_memory_addr(0x4000), 1, 0xc000, fh);
    else if ( !strcasecmp(strchr(output, '.'), ".scr" ) )
      fwrite(get_memory_addr(0x4000), 1, 0x1b00, fh);
    else{
      fwrite(get_memory_addr(0), 1, 65536, fh);
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
