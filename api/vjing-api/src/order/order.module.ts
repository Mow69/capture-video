import { Module } from '@nestjs/common';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SecurityModule } from 'src/tools/security.module';
import { Filter } from 'src/filter/entities/filter.entity';
import { User } from 'src/users/user.entity';
import { PaymentMethod } from 'src/payment/paymentMethod.entity';
import { Order } from './entities/order.entity';


@Module({
  imports: [TypeOrmModule.forFeature([Order,Filter,User,PaymentMethod]),SecurityModule],
  controllers: [OrderController],
  providers: [OrderService]
})
export class OrderModule {}
