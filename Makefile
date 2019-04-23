TARGET = simv

SRC = *.sv

VCSFLAGS = -sverilog

SIM = vcs

default:
	$(SIM) $(VCSFLAGS) -o $(TARGET) $(SRC)

clean:
	-rm -r csrc
	-rm -r DVEfiles
	-rm $(TARGET)
	-rm -r $(TARGET).daidir
	-rm ucli.key
