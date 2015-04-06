DESIGN_NAME=musicbox

all: build pgm 

build: output_files/$(DESIGN_NAME).sof

pgm: output_files/$(DESIGN_NAME).sof
	quartus_pgm --mode=jtag -o p\;output_files/$(DESIGN_NAME).sof

sta: asm
	quartus_sta $(DESIGN_NAME)

output_files/$(DESIGN_NAME).sof: output_files/$(DESIGN_NAME).fit.rpt
	quartus_asm $(DESIGN_NAME)

output_files/$(DESIGN_NAME).fit.rpt: output_files/$(DESIGN_NAME).map.rpt
	quartus_fit $(DESIGN_NAME)

output_files/$(DESIGN_NAME).map.rpt: $(DESIGN_NAME).qpf
	quartus_map $(DESIGN_NAME)

$(DESIGN_NAME).qpf: musicbox.tcl musicbox.v
	quartus_sh -t musicbox.tcl

$(DESIGN_NAME)tb.dsn: $(DESIGN_NAME)tb.v $(DESIGN_NAME).v
	iverilog -o $(DESIGN_NAME)tb.dsn $(DESIGN_NAME)tb.v $(DESIGN_NAME).v
	vvp $(DESIGN_NAME)tb.dsn

testbench: $(DESIGN_NAME)tb.dsn
	gtkwave $(DESIGN_NAME)tb.vcd

cleantestbench:
	@rm -f $(DESIGN_NAME)tb.dsn $(DESIGN_NAME)tb.vcd
clean:
	@rm -rf db incremental_db output_files
	@rm -rf *.qpf *.qsf *.summary *.rpt *.qdf *.jic *.map

$(DESIGN_NAME).jic: build
	quartus_cpf -c $(DESIGN_NAME).cof

pgm_flash: $(DESIGN_NAME).jic
	quartus_pgm --mode=jtag -o pi\;$(DESIGN_NAME).jic
