import { User } from 'src/auth/user.entity';
import { Filter } from 'src/filter/filter.entity';
import { PaymentMethod } from 'src/payment/paymentMethod.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';

@Entity()
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  price: number;

  @OneToMany(type => User, user => user.id)
  id_user: number;

  @OneToMany(type => Filter, filter => filter.id)
  id_filter: number;

  @OneToMany(type => PaymentMethod, payment_method => payment_method.id)
  id_payment_method: number;

}