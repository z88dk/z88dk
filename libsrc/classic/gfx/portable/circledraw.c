


void circledraw(int x0, int y0, int radius, int skip, void (*pixel)(int x,int y)) __stdc
{
    int x = radius;
    int y = 0;
    int err = 0;

    while (x >= y) {
        pixel(x0 + x, y0 + y);
        pixel(x0 + y, y0 + x);
        pixel(x0 - y, y0 + x);
        pixel(x0 - x, y0 + y);
        pixel(x0 - x, y0 - y);
        pixel(x0 - y, y0 - x);
        pixel(x0 + y, y0 - x);
        pixel(x0 + x, y0 - y);

        if (err <= 0) {
            y += skip;
            err += 2*y + 1;
        }

        if (err > 0) {
            x -= skip;
            err -= 2*x + 1;
        }
    }
}
