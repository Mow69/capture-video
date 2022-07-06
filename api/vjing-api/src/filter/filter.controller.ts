import { Controller, Get, Post, Body, Patch, Param, Delete, Res } from '@nestjs/common';
import { FilterService } from './filter.service';
import { CreateFilterDto } from './dto/create-filter.dto';
import { UpdateFilterDto } from './dto/update-filter.dto';
import { Response } from 'express';

@Controller('filter')
export class FilterController {
  constructor(private readonly filterService: FilterService) {}

  @Post()
  create(@Body() createFilterDto: CreateFilterDto) {
    return this.filterService.create(createFilterDto);
  }

  @Get()
  findAll() {
    return this.filterService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.filterService.findOne(+id);
  }

  @Patch(':id')
  update(@Res() res: Response,@Param('id') id: string, @Body() updateFilterDto: UpdateFilterDto) {
    return this.filterService.update(res,+id, updateFilterDto);
  }

  @Delete(':id')
  remove(@Res() res: Response, @Param('id') id: string) {
    return this.filterService.delete(res,+id);
  }
}
