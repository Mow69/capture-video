import { SecurityModule } from 'src/tools/security.module';
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LocalStrategy } from './strategy/local.strategy';
import { JwtStrategy } from './strategy/jwt.strategy';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './auth.controller';
import { ConfigService } from '@nestjs/config';
import { UsersModule } from 'src/users/users.module';
import { SecurityService } from 'src/tools/security.service';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.registerAsync({
      useFactory: async (config: ConfigService) => ({
        secret: config.get("JWT_TOKEN_KEY"),
        signOptions: {
          expiresIn: config.get("ACCESS_TOKEN_EXPIRES"),
          audience: config.get("BASE_URL_FRONT"), // URI ?
          issuer: config.get("BASE_URL"), // id client ?
        },
      }),
      inject: [ConfigService],
    }),
    SecurityModule
  ],
  controllers: [AuthController],
  providers: [AuthService, LocalStrategy, JwtStrategy],
})
export class AuthModule {}