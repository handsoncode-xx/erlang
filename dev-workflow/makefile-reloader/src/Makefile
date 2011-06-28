APP_DIR := ..
EBIN_DIR := $(APP_DIR)/ebin
INCLUDE_DIR := $(APP_DIR)/include

TESTS := hello

ERL := erl
ERLC := erlc
ERLC_FLAGS := -W -I $(INCLUDE_DIR) -pa $(EBIN_DIR) $(ERLC_OPTS)

ifndef no_debug_info
  ERLC_FLAGS += +debug_info
endif

ifdef debug
  ERLC_FLAGS += -Ddebug
endif

ERL_SOURCES := $(wildcard *.erl)
ERL_OBJECTS := $(ERL_SOURCES:%.erl=$(EBIN_DIR)/%.beam)

$(EBIN_DIR)/%.beam: %.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

compile: $(ERL_OBJECTS)

test: compile
	$(ERL) -pa $(EBIN_DIR) -noshell -s $(TESTS) test -s init stop

shell: compile
	erl -pa $(EBIN_DIR) -s reloader

clean:
	rm -rf $(EBIN_DIR)/*.beam
