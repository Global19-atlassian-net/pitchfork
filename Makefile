default:

override PFHOME:=${CURDIR}
-include settings.mk
include ./mk/config.mk
include ./mk/bootstrap.mk
include ./mk/init.mk # in case we want to re-run init/sanity

UNAME   = uname
ARCH   := $(shell $(UNAME) -m)
OPSYS  := $(shell $(UNAME) -s)
SHELL   = /bin/bash -e
PREFIX ?= deployment

default:
	@echo "'make init' must occur before any other rule."
	@echo "You can do that manually, or let it happen automatically as 'initialized.mk' is generated."
	@echo "CCACHE_DIR=${CCACHE_DIR}"
	@echo "PREFIX=${PREFIX}"

# Please add dependencies after this line
ccache:           initialized.o
openssl:          ccache
zlib:             ccache
boost:            ccache
ifeq ($(origin HAVE_PYTHON),undefined)
python:           ccache zlib openssl ncurses readline
endif
readline:         ccache ncurses
samtools:         ccache zlib ncurses
cmake:            ccache zlib
ncurses:          ccache
openblas:         ccache
hdf5:             ccache zlib
swig:             ccache python
libpng:           ccache zlib
hmmer:            ccache
gmap:             ccache zlib
sbt:              jre

pip:              python
cython:           pip
ifeq ($(OPSYS),Darwin)
numpy:            pip cython
else
numpy:            pip cython openblas
endif
h5py:             pip hdf5 numpy six
jsonschema:       pip functools32
pydot:            pip pyparsing
fabric:           pip paramiko ecdsa pycrypto
rdflib:           pip six isodate html5lib
matplotlib:       pip numpy libpng pytz six pyparsing python-dateutil cycler
rdfextras:        pip rdflib
scipy:            pip numpy
appnope:          pip
avro:             pip
decorator:        pip
docopt:           pip
ecdsa:            pip
functools32:      pip
gnureadline:      pip readline
html5lib:         pip
ipython_genutils: pip
iso8601:          pip
isodate:          pip
jinja2:           pip MarkupSafe
networkx:         pip decorator matplotlib
paramiko:         pip
path.py:          pip
pexpect:          pip
pickleshare:      pip
ptyprocess:       pip
pycrypto:         pip
pyparsing:        pip
pysam:            pip zlib
python-dateutil:  pip
pytz:             pip
requests:         pip
simplegeneric:    pip
six:              pip
traitlets:        pip
xmlbuilder:       pip
nose:             pip
cram:             pip
cycler:           pip
MarkupSafe:       pip
tabulate:         pip

# Not part of pacbio developers' software collection
nim:          ccache zlib
tcl:          ccache zlib
modules:      ccache tcl
ssw_lib:      ccache pip
mash:         ccache
fasta2bam:    ccache pbbam htslib zlib boost cmake
scikit-image: pip numpy decorator six networkx matplotlib pillow
pillow:       pip
dask.array:   pip toolz numpy
toolz:        pip
ipython:      pip traitlets pickleshare appnope decorator gnureadline pexpect ipython_genutils path.py ptyprocess simplegeneric
Cogent:       pip numpy scipy networkx scikit-image biopython bx-python PuLP ssw_lib mash matplotlib
biopython:    pip numpy
bx-python:    pip zlib
PuLP:         pip

# software from pacbio
htslib:       ccache zlib
blasr_libcpp: ccache boost hdf5 pbbam
blasr:        ccache blasr_libcpp hdf5 cmake
pbbam:        ccache samtools cmake boost htslib gtest
pbccs:        ccache pbbam htslib cmake boost gtest seqan ConsensusCore2
dazzdb:       ccache
daligner:     ccache dazzdb
pbdagcon:     ccache dazzdb daligner pbbam blasr_libcpp
bam2fastx:    ccache pbbam htslib zlib boost cmake
#
pbcore:           pysam h5py
pbh5tools:        h5py pbcore
pbcoretools:      pbcore pbcommand
pbcommand:        xmlbuilder jsonschema avro requests iso8601 numpy tabulate
pbsmrtpipe:       pbcommand jinja2 networkx pbcore pbcommand pyparsing pydot jsonschema xmlbuilder requests fabric
falcon_kit:       networkx daligner dazzdb pbdagcon
pbfalcon:         falcon_kit pbsmrtpipe pypeFLOW dazzdb daligner
pbreports:        matplotlib cython numpy h5py pysam jsonschema pbcore pbcommand
kineticsTools:    scipy pbcore pbcommand h5py
pypeFLOW:         rdflib rdfextras
pbalign:          pbcore samtools blasr pbcommand
ConsensusCore:    numpy boost swig cmake
ConsensusCore2:   numpy boost swig cmake
GenomicConsensus: pbcore pbcommand numpy h5py ConsensusCore
smrtflow:         sbt
#
pblaa:         htslib pbbam seqan pbsparse pbccs ConsensusCore2 pbchimera
pbchimera:     seqan cmake
ppa:           boost cmake pbbam htslib

# end of dependencies

# meta rules
bam2bax: blasr
bax2bam: blasr
reseq-core: \
       pbsmrtpipe pbalign blasr pbreports GenomicConsensus pbbam pbcoretools pbccs
world: \
       reseq-core ConsensusCore2 pbfalcon kineticsTools \
       hmmer      gmap           ssw_lib  mash          \
       ipython    biopython      \
       cram       nose

# rules
ifeq ($(origin HAVE_CCACHE),undefined)
ccache:
	$(MAKE) -C ports/thirdparty/$@ do-install
else
ccache:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
ifeq ($(OPSYS),Darwin)
HAVE_ZLIB ?=
readline: ;
ncurses: ;
tcl: ;
libpng: ;
else
readline:
	$(MAKE) -C ports/thirdparty/$@ do-install
ncurses:
	$(MAKE) -C ports/thirdparty/$@ do-install
tcl:
	$(MAKE) -j1 -C ports/thirdparty/$@ do-install
libpng:
	$(MAKE) -C ports/thirdparty/$@ do-install
endif
ifeq ($(origin HAVE_OPENBLAS),undefined)
openblas:
	$(MAKE) -C ports/thirdparty/$@ do-install
else
openblas:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
ifeq ($(origin HAVE_ZLIB),undefined)
zlib:
	$(MAKE) -C ports/thirdparty/$@ do-install
else
zlib:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
ifeq ($(origin HAVE_HDF5),undefined)
hdf5:
	$(MAKE) -C ports/thirdparty/$@ do-install
else
hdf5:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
gtest:
	$(MAKE) -C ports/thirdparty/$@ do-install
gmock:
	$(MAKE) -C ports/thirdparty/$@ do-install
ifeq ($(origin HAVE_BOOST),undefined)
boost:
	$(MAKE) -C ports/thirdparty/$@ do-install
else
boost:
	$(MAKE) -C ports/thirdparty/$@ provided
endif
samtools:
	$(MAKE) -C ports/thirdparty/$@ do-install
ifeq ($(origin HAVE_CMAKE),undefined)
cmake:
	$(MAKE) -C ports/thirdparty/$@ do-install
else
cmake: ;
endif
swig:
	$(MAKE) -C ports/thirdparty/$@ do-install
hmmer:
	$(MAKE) -C ports/thirdparty/$@ do-install
gmap:
	$(MAKE) -C ports/thirdparty/$@ do-install
jre:
	$(MAKE) -C ports/thirdparty/$@ do-install
sbt:
	$(MAKE) -C ports/thirdparty/$@ do-install

openssl:
	$(MAKE) -C ports/thirdparty/libressl do-install
ifeq ($(origin HAVE_PYTHON),undefined)
python:
	$(MAKE) -C ports/thirdparty/$@ do-install
pip:
	$(MAKE) -j1 -C ports/python/$@ do-install
else
python:
	$(MAKE) -j1 -C ports/python/virtualenv do-install
pip: ;
endif

numpy:
	$(MAKE) -j1 -C ports/python/$@ do-install
cython:
	$(MAKE) -j1 -C ports/python/$@ do-install
xmlbuilder:
	$(MAKE) -j1 -C ports/python/$@ do-install
jsonschema:
	$(MAKE) -j1 -C ports/python/$@ do-install
avro:
	$(MAKE) -j1 -C ports/python/$@ do-install
requests:
	$(MAKE) -j1 -C ports/python/$@ do-install
iso8601:
	$(MAKE) -j1 -C ports/python/$@ do-install
jinja2:
	$(MAKE) -j1 -C ports/python/$@ do-install
networkx:
	$(MAKE) -j1 -C ports/python/$@ do-install
pyparsing:
	$(MAKE) -j1 -C ports/python/$@ do-install
pydot:
	$(MAKE) -j1 -C ports/python/$@ do-install
fabric:
	$(MAKE) -j1 -C ports/python/$@ do-install
h5py:
	$(MAKE) -j1 -C ports/python/$@ do-install
docopt:
	$(MAKE) -j1 -C ports/python/$@ do-install
pysam:
	$(MAKE) -j1 -C ports/python/$@ do-install
six:
	$(MAKE) -j1 -C ports/python/$@ do-install
rdflib:
	$(MAKE) -j1 -C ports/python/$@ do-install
rdfextras:
	$(MAKE) -j1 -C ports/python/$@ do-install
matplotlib:
	$(MAKE) -j1 -C ports/python/$@ do-install
scipy:
	$(MAKE) -j1 -C ports/python/$@ do-install
traitlets:
	$(MAKE) -j1 -C ports/python/$@ do-install
pickleshare:
	$(MAKE) -j1 -C ports/python/$@ do-install
appnope:
	$(MAKE) -j1 -C ports/python/$@ do-install
decorator:
	$(MAKE) -j1 -C ports/python/$@ do-install
gnureadline:
	$(MAKE) -j1 -C ports/python/$@ do-install
pexpect:
	$(MAKE) -j1 -C ports/python/$@ do-install
ipython_genutils:
	$(MAKE) -j1 -C ports/python/$@ do-install
path.py:
	$(MAKE) -j1 -C ports/python/$@ do-install
ptyprocess:
	$(MAKE) -j1 -C ports/python/$@ do-install
simplegeneric:
	$(MAKE) -j1 -C ports/python/$@ do-install
paramiko:
	$(MAKE) -j1 -C ports/python/$@ do-install
ecdsa:
	$(MAKE) -j1 -C ports/python/$@ do-install
pycrypto:
	$(MAKE) -j1 -C ports/python/$@ do-install
isodate:
	$(MAKE) -j1 -C ports/python/$@ do-install
html5lib:
	$(MAKE) -j1 -C ports/python/$@ do-install
functools32:
	$(MAKE) -j1 -C ports/python/$@ do-install
pytz:
	$(MAKE) -j1 -C ports/python/$@ do-install
python-dateutil:
	$(MAKE) -j1 -C ports/python/$@ do-install
nose:
	$(MAKE) -j1 -C ports/python/$@ do-install
cram:
	$(MAKE) -j1 -C ports/python/$@ do-install
cycler:
	$(MAKE) -j1 -C ports/python/$@ do-install
MarkupSafe:
	$(MAKE) -j1 -C ports/python/$@ do-install
tabulate:
	$(MAKE) -j1 -C ports/python/$@ do-install

#
blasr_libcpp:
	$(MAKE) -C ports/pacbio/$@ do-install
blasr:
	$(MAKE) -C ports/pacbio/$@ do-install
htslib:
	$(MAKE) -C ports/pacbio/$@ do-install
seqan:
	$(MAKE) -C ports/pacbio/$@ do-install
pbbam:
	$(MAKE) -C ports/pacbio/$@ do-install
pbccs:
	$(MAKE) -C ports/pacbio/$@ do-install
dazzdb:
	$(MAKE) -C ports/pacbio/$@ do-install
daligner:
	$(MAKE) -C ports/pacbio/$@ do-install
pbdagcon:
	$(MAKE) -C ports/pacbio/$@ do-install
bam2fastx:
	$(MAKE) -C ports/pacbio/$@ do-install
#
pbcore:
	$(MAKE) -C ports/pacbio/$@ do-install
pbcommand:
	$(MAKE) -C ports/pacbio/$@ do-install
pbsmrtpipe:
	$(MAKE) -C ports/pacbio/$@ do-install
falcon_kit:
	$(MAKE) -C ports/pacbio/$@ do-install
pbfalcon:
	$(MAKE) -C ports/pacbio/$@ do-install
pypeFLOW:
	$(MAKE) -C ports/pacbio/$@ do-install
ConsensusCore:
	$(MAKE) -C ports/pacbio/$@ do-install
ConsensusCore2:
	$(MAKE) -C ports/pacbio/$@ do-install
GenomicConsensus:
	$(MAKE) -C ports/pacbio/$@ do-install
pbreports:
	$(MAKE) -C ports/pacbio/$@ do-install
kineticsTools:
	$(MAKE) -C ports/pacbio/$@ do-install
pbalign:
	$(MAKE) -C ports/pacbio/$@ do-install
pbcoretools:
	$(MAKE) -C ports/pacbio/$@ do-install
#
pbchimera:
	$(MAKE) -C ports/pacbio/$@ do-install
pbsparse:
	$(MAKE) -C ports/pacbio/$@ do-install
pblaa:
	$(MAKE) -C ports/pacbio/$@ do-install
#
pbh5tools:
	$(MAKE) -C ports/pacbio/$@ do-install
ppa:
	$(MAKE) -C ports/pacbio/$@ do-install
Cogent:
	$(MAKE) -C ports/pacbio/$@ do-install
#
smrtflow:
	$(MAKE) -C ports/pacbio/$@ do-install

# Not part of pacbio developers' software collection
nim:
	$(MAKE) -C ports/thirdparty/$@ do-install
modules:
	$(MAKE) -C ports/thirdparty/$@ do-install
mash:
	$(MAKE) -C ports/thirdparty/$@ do-install
ssw_lib:
	$(MAKE) -C ports/thirdparty/$@ do-install
scikit-image:
	$(MAKE) -j1 -C ports/python/$@ do-install
pillow:
	$(MAKE) -j1 -C ports/python/$@ do-install
dask.array:
	$(MAKE) -j1 -C ports/python/$@ do-install
toolz:
	$(MAKE) -j1 -C ports/python/$@ do-install
ipython:
	$(MAKE) -j1 -C ports/python/$@ do-install
biopython:
	$(MAKE) -j1 -C ports/python/$@ do-install
bx-python:
	$(MAKE) -j1 -C ports/python/$@ do-install
PuLP:
	$(MAKE) -j1 -C ports/python/$@ do-install
fasta2bam:
	$(MAKE) -C ports/pacbio/$@ do-install
# unknown
#pyxb:
#	$(MAKE) -j1 -C ports/python/$@ do-install
clean-%:
	$(MAKE) -C ports/pacbio/$* do-clean
distclean-%:
	$(MAKE) -C ports/pacbio/$* do-distclean
clean: clean-blasr_libcpp clean-blasr clean-htslib clean-seqan clean-pbbam clean-pbccs clean-dazzdb clean-daligner clean-pbdagcon clean-bam2fastx clean-pbcore clean-pbcommand clean-pbsmrtpipe clean-falcon_kit clean-pbfalcon clean-pypeFLOW clean-ConsensusCore clean-ConsensusCore2 clean-GenomicConsensus clean-pbreports clean-kineticsTools clean-pbalign clean-pbcoretools clean-pbchimera clean-pbsparse clean-pblaa clean-pbh5tools clean-ppa clean-Cogent
distclean: distclean-blasr_libcpp distclean-blasr distclean-htslib distclean-seqan distclean-pbbam distclean-pbccs distclean-dazzdb distclean-daligner distclean-pbdagcon distclean-bam2fastx distclean-pbcore distclean-pbcommand distclean-pbsmrtpipe distclean-falcon_kit distclean-pbfalcon distclean-pypeFLOW distclean-ConsensusCore distclean-ConsensusCore2 distclean-GenomicConsensus distclean-pbreports distclean-kineticsTools distclean-pbalign distclean-pbcoretools distclean-pbchimera distclean-pbsparse distclean-pblaa distclean-pbh5tools distclean-ppa distclean-Cogent

.PHONY: ConsensusCore GenomicConsensus MarkupSafe appnope avro biopython blasr boost ccache cmake Cogent cram cycler cython daligner dazzdb decorator default docopt ecdsa fabric gmap gmock gnureadline gtest hmmer htslib ipython isodate jsonschema kineticsTools libpng matplotlib modules ncurses networkx nim nose numpy openblas openssl paramiko pbalign pbbam pbccs pbchimera pbcommand pbcore pbcoretools pbdagcon pbfalcon pblaa pbreports pbsmrtpipe pbsparse pexpect pickleshare pip ppa ptyprocess pycrypto pydot pyparsing pypeFLOW pysam python pytz pyxb rdfextras rdflib readline requests samtools scipy seqan simplegeneric six swig tcl traitlets world xmlbuilder zlib pbh5tools tabulate
