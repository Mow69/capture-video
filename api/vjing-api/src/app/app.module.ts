import { Module, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CoreModule } from 'config/core.module';
import { AppController } from 'src/app/app.controller';
import { AppService } from 'src/app/app.service';

import { User } from 'src/auth/user.entity';
import { Category } from 'src/category_filter/category.entity';
import { Filter } from 'src/filter/filter.entity';
import { Order } from 'src/order/order.entity';
import { PaymentMethod } from 'src/payment/paymentMethod.entity';
import { VideoExt } from 'src/video/videoExt.entity';

var config = new ConfigService;
@Module({
  imports: [
    CoreModule,
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: config.get("MYSQL_HOST"),
      port: config.get("MYSQL_PORT"),
      database: config.get("MYSQL_DATABASE"),
      username: config.get("MYSQL_PSEUDO"),
      password: config.get("MYSQL_PASSWORD"),
      entities: [User,Filter,Category,Order,VideoExt,PaymentMethod],
      synchronize: true,
    })
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {
  constructor(
		private configService: ConfigService,
	) {}
}
