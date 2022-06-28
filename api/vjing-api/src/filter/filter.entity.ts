import { Category } from 'src/category_filter/category.entity';
import { VideoExt } from 'src/video/videoExt.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';

@Entity()
export class Filter {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  @Column()
  image: string;

  @Column()
  price: number;

  @OneToMany(type => Category, category => category.id)
  id_category: number;

  @OneToMany(type => VideoExt, video_ext => video_ext.id)
  id_video_ext: number;

}