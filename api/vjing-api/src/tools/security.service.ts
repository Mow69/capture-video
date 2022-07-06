import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { createUserDto, InsertCreateUserDto } from 'src/auth/dto/auth.dto';
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
  async checkPassword(password, repeatPassword) {
    const numberRegExp = /^(?=.*\d)/;
    const upperRegExp = /^(?=.*[A-Z])/;
    if (password !== repeatPassword) {
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

  cleanString(str,input,min=null,max=null){
    this.checkStringLength(str,input,min,max);
    return this.testSanitizeString(str, input);
  }

  cleanBool(bool,input){
    switch (bool) {
      case "0":
      case "1":
      case "false":
      case "true":
        return bool;
      default:
        throw new BadRequestException(`${input} is not an boolean`);
    }
  }

  cleanInt(int,input,min=null,max=null){
    int=Number(int)
    if (!Number.isInteger(int)){
      throw new BadRequestException(`${input} is not an integer`);
    }
    if (min != null && int < min) {
      throw new BadRequestException(`${input} number must be greater than ${min-1}`);
    } else if (max != null && int > max) {
      throw new BadRequestException(`${input} number must be lower than ${max+1}`);
    }
    return int;
  }

  checkStringLength(str,input,min=null,max=null) {
    if (min != null && str.length < min) {
      throw new BadRequestException(`${input} length must be greater than ${min-1}`);
    } else if (max != null && str.length > max) {
      throw new BadRequestException(`${input} length must be lower than ${max+1}`);
    }
    return str;
  }

  testSanitizeString(str, input) {
    let cleanStr = this.sanitizeString(str)
    if (str !== cleanStr) {
      throw new BadRequestException(
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