import { Filter } from 'src/filter/entities/filter.entity';
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, OneToMany } from 'typeorm';

@Entity()
export class Category {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @OneToMany(() => Filter, (filter: Filter) => filter.category)
  filters: Filter[];
}