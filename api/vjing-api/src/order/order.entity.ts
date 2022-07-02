import { User } from 'src/users/user.entity';
import { Filter } from 'src/filter/filter.entity';
import { PaymentMethod } from 'src/payment/paymentMethod.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany, ManyToOne } from 'typeorm';

@Entity()
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  price: number;

  @OneToMany(type => User, user => user.id)
  user_id: number;

  @ManyToOne(type => Filter, filter => filter.id)
  filter_id: number;

  @ManyToOne(type => PaymentMethod, payment_method => payment_method.id)
  payment_method_id: number;

}