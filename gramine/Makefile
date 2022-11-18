# Build Redis as follows:
#
# - make               -- create non-SGX no-debug-log manifest
# - make SGX=1         -- create SGX no-debug-log manifest
# - make SGX=1 DEBUG=1 -- create SGX debug-log manifest
#
# Any of these invocations clones Redis' git repository and builds Redis in
# default configuration and in the latest-to-date (5.0.5) version.
#
# By default, Redis uses poll/epoll mechanism of Linux. To build Redis with
# select, use `make USE_SELECT=1`. For correct re-builds, always clean up
# Redis source code beforehand via `make distclean`.
#
# Use `make clean` to remove Graphene-generated files and `make distclean` to
# additionally remove the cloned Redis git repository.

################################# CONSTANTS ###################################

ARCH_LIBDIR ?= /lib/$(shell $(CC) -dumpmachine)

# Relative path to Graphene root
SGX_SIGNER_KEY ?= $(HOME)/.gramine/developer-key.pem

app = app

ifeq ($(DEBUG),1)
GRAMINE_LOG_LEVEL = debug
else
GRAMINE_LOG_LEVEL = error
endif

.PHONY: all
all: $(app).manifest
ifeq ($(SGX),1)
all: $(app).manifest.sgx $(app).sig $(app).token
endif

################################ REDIS MANIFEST ###############################

# The template file contains almost all necessary information to run Redis
# under Graphene / Graphene-SGX. We create redis.manifest (to be run under
# non-SGX Graphene) by simply replacing variables in the template file via sed.

$(app).manifest: $(app).manifest.template
	gramine-manifest 										\
		-Dentrypoint=$(app) 							\
		-Dlog_level=$(GRAMINE_LOG_LEVEL) 	\
		-Darch_libdir=$(ARCH_LIBDIR) 			\
		$< > $@

# Manifest for Graphene-SGX requires special "gramine-sgx-sign" procedure. This procedure measures
# all Redis trusted files, adds the measurement to the resulting manifest.sgx file (among other,
# less important SGX options) and creates $(app).sig (SIGSTRUCT object).
#
# Graphene-SGX requires EINITTOKEN and SIGSTRUCT objects (see SGX hardware ABI, in particular EINIT
# instruction). The "gramine-sgx-get-token" script generates EINITTOKEN based on a SIGSTRUCT and
# puts it in .token file. Note that filenames must be the same as the manifest name (i.e.,
# "$(app)"). EINITTOKEN must be generated on the machine where the application will run, not
# where it was built.

# Make on Ubuntu <= 20.04 doesn't support "Rules with Grouped Targets" (`&:`),
# we need to hack around.
$(app).sig $(app).manifest.sgx: sgx_outputs
	@:

.INTERMEDIATE: sgx_outputs
sgx_outputs: $(app).manifest
	gramine-sgx-sign 							\
		--key $(SGX_SIGNER_KEY) 		\
		--manifest $(app).manifest 	\
		--output $(app).manifest.sgx

$(app).token: $(app).sig
	gramine-sgx-get-token --output $@ --sig $<

################################## CLEANUP ####################################

.PHONY: clean
clean:
	$(RM) *.token *.sig *.manifest.sgx *.manifest $(app) *.rdb

.PHONY: distclean
distclean: clean
