
typedef unsigned char  type8;
typedef signed   char  type8s;
typedef unsigned int   type16;
typedef signed   int   type16s;
typedef unsigned long  type32;
typedef signed   long  type32s;

extern unsigned int __LIB__ intrinsic_swap_endian_16(unsigned int n) __smallc __z88dk_fastcall;


type32 pc;

type8 *effective(type32 ptr) __z88dk_fastcall;

void branch(type8 b) __z88dk_fastcall
{
    if (b == 0) {
        pc +=  (type16s)  (intrinsic_swap_endian_16(*(type16 *)( effective(pc) ))) ;
    } else {
        pc += (type8s) b;
    }
}
