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

struct {
	int	a:16;
} z = { 32768};

int func3() {
	z.a = 3;
	return sizeof(z);
}

struct {
	int	a:2;
	signed int b:3;
} t4 = { 2, 3 };

int func4() {
	t4.a = 2;
	t4.b = 2;
	return sizeof(t4);
}
