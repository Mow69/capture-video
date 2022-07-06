import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Filter } from 'src/filter/entities/filter.entity';
import { User } from 'src/users/user.entity';
import { UsersModule } from 'src/users/users.module';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  imports: [TypeOrmModule.forFeature([User,Filter]),UsersModule],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}
