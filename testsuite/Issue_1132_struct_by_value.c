

struct test {
    char   c[10];
    int    x;
    int    y;
};

static struct test x;
static struct test y;
static struct test *z;

void func_global_assign() 
{
    x = y;
}

void func_global_assign_to_pointer() 
{
    *z = y;
}

void func_global_assign_from_pointer() 
{
    x = *z;
}

void func_local_assign() 
{
    struct test a;
    struct test b;

    a = b;
}

void func_local_assign_to_pointer() 
{
    struct test a;
    struct test *b;

    *b = a;
}


void func_local_assign_from_pointer() 
{
    struct test a;
    struct test *b;

    a = *b;
}

