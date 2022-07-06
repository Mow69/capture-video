import { Filter } from 'src/filter/entities/filter.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';

@Entity()
export class VideoExt {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @OneToMany(() => Filter, (filter: Filter) => filter.video_ext)
  filters: Filter[];
}