

struct test {
    char   c[10];
    int    x;
    int    y;
};


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

