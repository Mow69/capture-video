import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from 'src/users/users.module';
import { SecurityService } from './security.service';


@Module({
  imports: [UsersModule],
  providers: [SecurityService],
  exports: [SecurityService],
})
export class SecurityModule {}
