#include <stdio.h>
#include <font/font.h>

void print(const char *name, void *font);

int main() {
    printf("%c%c\n",1,32);
    print("default", (void *)15616);
    print("font_8x8_bbc_system", font_8x8_bbc_system);
    print("font_8x8_c64_system", font_8x8_c64_system);
    getchar();
    printf("%c\n",12);
    print("font_8x8_clairsys", font_8x8_clairsys);
    print("font_8x8_clairsys_bold", font_8x8_clairsys_bold);
    print("font_8x8_cpc_system", font_8x8_c64_system);
    getchar();
    printf("%c\n",12);
    print("font_8x8_vga_rom", font_8x8_vga_rom);
    print("font_8x8_zx_system", font_8x8_zx_system);

    getchar();
    printf("%c\n",12);
    printf("%c%c\n",1,64);
    print("font_4x8_64_minix", font_4x8_64_minix);
    print("font_4x8_64_nbot", font_4x8_64_nbot);
    print("font_4x8_64_omni1", font_4x8_64_omni1);
    print("font_4x8_64_omni2", font_4x8_64_omni2);
    print("font_4x8_64_owen", font_4x8_64_owen);
    getchar();
    printf("%c\n",12);
    print("font_4x8_80columns", font_4x8_80columns);
    print("font_4x8_color80", font_4x8_color80);
    print("font_4x8_default", font_4x8_default);
    print("font_4x8_highspeed80", font_4x8_highspeed80);
    print("font_4x8_screen80", font_4x8_screen80);
    getchar();

}


void print(const char *name, void *font)
{
    printf("%c%c%c",2, font / 256, font % 256 );
    printf("This is font %s\n",name);

    for ( int i = 32 ; i < 128; i++ ) {
        printf("%c",i);
    }
    printf("\n\n");
}
