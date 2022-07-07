import { Controller, Get, Post, Body, Patch, Param, Delete, Res, UseGuards } from '@nestjs/common';
import { FilterService } from './filter.service';
import { CreateFilterDto } from './dto/create-filter.dto';
import { UpdateFilterDto } from './dto/update-filter.dto';
import { Response } from 'express';
import { JwtAuthGuard } from 'src/auth/guard/jwt-auth.guard';

@Controller('filter')
export class FilterController {
  constructor(private readonly filterService: FilterService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() createFilterDto: CreateFilterDto) {
    return this.filterService.create(createFilterDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  findAll() {
    return this.filterService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.filterService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(@Res() res: Response,@Param('id') id: string, @Body() updateFilterDto: UpdateFilterDto) {
    return this.filterService.update(res,+id, updateFilterDto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Res() res: Response, @Param('id') id: string) {
    return this.filterService.delete(res,+id);
  }
}
