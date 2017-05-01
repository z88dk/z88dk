

void far_pointer_cast()
{
     char   *ptr = 0;
     long    n;

     n = *(far long *)ptr;
}

void far_pointer_cast2()
{
     char   *ptr = 0;
     long    n;

     n = *(far int *)ptr;
}

void far_pointer_cast3()
{
     far char   *ptr = 0;
     long    n;

     n = *(long *)ptr;
}


struct x {
    long val;
};


void *struct_cast()
{
     long *ptr = 0;
     struct x *st;

     st = (struct x *)ptr;
     return st;
}

#define SMS_PNTAddress            0x7800
#define XYtoADDR(x,y)             (SMS_PNTAddress|((unsigned int)(y)<<6)|((unsigned char)(x)<<1))
#define SMS_setNextTileatXY(x,y)  SMS_setAddr(XYtoADDR((x),(y)))

extern void SMS_setTile(unsigned int addr) __z88dk_fastcall;

void writetext(unsigned char *text,unsigned char x, unsigned char y)
{
	SMS_setNextTileatXY (x,y);
}
