import { Body, Controller, Delete, Get, Param, Patch, Req, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { JwtAuthGuard } from 'src/auth/guard/jwt-auth.guard';
import { UpdateUserDto } from './dto/users.dto';
import { UsersService } from './users.service';

@Controller("users")
export class UsersController {
    constructor(
      private usersService: UsersService
    ) {}

    @UseGuards(JwtAuthGuard)
    @Get()
    findAll() {
      return this.usersService.findAll();
    }

    @UseGuards(JwtAuthGuard)
    @Get(":id")
    findOne(@Param("id") id: string) {
      return this.usersService.findOne(+id);
    }

    @UseGuards(JwtAuthGuard)
    @Patch(":id")
    update(@Res() res: Response, @Param("id") id: string, @Body() dto: UpdateUserDto) {
      return this.usersService.update(res, dto, +id)
    }

    @UseGuards(JwtAuthGuard)
    @Delete(":id")
    remove(@Res() res: Response, @Param("id") id: string) {
      return this.usersService.remove(res, +id);
    }
}
