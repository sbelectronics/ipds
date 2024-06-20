# Path to the ISIS simulator, which you can find at:
# https://bionic.bloovis.com/cgit/isis/. The simulator is written
# by Mark Alexander and allows native ISIS-II tools to be run
# from Linux (or Windows?) making compiling easy.

ISIS=../simulator/isis/gnu/isis

# Most of the stuff compiles with native ISIS tools, except Nascome
# Basic, which uses the AZZ toolchain. 

ZCC = ../../z88dk/bin/zcc

# So ZCC can find its assembler...

export PATH := $(PATH):../../z88dk/bin
export ZCCCFG := ../../z88dk/lib/config

all: world.hex

# .PHONY: env

export ISIS_F1=../simulator/isis/intel/plm80
export ISIS_F2=../simulator/isis/intel/utils
export ISIS_F3=../simulator/isis/intel/asm80

world.obj:
	rm -f world.tmp world.asm
	$(ZCC) +isis world.c -o world.tmp
	python3 ../asm/makeisis.py < world.tmp > world.asm
	unix2dos world.asm
	$(ISIS) :f3:asm80 world.asm

world: world.obj
	rm -f world.map
	$(ISIS) :f2:link world.obj,syspds.lib to world.lnk MAP
	$(ISIS) :f2:locate world.lnk to world PURGE MAP PRINT\(world.map\)

world-run: world
	$(ISIS) world arg1 arg2 arg3

world.hex: world
	$(ISIS) :f2:objhex world to world.hex

clean:
	rm -f *.hex *.obj *.lnk *.map *.lst *.tmp *.lis forth hello life world argtes
