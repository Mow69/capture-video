import { Injectable } from '@nestjs/common';

// This should be a real class/interface representing a user entity
export type User = {
    userId: Number,
    username: String,
    password: String,
};

@Injectable()
export class UsersService {
    private user1: User = {
        userId: 1,
        username: 'john',
        password: 'changeme',
    };
    private user2: User = {
        userId: 2,
        username: 'maria',
        password: 'guess',
    };

    private readonly users = [
        this.user1,
        this.user2,
        ];

        async findOne(username: string): Promise<User | undefined> {
        return this.users.find(user => user.username === username);
        }
}
