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

let user1EncryptedPassword: String;
let user2EncryptedPassword: String;

bcrypt.genSalt(saltRounds, function(err, salt) {
    bcrypt.hash(user1Password, salt, function(err, hash) {
        // Store hash in your password DB.
        user1EncryptedPassword = hash;
    });
});

bcrypt.genSalt(saltRounds, function(err, salt) {
    bcrypt.hash(user2Password, salt, function(err, hash) {
        // Store hash in your password DB.
        user2EncryptedPassword = hash;
    });
});

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
