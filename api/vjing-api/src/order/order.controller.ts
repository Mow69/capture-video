import { Controller, Get, Post, Body, Patch, Param, Delete, Res } from '@nestjs/common';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Response } from 'express';

@Controller('order')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @Post()
  create(@Res() res: Response ,@Body() createOrderDto: CreateOrderDto) {
    return this.orderService.create(res,createOrderDto);
  }

  @Get()
  findAll() {
    return this.orderService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.orderService.findOne(+id);
  }

  @Patch(':id')
  update(@Res() res: Response ,@Param('id') id: string, @Body() updateOrderDto: UpdateOrderDto) {
    return this.orderService.update(res,+id, updateOrderDto);
  }

  @Delete(':id')
  remove(@Res() res: Response ,@Param('id') id: string) {
    return this.orderService.remove(res,+id);
  }
}
