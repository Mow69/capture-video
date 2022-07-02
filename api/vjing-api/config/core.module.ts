import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { validationSchema } from './validation';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            load: [],
            validationSchema,
        })
    ],
    controllers: [],
    providers: [],
    exports: []
})

export class CoreModule {}