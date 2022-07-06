import { Category } from 'src/category_filter/category.entity';
import { Order } from 'src/order/entities/order.entity';
import { VideoExt } from 'src/video_ext/videoExt.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany, ManyToOne, OneToOne, JoinTable, JoinColumn } from 'typeorm';

@Entity()
export class Filter {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column('text')
  description: string;

  @Column('text')
  path: string;

  @Column('text')
  image: string;

  @Column()
  price: number;

  @ManyToOne(() => Category, (category) => category.filters)
  @JoinColumn({name:"category_id"})
  category: Category;

  @ManyToOne(() => VideoExt, video_ext => video_ext.filters)
  @JoinColumn({name:"video_ext_id"})
  video_ext: VideoExt;

  @OneToMany(() => Order, (order: Order) => order.filter)
  orders: Order[];

}