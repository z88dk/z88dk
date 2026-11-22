#ifndef _TREE_MANAGER_H_
#define _TREE_MANAGER_H_

void engine_tree_manager_draw();

void engine_tree_manager_draw_treeXY(unsigned char x, unsigned char y)
{
	const unsigned int *pnt = tree__tilemap__bin;

	SMS_setNextTileatXY(x+0, y+0); 	SMS_setTile (*pnt + 0);
	SMS_setNextTileatXY(x+1, y+0); 	SMS_setTile (*pnt + 1);
	SMS_setNextTileatXY(x+0, y+1); 	SMS_setTile (*pnt + 2);
	SMS_setNextTileatXY(x+1, y+1); 	SMS_setTile (*pnt + 3);
}

void engine_tree_manager_draw_border()
{
	unsigned char tx = 0;
	unsigned char ty = 0;
	for (tx=0; tx<24; tx+=2)
	{
		engine_tree_manager_draw_treeXY(tx, 0);
		engine_tree_manager_draw_treeXY(tx, 22);
	}
	for (ty=2; ty<22; ty+=2)
	{
		engine_tree_manager_draw_treeXY(0, ty);
		engine_tree_manager_draw_treeXY(22, ty);
	}
}

void engine_tree_manager_draw_inside()
{
	unsigned char tx = 0;
	unsigned char ty = 0;
	for (tx=6; tx<18; tx+=2)
	{
		engine_tree_manager_draw_treeXY(tx, 8);
		engine_tree_manager_draw_treeXY(tx, 14);
	}
	for (ty=10; ty<14; ty+=2)
	{
		engine_tree_manager_draw_treeXY(6, ty);
		engine_tree_manager_draw_treeXY(16, ty);
	}
}

void engine_tree_manager_draw()
{
	engine_tree_manager_draw_border();
	engine_tree_manager_draw_inside();
}

#endif//_TREE_MANAGER_H_