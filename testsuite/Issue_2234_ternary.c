

int testfunc();
void blah();
void another(int);

int varassign_direct_nonconst()
{
    int val = testfunc() > 0 ? 2 : 1;
    blah();
}

int varassign_direct_nonconst2()
{
    int val = testfunc() ? 2 : 1;
    blah();
}

int varassign_direct_const_true()
{
    int val = 10  ? 2 : 1;
    blah();
}

int varassign_direct_const_false()
{
    int val = 0 ? 2 : 1;
    blah();
}

int varassign_direct_const_non_true()
{
    int val = 10  ? testfunc() : 1;
    blah();
}

int varassign_direct_const_non_false()
{
    int val = 0 ? 2 : testfunc();;
    blah();
}

int call_const_true()
{
    another(10 ? 2 : 1);
}


int call_const_false()
{
    another(0 ? 2 : 1);
}

int varassign_indirect_const_true()
{
    int val;
    blah();
    val  = 10  ? 2 : 1;
    another(100);
}

int varassign_indirect_const_false()
{
    int val;
    blah();
    val  = 0 ? 2 : 1;
    another(100);
}
