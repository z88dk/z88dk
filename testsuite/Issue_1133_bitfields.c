struct {
        signed int      a:11;
        signed int      :5;
        int     b:3;
        int     c:5;
        char    *ptr;
} x = { -1, 3, 15, "hello" };

struct {
	int	a:8;
} y;


int main()  {
        int     z;
        x.a = -1;
        x.b = 2;
        x.c = 3;

        z = sizeof(x);
        z = x.a;
        return z;
}

int func2() {
	y.a = 1;
}
