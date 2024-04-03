CFLAGS=-I ./ -Wall -Werror
LDFLAGS=-static
OBJS=main.o ssd1306.o linux_i2c.o
BIN=displaytext

default: $(BIN)
.PHONY: default clean

# Adapted from scottmcpeak.com/autodepend/autodepend.html
-include $(OBJS:.o=.d)
%.o: %.c
	$(CXX) -c $(CXXFLAGS) $< -o $*.o
	$(CXX) -MM $(CXXFLAGS) $< > $*.d
	@cp -f $*.d $*.d.tmp
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | \
	  sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
	@rm -f $*.d.tmp

$(BIN):$(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -f *.o *.d $(BIN)

