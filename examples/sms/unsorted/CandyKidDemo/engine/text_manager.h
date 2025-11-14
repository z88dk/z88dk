#ifndef _TEXT_MANAGER_H_
#define _TEXT_MANAGER_H_

void engine_text_manager_draw()
{
	unsigned char move;

	engine_font_manager_draw_text(LOCALE_TITLE1, 8, 11);
	engine_font_manager_draw_text(LOCALE_TITLE2, 8, 12);

	engine_font_manager_draw_text(LOCALE_SIDE1, 24, 0);
	engine_font_manager_draw_text(LOCALE_SIDE2, 24, 1);

	move = 4;
	engine_font_manager_draw_text(LOCALE_MOVE0, 24, move + 0);
	engine_font_manager_draw_text(LOCALE_MOVE1, 24, move + 1);
	engine_font_manager_draw_text(LOCALE_MOVE2, 24, move + 2);
	engine_font_manager_draw_text(LOCALE_MOVE3, 24, move + 3);
	engine_font_manager_draw_text(LOCALE_MOVE4, 24, move + 4);
	engine_font_manager_draw_text(LOCALE_MOVE5, 24, move + 5);

	move += 4;
	engine_font_manager_draw_text(LOCALE_MOVE6, 24, move + 6);
	engine_font_manager_draw_text(LOCALE_MOVE7, 24, move + 7);

	move++;
	engine_font_manager_draw_text(LOCALE_MOVE8, 24, move + 8);
	engine_font_manager_draw_text(LOCALE_MOVE9, 24, move + 9);

	engine_font_manager_draw_text(LOCALE_STEVEPRO1, 24, 22);
	engine_font_manager_draw_text(LOCALE_STEVEPRO2, 24, 23);
}

void engine_text_manager_names()
{
	engine_font_manager_draw_text(LOCALE_NAME1, 3, 7);
	engine_font_manager_draw_text(LOCALE_NAME2, 3, 21);
	engine_font_manager_draw_text(LOCALE_NAME3, 17, 7);
	engine_font_manager_draw_text(LOCALE_NAME4, 17, 21);
}

void engine_text_manager_space()
{
	engine_font_manager_draw_text(LOCALE_SPACE, 3, 7);
	engine_font_manager_draw_text(LOCALE_SPACE, 3, 21);
	engine_font_manager_draw_text(LOCALE_SPACE, 17, 7);
	engine_font_manager_draw_text(LOCALE_SPACE, 17, 21);
}

#endif//_TEXT_MANAGER_H_