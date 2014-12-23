texroot=low_mach_navier_stokes
texfinal=$(texroot).pdf

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

all: $(texfinal)

figures: $(figures)

$(texfinal): *.tex $(bibfiles) $(figures) $(clsfiles) $(styfiles)
	latexmk -pdf -f $(texroot).tex

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
