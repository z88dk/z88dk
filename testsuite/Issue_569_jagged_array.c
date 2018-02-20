//unsigned char starField[12][64];

unsigned char _starField[12*64];

unsigned char *starField[12] = {
    &_starField[0],   // every 64 elements
    &_starField[64],
    &_starField[128],
    &_starField[192],
    &_starField[256],
    &_starField[320],
    &_starField[384],
    &_starField[448],
    &_starField[512],
    &_starField[576],
    &_starField[640],
    &_starField[704],
};

void main(void)
{
    unsigned char i,j;
    
    starField[2][20] = 10;
    
    for (i=0; i!=12; ++i)
        for (j=0; j!=64; ++j)
            starField[i][j] = 12;
}


