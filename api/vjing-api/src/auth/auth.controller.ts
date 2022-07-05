import { AuthService } from './auth.service';

import { JwtAuthGuard } from './guard/jwt-auth.guard';
import { LocalAuthGuard } from './guard/local-auth.guard';

import { Body, Controller, Get, Post, Request, Res, UnauthorizedException, UseGuards } from '@nestjs/common';
import { createUserDto } from './dto/auth.dto';
import { Response } from 'express';


@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  async login(@Request() req) {
    return this.authService.createToken(req.user);
  }

  @Post('register')
	register(@Res() res: Response,@Body() dto: createUserDto ) {
		return this.authService.register(res,dto);
	}

}
