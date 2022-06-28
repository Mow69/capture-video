import { Injectable } from '@nestjs/common';

// This should be a real class/interface representing a user entity
export type User = {
    userId: Number,
    username: String,
    password: String,
};

const bcrypt = require('bcrypt');
const saltRounds = 10;

const user1Password: String = 'changeme';
const user2Password: String = 'guess';

const user1EncryptedPassword: String = bcrypt.hashSync(user1Password, saltRounds);
const user2EncryptedPassword: String = bcrypt.hashSync(user2Password, saltRounds);

@Injectable()
export class UsersService {
    private user1: User = {
        userId: 1,
        username: 'john',
        password: user1EncryptedPassword,
    };
    private user2: User = {
        userId: 2,
        username: 'maria',
        password: user2EncryptedPassword,
    };
    
    private readonly users = [
        this.user1,
        this.user2,
        ];

        async findOne(username: string): Promise<User | undefined> {
        return this.users.find(user => user.username === username);
        }
}
