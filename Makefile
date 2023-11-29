build_docker:
	docker build -t otee-opcua .

run_docker:
	docker run -p 4855:4855 -it otee-opcua

run_local:
	cp server.conf ./target/debug/
	cargo run