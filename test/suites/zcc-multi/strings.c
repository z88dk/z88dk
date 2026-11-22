const char *msgs[] = { "alpha-unique", "beta-unique" };

int foo(void)
{
    return msgs[0][0];
}

int bar(const char *s)
{
    return s[0];
}

int main(void)
{
    return bar("alpha-unique") + foo();
}
