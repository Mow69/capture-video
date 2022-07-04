import { Injectable, UnauthorizedException } from '@nestjs/common';
import { createUserDto, InsertCreateUserDto } from 'src/auth/dto/auth.dto';
import { PatchUserDto, UpdateUserDto } from 'src/users/dto/users.dto';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class SecurityService {
  constructor(
    private usersService: UsersService,
  ) {}
  // Register
  async checkRegisterData(dto: createUserDto): Promise<InsertCreateUserDto> {
    if (
      !dto.email ||
      !dto.username ||
      !dto.password ||
      !dto.repeat_password ||
      !dto.last_name ||
      !dto.first_name
    ) {
      throw new UnauthorizedException('data is missing');
    }
    let dtoVerify = {} as InsertCreateUserDto;
    dtoVerify.email = await this.checkEmail(dto.email);
    dtoVerify.username = await this.cleanString(dto.username, "username", 1, 254);
    dtoVerify.last_name = await this.cleanString(dto.last_name, "last_name", 1, 254);
    dtoVerify.first_name = await this.cleanString(dto.first_name, "first_name", 1, 254);
    dtoVerify.password = await this.checkPassword(
      dto.password,
      dto.repeat_password,
    );
    console.log(dtoVerify);
    return dtoVerify;
  }

    // User Update
    async checkUpdatingUser(dto: PatchUserDto): Promise<UpdateUserDto> {
      if (
        !dto.email ||
        !dto.username ||
        !dto.password ||
        !dto.last_name ||
        !dto.first_name
      ) {
        throw new UnauthorizedException('data is missing');
      }
      let dtoVerify = {} as UpdateUserDto;
      dtoVerify.email = await this.checkEmail(dto.email);
      dtoVerify.username = await this.cleanString(dto.username, "username", 1, 254);
      dtoVerify.last_name = await this.cleanString(dto.last_name, "last_name", 1, 254);
      dtoVerify.first_name = await this.cleanString(dto.first_name, "first_name", 1, 254);
      dtoVerify.password = await this.checkPassword(dto.password);
      console.log(dtoVerify);
      return dtoVerify;
    }

  // Update
  async checkUpdateData(
    userId: string,
    phone: number,
    email: string,
    pseudo: string,
    firstName: string,
    lastName: string,
    roles: string,
  ) {
    const updateData = {};
    // if (pseudo) {
    //   updateData[`pseudo`] = await this.checkPseudo(pseudo);
    // }
    return updateData;
  }

  // CheckData
  async checkPassword(password, repeatPassword?) {
    const numberRegExp = /^(?=.*\d)/;
    const upperRegExp = /^(?=.*[A-Z])/;
    if (repeatPassword && (password !== repeatPassword)) {
      throw new UnauthorizedException(
        'Password and repeatPassword are not same',
      );
    }
    if (password.length <= 8) {
      throw new UnauthorizedException('Password length must be greater than 8');
    }
    if (!numberRegExp.test(password)) {
      throw new UnauthorizedException(
        'Password must contain at least one number',
      );
    }

    if (!upperRegExp.test(password)) {
      throw new UnauthorizedException(
        'Password must contain at least one uppercase',
      );
    }
    return password;
  }
  async checkEmail(email,ifExist=true) {
    const emailRegExp =
      /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    const emailVerify = emailRegExp.test(email.toString().toLowerCase());
    if (!emailVerify) {
      throw new UnauthorizedException('Email is invalide');
    }
    if(ifExist){
      if(await this.usersService.findOneEmail(email) !== null){
        throw new UnauthorizedException('Email already exists');
      }
    } 
    return email;
  }

  cleanString(str,input,min=1,max=254){
    this.checkStringLength(str,input,min,max);
    return this.testSanitizeString(str, input);
  }

  checkStringLength(str,input,min,max) {
    if (str.length < min) {
      throw new UnauthorizedException(`${input} length must be greater than ${min-1}`);
    } else if (str.length > max) {
      throw new UnauthorizedException(`${input} length must be lower than ${max+1}`);
    }
    return;
  }

  testSanitizeString(str, input) {
    let cleanStr = this.sanitizeString(str)
    if (str !== cleanStr) {
      throw new UnauthorizedException(
        `The '${input}' field contains unauthorized / invalid special characters`,
      );
    }
    return cleanStr;
  }
  sanitizeString(str) {
    str = str.replace(/[^a-z0-9áàéèíîóôúñüùç _-]/gim, '');
    return str.trim();
  }

}