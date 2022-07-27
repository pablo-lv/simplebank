package gapi

import (
	"context"
	"github.com/lib/pq"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	db "simplebank/db/sqlc"
	simplebank "simplebank/pb"
	"simplebank/util"
)

func (server *Server) CreateUser(ctx context.Context, req *simplebank.CreateUserRequest) (*simplebank.CreateUserResponse, error) {
	hashedPassword, err := util.HashPassword(req.Password)

	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to has password: %s", err)
	}

	arg := db.CreateUserParams{
		Username:       req.GetUsername(),
		FullName:       req.GetFullName(),
		Email:          req.GetEmail(),
		HashedPassword: hashedPassword,
	}

	user, err := server.store.CreateUser(ctx, arg)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			switch pqErr.Code.Name() {
			case "unique_violation":
				return nil, status.Errorf(codes.AlreadyExists, "Username already exists: %s", err)
			}
		}
		return nil, status.Errorf(codes.Internal, "Failed to create user: %s", err)
	}

	response := &simplebank.CreateUserResponse{
		User: convertUser(user),
	}

	return response, nil
}
