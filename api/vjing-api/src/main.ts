import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { json, urlencoded } from 'express';
import { AppModule } from 'src/app/app.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();
  app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Accept');
    next();
  });
  app.use(json({ limit: '100mb' }));
  app.use(urlencoded({ extended: true, limit: '100mb' }));
  const config = app.get(ConfigService);
  app.setGlobalPrefix(config.get('GLOBAL_PREFIX'));
  await app.listen(config.get('PORT'), () => {
    Logger.log(`Listening at ${config.get('BASE_URL')}`);
    Logger.log(`Running in ${config.get('NODE_ENV')} mode`);
  });
}
bootstrap();
