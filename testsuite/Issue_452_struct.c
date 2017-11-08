
typedef struct {
  unsigned long i[2];
  unsigned long buf[4];
  unsigned char in[64];
  unsigned char digest[16];
} MD5_CTX;


void func1()
{
        MD5_CTX *ctx = 0;

        ctx->i[1] = 1;
}

void func2()
{
        static MD5_CTX *ctx = 0;

        ctx->i[1] = 1;
}

void func3()
{
        MD5_CTX ctx;

        ctx.i[1] = 1;
}
