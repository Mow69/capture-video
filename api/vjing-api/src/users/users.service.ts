import { BadRequestException, forwardRef, Inject, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { createUserDto, InsertCreateUserDto } from 'src/auth/dto/auth.dto';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from "bcrypt"
import { UpdateUserDto } from './dto/users.dto';
import { SecurityService } from 'src/tools/security.service';
import { Response } from 'express';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User) private readonly usersRepository: Repository<User>,
        @Inject(forwardRef(() => SecurityService))
        private securityService: SecurityService,
    ) {}

    findAll(): Promise<User[]> {
        return this.usersRepository.find();
    }
    
    findOne(id: number): Promise<User> {
        return this.usersRepository.findOneBy({ id }).then((user) => {
            if(!user){
              throw new NotFoundException('Id not found');
            }
            return user
        });
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

    async update(res: Response, dto: UpdateUserDto, id: number): Promise<Response> {

        const userData = await this.checkUpdatingUser(dto);

        const updateUser = new User;
        updateUser.email = userData.email;
        updateUser.username = userData.username;
        updateUser.last_name = userData.last_name;
        updateUser.first_name = userData.first_name;

        const saltOrRounds = 10;
        const hash = await bcrypt.hash(dto.password, saltOrRounds);
        updateUser.password = hash;

        
        await this.findOne(id);
        if(Object.keys(updateUser).length === 0){
            return res.status(200).send(`No data to update`)
        } else{
            await this.usersRepository.update(id, updateUser);
            return res.status(201).send(`Filter ${id} has been updated`);
        }
    }

    async remove(res: Response, id: number): Promise<Response> {
        const filter = await this.findOne(id)
        await this.usersRepository.remove(filter);
        return res.status(201).send(`User ${id} has been deleted`);
    }

    async checkUpdatingUser(dto: UpdateUserDto): Promise<UpdateUserDto> {

        let dtoVerify = {} as UpdateUserDto;
        if(dto.email) dtoVerify.email = await this.securityService.checkEmail(dto.email);
        if(dto.username) dtoVerify.username = await this.securityService.cleanString(dto.username, "username", 1, 254);
        if(dto.last_name) dtoVerify.last_name = await this.securityService.cleanString(dto.last_name, "last_name", 1, 254);
        if(dto.first_name) dtoVerify.first_name = await this.securityService.cleanString(dto.first_name, "first_name", 1, 254);
        if(dto.password) {
            if(!dto.repeat_password){
                throw new BadRequestException("repeat_password is missing")
            }
            await this.securityService.checkPassword(
                dto.password,
                dto.repeat_password,
            );
        }
        return dtoVerify;
    }
    async checkRegisterData(dto: createUserDto): Promise<InsertCreateUserDto> {
        if (
          !dto.email ||
          !dto.username ||
          !dto.password ||
          !dto.repeat_password ||
          !dto.last_name ||
          !dto.first_name
        ) {
          throw new BadRequestException('data is missing');
        }
        let dtoVerify = {} as InsertCreateUserDto;
        dtoVerify.email = await this.securityService.checkEmail(dto.email);
        dtoVerify.username = await this.securityService.cleanString(dto.username, "username", 1, 254);
        dtoVerify.last_name = await this.securityService.cleanString(dto.last_name, "last_name", 1, 254);
        dtoVerify.first_name = await this.securityService.cleanString(dto.first_name, "first_name", 1, 254);
        dtoVerify.password = await this.securityService.checkPassword(
          dto.password,
          dto.repeat_password,
        );
        return dtoVerify;
      }
}
