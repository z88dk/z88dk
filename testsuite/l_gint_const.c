struct v
{
    char a;
    char b;
    char c;
    char d;
    char e;
    char f;
};

struct v2
{
    int a;
    int b;
    int c;
    int d;
    int e;
    int f;
};

void check1(int a, int b, int c, int d)
{
    return a * 2 + b * 3 + c * 4 + d * 5;
}

void check_gchar(struct v* vv)
{
    int a = vv->a + vv->b + vv->c + vv->d + vv->e + vv->f;
}

void check_gint(struct v2* vv)
{
    int a = vv->a + vv->b + vv->c + vv->d + vv->e + vv->f;
}
