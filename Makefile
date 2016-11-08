texroot=main
texfinal=grins.pdf

vectorsources := $(shell find rawfigs/ -name '*.dia' -o -name '*.eps' -o -name '*.ps' -o -name '*.pdf' -o -name '*.svg')
rastersources := $(shell find rawfigs/ -name '*.jpg' -o -name '*.gif')
readysources := $(shell find rawfigs/ -name '*.png' -o -name '*.pdf')

vectorfigs := $(shell echo ' ' $(vectorsources) ' ' | sed -e 's> *raw> >g' -e 's/\.[^. ]* /.pdf /g' )
rasterfigs := $(shell echo ' ' $(rastersources) ' ' | sed -e 's> *raw> >g' -e 's/\.[^. ]* /.png /g' )
readyfigs := $(shell echo ' ' $(readysources) ' ' | sed -e 's> *raw> >g' )
figures := $(vectorfigs) $(rasterfigs) $(readyfigs)

bibfiles := $(wildcard *.bib)
styfiles := $(wildcard $(repo_path)/latex_common/*.sty)
clsfiles := $(wildcard $(repo_path)/latex_common/*.cls)

texsources := $(shell find -name '*.tex')

all: $(texfinal)

figures: $(figures)

$(texfinal): $(texsources) $(bibfiles) $(figures) $(clsfiles) $(styfiles)
	latexmk -pdf -f $(texroot).tex -jobname=grins

clean: cleanlatex cleanfigs

cleanfigs:
	rm -rf $(figures)
cleanlatex:
	latexmk -C -bibtex

figs/%.pdf: rawfigs/%.dia
	@mkdir -p $(dir $@)
	dia -t eps-builtin -e $?_roytemp.eps $? && epstopdf $?_roytemp.eps -o=$@
	@rm -f $?_roytemp.eps

figs/%.pdf: rawfigs/%.eps
	@mkdir -p $(dir $@)
	epstopdf $? -o=$@

figs/%.pdf: rawfigs/%.pdf
	@mkdir -p $(dir $@)
	@reldir=`echo $(dir $@) | sed -e 's>[^/]*/*>../>g'`; ln -sf $${reldir}$? $@

figs/%.pdf: rawfigs/%.ps
	@mkdir -p $(dir $@)
	ps2pdf $? $@

figs/%.pdf: rawfigs/%.svg
	@mkdir -p $(dir $@)
	inkscape $? -z --export-pdf=$@

figs/%.png: rawfigs/%.jpg
	@mkdir -p $(dir $@)
	convert $? $@

figs/%.png: rawfigs/%.png
	@mkdir -p $(dir $@)
	@reldir=`echo $(dir $@) | sed -e 's>[^/]*/*>../>g'`; ln -sf $${reldir}$? $@
