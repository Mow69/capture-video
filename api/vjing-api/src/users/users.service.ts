import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { InsertCreateUserDto } from 'src/auth/dto/auth.dto';
import { Repository, DataSource } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from "bcrypt"

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User) private readonly usersRepository: Repository<User>
    ) {}

    findAll(): Promise<User[]> {
        return this.usersRepository.find();
    }
    
    findOne(id: number): Promise<User> {
        return this.usersRepository.findOneBy({ id });
    }
    findOneEmail(email: string): Promise<User> {
        return this.usersRepository.findOneBy({ email });
    }

    async insert(userData: InsertCreateUserDto): Promise<User> {
        const saltOrRounds = 10;
        const hash = await bcrypt.hash(userData.password, saltOrRounds);
        
        const newUser = new User;
        newUser.email = userData.email;
        newUser.username = userData.username;
        newUser.last_name = userData.last_name;
        newUser.first_name = userData.first_name;
        newUser.password = hash;

        await this.usersRepository.save(newUser);
        return newUser;
    }

    async remove(res, id: number): Promise<void> {
        await this.usersRepository.delete(id);
        return res.status(201).send(`User ${id} has been deleted`);

    }
}
