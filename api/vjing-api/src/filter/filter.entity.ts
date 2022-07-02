import { Category } from 'src/category_filter/category.entity';
import { VideoExt } from 'src/video/videoExt.entity';
import { Entity, Column, PrimaryGeneratedColumn, OneToMany, ManyToOne } from 'typeorm';

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

  @ManyToOne(type => Category, category => category.id)
  category: Category;

  @ManyToOne(type => VideoExt, video_ext => video_ext.id)
  video_ext: VideoExt;

}