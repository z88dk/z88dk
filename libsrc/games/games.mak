GAMES_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/sound/bit/z80/asm_bit_beepfx/*.asm"
GAMES_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/sound/bit/z80/asm_bit_beepfx/*.asm


GAMES_NEWLIB_TARGETS := games/obj/newlib-z80-games \
	games/obj/newlib-z80n-games \
	games/obj/newlib-z80n-games \
	games/obj/newlib-r2ka-games \
	games/obj/newlib-ixiy-games \
	games/obj/newlib-8080-games \
	games/obj/newlib-8085-games \
	games/obj/newlib-gbz80-games \
	games/obj/newlib-z180-games \
	games/obj/newlib-ez80_z80-games

OBJS += $(GAMES_NEWLIB_TARGETS)
CLEAN += ctype-clean

games: $(GAMES_NEWLIB_TARGES)

.PHONY: games games-clean

$(eval $(call buildnew,games,z80,-mz80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,r2ka,-mr2ka,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,z80n,-mz80n,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,ixiy,-IXIY,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,8080,-m8080,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,8085,-m8085,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,gbz80,-mgbz80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,z180,-mz180,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,games,ez80_z80,-mez80_z80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))

games-clean: 
	$(RM) -fr obj
