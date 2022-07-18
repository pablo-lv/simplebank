postgres:
	docker run --name go-postgres --network bank-network -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d -p 127.0.0.1:5432:5432 postgres
createdb:
	docker exec -it go-postgres createdb --username=root --owner=root simple_bank
dropdb:
	docker exec -it go-postgres dropdb simple_bank
migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose up
migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose up 1
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down
migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down 1
sqlc:
	sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
mock:
	mockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store
godocker:
	docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@go-postgres:5432/simple_bank?sslmode=disable" simplebank:latest

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test mock