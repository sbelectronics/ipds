ISIS=../../simulator/isis/gnu/isis

all: kermit

export ISIS_F1=../../simulator/isis/intel/plm80
export ISIS_F2=../../simulator/isis/intel/utils
export ISIS_F3=../../simulator/isis/intel/asm80

kermit : md2ker.obj md2con.obj md2sen.obj md2rec.obj
	$(ISIS) :f2:link md2ker.obj,md2con.obj,md2sen.obj,md2rec.obj,:f2:system.lib,:f2:plm80.lib to kermit.lnk MAP PRINT\(KERMIT.LKM\)
	$(ISIS) :f2:locate kermit.lnk to kermit MAP PRINT\(kermit.map\)

kermit.hex: kermit
	$(ISIS) :f2:objhex kermit to kermit.hex	
	#split -C 31k --numeric-suffixes kermit.hex kerm

md2ker.obj: md2ker.plm
	$(ISIS) :f1:plm80 md2ker.plm

md2con.obj: md2con.plm
	$(ISIS) :f1:plm80 md2con.plm

md2sen.obj: md2sen.plm
	$(ISIS) :f1:plm80 md2sen.plm

md2rec.obj: md2rec.plm
	$(ISIS) :f1:plm80 md2rec.plm

kermit-run:
	$(ISIS) kermit

clean:
	rm -f *.obj *.map *.lkm *.lnk kermit
