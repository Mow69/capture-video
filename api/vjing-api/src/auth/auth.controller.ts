import { AuthService } from './auth.service';

import { JwtAuthGuard } from './guard/jwt-auth.guard';
import { LocalAuthGuard } from './guard/local-auth.guard';

import { Body, Controller, Get, Post, Req, Res, UseGuards } from '@nestjs/common';
import { createUserDto } from './dto/auth.dto';
import { Response } from 'express';


@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  async login(@Req() req) {
    return this.authService.createToken(req.user);
  }

  @Post('register')
	register(@Res() res: Response,@Body() dto: createUserDto ) {
		return this.authService.register(res,dto);
	}

  @UseGuards(JwtAuthGuard)
  @Post('logout')
	logout(@Res() res: Response,@Req() req) {
		return this.authService.logout(res,req);
	}

  @UseGuards(JwtAuthGuard)
	@Get('token')
	async token(@Req() req) {
		return await this.authService.token(req.headers.authorization);
	}

	@UseGuards(JwtAuthGuard)
	@Get('token/refresh')
	async refreshToken(@Req() req) {
		return await this.authService.createToken(req.user);
	}
}
