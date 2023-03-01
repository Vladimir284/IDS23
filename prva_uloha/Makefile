FILENAME = xzoban02

all: doc doc_clean

doc: out_clean
	latexmk -pdf -jobname=$(FILENAME) src/main.tex
	mv $(FILENAME).pdf out

doc_clean:
	rm -f src/modules/*.aux
	rm -f *.aux
	rm -f *.lof
	rm -f *.log
	rm -f *.fls
	rm -f *.fdb_latexmk
	rm -f *.toc
	rm -f *.out
	rm -f *.lot

out_clean:
	rm -rf out
	mkdir out

clean: out_clean doc_clean
