import { Body, Controller, Get, Param, Post, Req, Res, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/guard/jwt-auth.guard';
import { UserService } from './user.service';

@Controller("user")
export class UserController {
  constructor(
    private userService: UserService
  ) {}

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  getProfile(@Req() req) {
    return this.userService.getProfile(req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Get('userjson')
  userjson(@Req() req){ // return all downloaded filter: ;
    return this.userService.userjson(req.user.user_id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('userjson/downloaded')
  userjsonDownloaded(@Req() req){ // return all downloaded filter: ;
    return this.userService.userjsonDownloaded(req.user.user_id);
  }
}
