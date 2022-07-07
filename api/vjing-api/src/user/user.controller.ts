import { Body, Controller, Get, Param, Post, Request, Res, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/guard/jwt-auth.guard';
import { UserService } from './user.service';

@Controller("user")
export class UserController {
  constructor(
    private userService: UserService
  ) {}

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  getProfile(@Request() req) {
    return this.userService.getProfile(req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id/userjson')
  userjson(@Param('id') id: string){ // return all downloaded filter: ;
    return this.userService.userjson(+id);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id/userjson/downloaded')
  userjsonDownloaded(@Param('id') id: string){ // return all downloaded filter: ;
    return this.userService.userjsonDownloaded(+id);
  }
}
