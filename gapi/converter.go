package gapi

import (
	"google.golang.org/protobuf/types/known/timestamppb"
	db "simplebank/db/sqlc"
	simplebank "simplebank/pb"
)

func convertUser(user db.User) *simplebank.User {
	return &simplebank.User{
		Username:          user.Username,
		FullName:          user.FullName,
		Email:             user.Email,
		PasswordChangedAt: timestamppb.New(user.PasswordChangedAt),
		CreatedAt:         timestamppb.New(user.CreatedAt),
	}
}
