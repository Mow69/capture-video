import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class VideoExt {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;
}