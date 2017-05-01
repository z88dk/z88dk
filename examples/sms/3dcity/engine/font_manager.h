#ifndef _FONT_MANAGER_H_
#define _FONT_MANAGER_H_

#define MAX_LENGTH		5

void engine_font_manager_load();
void engine_font_manager_draw_text(unsigned char* text, unsigned char x, unsigned char y);
void engine_font_manager_draw_data(unsigned int data, unsigned char x, unsigned char y);
void engine_font_manager_draw_score(unsigned int data, unsigned char x, unsigned char y);

#endif//_FONT_MANAGER_H_
