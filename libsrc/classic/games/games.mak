GAMES_NEWLIBGLOBS := "sound/bit/z80/asm_bit_beepfx/*.asm"
GAMES_NEWLIBGLOBS_ex := sound/bit/z80/asm_bit_beepfx/*.asm


GAMES_NEWLIB_TARGETS := classic/games/obj/newlib-z80-classic-games \
	classic/games/obj/newlib-z80n-classic-games \
	classic/games/obj/newlib-z80n-classic-games \
	classic/games/obj/newlib-r2ka-classic-games \
	classic/games/obj/newlib-ixiy-classic-games \
	classic/games/obj/newlib-8080-classic-games \
	classic/games/obj/newlib-8085-classic-games \
	classic/games/obj/newlib-gbz80-classic-games \
	classic/games/obj/newlib-z180-classic-games \
	classic/games/obj/newlib-ez80_z80-classic-games

OBJS += $(GAMES_NEWLIB_TARGETS)
CLEAN += games-clean

games: $(GAMES_NEWLIB_TARGETS)

.PHONY: games games-clean

$(eval $(call buildnew,classic/games,z80,-mz80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,r2ka,-mr2ka,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,z80n,-mz80n,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,ixiy,-IXIY,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,8080,-m8080,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,8085,-m8085,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,gbz80,-mgbz80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,z180,-mz180,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,ez80_z80,-mez80_z80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))

games-clean: 
	$(RM) -fr classic/games/obj
