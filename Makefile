TARGET = simv

SRC = *.v *.sv

VCSFLAGS = -debug_all +lint=all

SIM = vcs

default:
	$(SIM) $(VCSFLAGS) -o $(TARGET) $(SRC)

clean:
	-rm -r csrc
	-rm -r DVEfiles
	-rm $(TARGET)
	-rm -r $(TARGET).daidir
	-rm ucli.key
