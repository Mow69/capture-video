import { Body, Controller, Delete, Get, Param, Post, Request, Res, UseGuards } from '@nestjs/common';
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

    @Delete(":id")
    remove(@Res() res, @Param("id") id: string) {
      return this.usersService.remove(res, +id);
    }
}
