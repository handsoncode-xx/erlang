compile:
	./rebar compile

clean:
	./rebar clean

shell: compile
	erl -pa ebin $(wildcard deps/*/ebin) -s dg_reloader
