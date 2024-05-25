extern __banked char arr[];

extern void func2(char *__far ptr);

extern __banked int i;
extern __banked char *cptr;

void array_degrade()
{
        int     j;

        func2(&arr[10]);
}

int int_arith(int j)
{
   return i + j;
}

extern void intfunc(int *__far ptr);

void int_ptr(int j)
{
    intfunc(&i);
}

char getptr()
{
    return *cptr;
}
