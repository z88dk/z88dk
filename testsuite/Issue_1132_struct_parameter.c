


struct test {
    char   c[10];
    int    x;
    int    y;
};

typedef void *(*fptr)(struct test x);

static fptr fnptr;

void func(struct test x, int y)
{
    x.x = 10;
}

void func_callee(struct test x, int y) __z88dk_callee
{
    x.x = 10;
}


void func_calling(void)
{
    struct test a;

    func(a, 10);
}


void func_fptr(void)
{
    struct test a;

    fnptr(a);
}
