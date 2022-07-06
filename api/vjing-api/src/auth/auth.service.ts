import { ConfigService } from '@nestjs/config';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import * as bcrypt from 'bcrypt';
import { createUserDto } from './dto/auth.dto';
import { SecurityService } from 'src/tools/security.service';
import { UsersService } from 'src/users/users.service';
import { Response } from 'express';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private config: ConfigService,
    private securityService: SecurityService
  ) {}

  async validateUser(email: string, pass: string): Promise<any> {
    const userFound  = await this.usersService.findOneEmail(email);
    if (userFound && bcrypt.compareSync(pass, userFound.password)) {
      const { password, ...result } = userFound;
      return result;
    }
    throw new UnauthorizedException('Credentials incorrect');
  }

  async createToken(user: any) {
    const { id, username } = user;
    const payload = { 
      sub: id,
      username: username
    };
    const accessToken = this.jwtService.sign(payload);
    return {
      access_token: accessToken,
      expires_in: this.config.get("ACCESS_TOKEN_EXPIRES"),
      token_type: 'Bearer',
    };
  }

  async register(res: Response,dto: createUserDto) {
    const dtoVerify = await this.usersService.checkRegisterData(dto);
    this.usersService.insert(dtoVerify);
    return res.status(201).send('User has been register');
  }
}