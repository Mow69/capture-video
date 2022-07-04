import { forwardRef, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { InsertCreateUserDto } from 'src/auth/dto/auth.dto';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from "bcrypt"
import { PatchUserDto } from './dto/users.dto';
import { SecurityService } from 'src/tools/security.service';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User) private readonly usersRepository: Repository<User>,
        @Inject(forwardRef(() => SecurityService))
        private security: SecurityService,
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

    async update(res: { status: (arg0: number) => { (): any; new(): any; send: { (arg0: string): void | PromiseLike<void>; new(): any; }; }; }, dto: PatchUserDto, id: number): Promise<void> {

        const userData = await this.security.checkUpdatingUser(dto);
        
        const saltOrRounds = 10;
        const hash = await bcrypt.hash(userData.password, saltOrRounds);
        
        const user = new User;
        user.email = userData.email;
        user.username = userData.username;
        user.last_name = userData.last_name;
        user.first_name = userData.first_name;
        user.password = hash;

        await this.usersRepository.update(id, userData);
        return res.status(201).send(`User ${id} has been updated`);
    }

    async remove(res, id: number): Promise<void> {
        await this.usersRepository.delete(id);
        return res.status(201).send(`User ${id} has been deleted`);
    }
}
