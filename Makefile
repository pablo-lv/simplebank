postgres:
	docker run --name go-postgres -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d -p 127.0.0.1:5432:5432 postgres
createdb:
	docker exec -it go-postgres createdb --username=root --owner=root simple_bank
dropdb:
	docker exec -it go-postgres dropdb simple_bank
migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down
sqlc:
	sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server