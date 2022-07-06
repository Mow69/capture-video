import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Filter } from 'src/filter/entities/filter.entity';
import { User } from 'src/users/user.entity';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  imports: [TypeOrmModule.forFeature([User,Filter])],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}
