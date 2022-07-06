import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Response } from 'express';
import { Filter } from 'src/filter/entities/filter.entity';
import { PaymentMethod } from 'src/payment/paymentMethod.entity';
import { SecurityService } from 'src/tools/security.service';
import { User } from 'src/users/user.entity';
import { Repository } from 'typeorm';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from './entities/order.entity';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order) private readonly orderRepository: Repository<Order>,
    @InjectRepository(Filter) private readonly filterRepository: Repository<Filter>,
    @InjectRepository(User) private readonly userRepository: Repository<User>,
    @InjectRepository(PaymentMethod) private readonly paymentMethodRepository: Repository<PaymentMethod>,
    private securityService: SecurityService
  ) {}

  async create(res: Response,createOrderDto: CreateOrderDto) {
    const orderData = await this.checkCreateOrder(createOrderDto);
    const newOrder = new Order;
    newOrder.is_downloaded = orderData.is_downloaded;
    newOrder.price = orderData.price;
    newOrder.filter = orderData.filter_id;
    newOrder.user = orderData.user_id;
    newOrder.payment_method = orderData.payment_method_id;
    
    await this.orderRepository.save(newOrder)
    return res.status(201).send(`Order has been created`);
  }

  findAll() {
    return this.orderRepository.find({ relations: ['user','payment_method'] });
  }

  findOne(id: number) {
    return this.orderRepository.findOne({
      where: {id},
      relations: ['user','payment_method']
    }).then((order) => {
      if(!order){
        throw new NotFoundException('Id not found');
      }
      return order
		});
  }

  async update(res: Response, id: number, updateOrderDto: UpdateOrderDto) {
    const orderData = await this.checkUpdatingOrder(updateOrderDto);
    const updateOrder = new Order;
    if(orderData.is_downloaded) updateOrder.is_downloaded = orderData.is_downloaded;
    if(orderData.price) updateOrder.price = orderData.price;
    if(orderData.filter_id) updateOrder.filter = orderData.filter_id;
    if(orderData.user_id) updateOrder.user = orderData.user_id;
    if(orderData.payment_method_id) updateOrder.payment_method = orderData.payment_method_id;

    await this.findOne(id);
    if(Object.keys(updateOrder).length === 0){
      return res.status(200).send(`No data to update`)
    } else{
      await this.orderRepository.update(id, updateOrder);
      return res.status(201).send(`Order ${id} has been updated`);
    }
  }

  async remove(res,id: number) {
    const order = await this.findOne(id)
    await this.orderRepository.remove(order);
    return res.status(201).send(`Order ${id} deleted successfully`);
  }

  async checkUpdatingOrder(dto: UpdateOrderDto){
    let dtoVerify = {} as UpdateOrderDto;
    if(dto.is_downloaded) dtoVerify.is_downloaded = await this.securityService.cleanBool(dto.is_downloaded, "is_downloaded");
    if(dto.price) dtoVerify.price = await this.securityService.cleanInt(dto.price, "price", 1, 100000000);
    if(dto.filter_id) dtoVerify.filter_id = await this.cleanRelationShip(dto.filter_id, "filter_id", this.filterRepository);
    if(dto.user_id) dtoVerify.user_id = await this.cleanRelationShip(dto.user_id, "user_id", this.userRepository);
    if(dto.payment_method_id) dtoVerify.payment_method_id = await this.cleanRelationShip(dto.payment_method_id, "payment_method_id", this.paymentMethodRepository);
    return dtoVerify;
  }
  async checkCreateOrder(dto: CreateOrderDto){
    if (
      !dto.is_downloaded ||
      !dto.price ||
      !dto.user_id ||
      !dto.filter_id ||
      !dto.payment_method_id
    ) {
      throw new BadRequestException('data is missing');
    }
    let dtoVerify = {} as CreateOrderDto;
    dtoVerify.is_downloaded = await this.securityService.cleanBool(dto.is_downloaded, "is_downloaded");
    dtoVerify.price = await this.securityService.cleanInt(dto.price, "price", 1, 100000000);
    dtoVerify.filter_id = await this.cleanRelationShip(dto.filter_id, "filter_id", this.filterRepository);
    dtoVerify.user_id = await this.cleanRelationShip(dto.user_id, "user_id", this.userRepository);
    dtoVerify.payment_method_id = await this.cleanRelationShip(dto.payment_method_id, "payment_method_id", this.paymentMethodRepository);
    return dtoVerify;
  }
  async cleanRelationShip(relationId, input, repository){
    relationId = await this.securityService.cleanInt(relationId, input,1,null)
    await repository.findOneBy({id:relationId}).then((user) => {
      if(!user){
        throw new NotFoundException(`${input} doesn't exist for his relationShip with id ${relationId}`);
      }
		});
    return relationId
  }
}
