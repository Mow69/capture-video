import { Body, Controller, Get, Post, Request, Res, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/guard/jwt-auth.guard';
import { UsersService } from './users.service';

@Controller("users")
export class UsersController {
    constructor(
        private usersService: UsersService
    ) {}

    @Get("all")
    findAll() {
      return this.usersService.findAll();
    }
}
