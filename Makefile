###############################################################################
################### MOOSE Application Standard Makefile #######################
###############################################################################
#
# Optional Environment variables
# MOOSE_DIR        - Root directory of the MOOSE project
#
###############################################################################
# Use the MOOSE submodule if it exists and MOOSE_DIR is not set
MOOSE_SUBMODULE    := $(CURDIR)/moose
ifneq ($(wildcard $(MOOSE_SUBMODULE)/framework/Makefile),)
  MOOSE_DIR        ?= $(MOOSE_SUBMODULE)
else
  MOOSE_DIR        ?= $(shell dirname `pwd`)/moose
endif

# framework
FRAMEWORK_DIR      := $(MOOSE_DIR)/framework
include $(FRAMEWORK_DIR)/build.mk
include $(FRAMEWORK_DIR)/moose.mk

################################## MODULES ####################################
# To use certain physics included with MOOSE, set variables below to
# yes as needed.  Or set ALL_MODULES to yes to turn on everything (overrides
# other set variables).

ALL_MODULES         := no

CHEMICAL_REACTIONS  := no
CONTACT             := no
FLUID_PROPERTIES    := no
HEAT_CONDUCTION     := no
MISC                := no
NAVIER_STOKES       := no
PHASE_FIELD         := no
RDG                 := no
RICHARDS            := no
SOLID_MECHANICS     := no
STOCHASTIC_TOOLS    := no
TENSOR_MECHANICS    := yes
XFEM                := no
POROUS_FLOW         := no

include $(MOOSE_DIR)/modules/modules.mk
###############################################################################

# dep apps
APPLICATION_DIR    := $(CURDIR)
APPLICATION_NAME   := modelib_moose
BUILD_EXEC         := yes
GEN_REVISION       := no
include            $(FRAMEWORK_DIR)/app.mk

###############################################################################
# Additional special case targets should be added here

MODEL_INCLUDE =./include
EIGEN_INCLUDE =/usr/local/include

##########################################################
# INCLUDE SETTINGS - DO NOT EDIT-
##########################################################
IDIR += -I./
IDIR += -I$(MODEL_INCLUDE)
IDIR += -I$(EIGEN_INCLUDE)
IDIR += -I$(MODEL_INCLUDE)/model/DislocationDynamics/Polycrystals
IDIR += -I$(MODEL_INCLUDE)/model/MPI
IDIR += -I$(MODEL_INCLUDE)/model/Mesh
IDIR += -I$(MODEL_INCLUDE)/model/Utilities
IDIR += -I$(MODEL_INCLUDE)/model/IO
IDIR += -I$(MODEL_INCLUDE)/model/FEM
IDIR += -I$(MODEL_INCLUDE)/model/Math/CompileTimeMath
IDIR += -I$(MODEL_INCLUDE)/model/LatticeMath
IDIR += -I$(MODEL_INCLUDE)/model/Math
IDIR += -I$(MODEL_INCLUDE)/model/Geometry
IDIR += -I$(MODEL_INCLUDE)/model/DislocationDynamics/Materials
IDIR += -I$(MODEL_INCLUDE)/model/DislocationDynamics/MobilityLaws
IDIR += -I$(MODEL_INCLUDE)/model/DislocationDynamics/ElasticFields
IDIR += -I$(MODEL_INCLUDE)/model/DislocationDynamics/GlidePlanes
IDIR += -I$(MODEL_INCLUDE)/model/DislocationDynamics
IDIR += -I$(MODEL_INCLUDE)/model/Quadrature
IDIR += -I$(MODEL_INCLUDE)/model/Quadrature/GaussLegendre
IDIR += -I$(MODEL_INCLUDE)/model/Quadrature/GaussLegendre/dim2
IDIR += -I$(MODEL_INCLUDE)/model/Quadrature/GaussLegendre/dim3
IDIR += -I$(MODEL_INCLUDE)/model/Quadrature/UniformOpen
IDIR += -I$(MODEL_INCLUDE)/model/Geometry/Splines

##########################################################
# COMPILER SETTINGS - DO NOT EDIT-
##########################################################
OS= $(shell uname -s)

ifeq ($(USE_ICC), 1)
	CC= icpc
	mpiCC= icpc
	CFLAGS	 = -O3
	CFLAGS	+= -xhost
	#CFLAGS	+= -fast
	CFLAGS	+= -openmp 
	CFLAGS	+= -std=c++14
else
	CC= g++
	mpiCC = mpicxx
	CFLAGS += -Ofast
	CFLAGS += -fopenmp
	CFLAGS += -std=c++14

	ifeq ($(OS),Darwin)
		CFLAGS += -msse4
	endif

	ifeq ($(OS),Linux)
		CFLAGS += -msse4
#s		CFLAGS += -march=native
	endif

endif

##########################################################
# MAKE MICROSTRUCTUREGENERATOR
##########################################################
generatorOBJS = microstructureGenerator

$(generatorOBJS):
	@echo making microstructureGenerator
	$(CC) $(MODEL_INCLUDE)/tools/MicrostructureGenerators/microstructureGenerator.cpp -o microstructureGenerator -O3 -std=c++14 -Wall $(IDIR)

##########################################################
# MAKE EMPTY
##########################################################
#mkdirV=$(shell test -d V || mkdir V)
#mkdirE=$(shell test -d E || mkdir E)
Fexists=$(shell test -d F && echo 1)
Gexists=$(shell test -d G && echo 1)
Cexists=$(shell test -d C && echo 1)
Kexists=$(shell test -d K && echo 1)
Lexists=$(shell test -d L && echo 1)
Pexists=$(shell test -d P && echo 1)
Dexists=$(shell test -d D && echo 1)
Sexists=$(shell test -d S && echo 1)
Uexists=$(shell test -d U && echo 1)
Qexists=$(shell test -d Q && echo 1)
Zexists=$(shell test -d Z && echo 1)
TGAexists=$(shell test -d tga && echo 1)
JPGexists=$(shell test -d jpg && echo 1)

empty:
	@echo emptying folder evl
	@find evl/ -name evl_\*.txt ! -name evl_0.txt -exec rm {} +;
	@find evl/ -name evl_\*.bin ! -name evl_0.bin -exec rm {} +;
ifeq ($(Fexists),1)
	@echo emptying folder F
	@find F/ -name F_\*.txt -exec rm {} +;
	@find F/ -name F_\*.bin -exec rm {} +;
endif
ifeq ($(Gexists),1)
	@echo emptying folder G
	@find G/ -name G_\*.txt -exec rm {} +;
	@find G/ -name G_\*.bin -exec rm {} +;
endif
ifeq ($(Cexists),1)
	@echo emptying folder C
	@find C/ -name C_\*.txt -exec rm {} +;
	@find C/ -name C_\*.bin -exec rm {} +;
endif
ifeq ($(Kexists),1)
	@echo emptying folder K
	@find K/ -name K_\*.txt -exec rm {} +;
	@find K/ -name K_\*.bin -exec rm {} +;
endif
ifeq ($(Pexists),1)
	@echo emptying folder P
	@find P/ -name P_\*.txt -exec rm {} +;
	@find P/ -name P_\*.bin -exec rm {} +;
endif	
ifeq ($(Dexists),1)
	@echo emptying folder D
	@find D/ -name D_\*.txt -exec rm {} +;
	@find D/ -name D_\*.bin -exec rm {} +;
endif	
ifeq ($(Sexists),1)
	@echo emptying folder S
	@find S/ -name S_\*.txt -exec rm {} +;
	@find S/ -name S_\*.bin -exec rm {} +;
endif	
ifeq ($(Uexists),1)
	@echo emptying folder U
	@find U/ -name U_\*.txt -exec rm {} +;
	@find U/ -name U_\*.bin -exec rm {} +;
endif
ifeq ($(Zexists),1)
	@echo emptying folder Z
	@find Z/ -name Z_\*.txt -exec rm {} +;
	@find Z/ -name Z_\*.bin -exec rm {} +;
endif
ifeq ($(Qexists),1)
	@echo emptying folder Q
	@find Q/ -name Q_\*.txt -exec rm {} +;
	@find Q/ -name Q_\*.bin -exec rm {} +;
endif	
ifeq ($(TGAexists),1)
	@echo emptying folder tga
	@find tga/ -name image_\*.tga -exec rm {} +;
endif	
ifeq ($(JPGexists),1)
	@echo emptying folder jpg
	@find jpg/ -name image_\*.jpg -exec rm {} +;
endif
