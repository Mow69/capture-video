import { Body, Controller, Delete, Get, Param, Patch, Req, Res } from '@nestjs/common';
import { Response } from 'express';
import { PatchUserDto } from './dto/users.dto';
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

    @Patch(":id")
    update(@Res() res: Response, @Param("id") id: string, @Body() dto: PatchUserDto) {
      return this.usersService.update(res, dto, +id)
    }

    @Delete(":id")
    remove(@Res() res: Response, @Param("id") id: string) {
      return this.usersService.remove(res, +id);
    }
}
