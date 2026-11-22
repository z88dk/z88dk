int g;

int foo(int a, int b)
{
    return a + b + a + b;
}

int bar(int n)
{
    int s = 0;
    int i;
    for (i = 0; i < n; ++i)
        s += i;
    return s;
}

int main(void)
{
    g = foo(1, 2);
    return bar(g);
}
