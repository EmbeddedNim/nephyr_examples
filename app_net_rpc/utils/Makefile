
rpc_cli: rpc_cli.nim
	nim c --gc:arc --nimblePath:$(HOME)/.nimble/pkgs -d:nimNetLite rpc_cli.nim


rpc_server_example: rpc_server_example.nim
	nim c --gc:arc --nimblePath:$(HOME)/.nimble/pkgs rpc_server_example.nim

clean:
	rm -Rf rpc_cli rpc_server_example

