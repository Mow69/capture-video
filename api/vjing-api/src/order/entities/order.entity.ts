import { User } from 'src/users/user.entity';
import { PaymentMethod } from 'src/payment/paymentMethod.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany, ManyToOne, JoinColumn } from 'typeorm';
import { Filter } from 'src/filter/entities/filter.entity';

@Entity()
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  price: number;

  @Column()
  is_downloaded: boolean;

  @ManyToOne(() => User, user => user.id)
  @JoinColumn({name:"user_id"})
  user: User;

  @ManyToOne(() => Filter, filter => filter.id)
  @JoinColumn({name:"filter_id"})
  filter: Filter;

  @ManyToOne(() => PaymentMethod, payment_method => payment_method.id)
  @JoinColumn({name:"payment_method_id"})
  payment_method: PaymentMethod;

}
