import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { createUserDto, InsertCreateUserDto } from 'src/auth/dto/auth.dto';
import { UpdateUserDto } from 'src/users/dto/users.dto';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class SecurityService {
  constructor(
    private usersService: UsersService,
  ) {}

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

  cleanString(str,input,min=null,max=null){
    this.checkStringLength(str,input,min,max);
    return this.testSanitizeString(str, input);
  }

  cleanBool(bool,input){
    switch (bool) {
      case "0":
      case "false":
        return false;
      case "1":
      case "true":
        return true;
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