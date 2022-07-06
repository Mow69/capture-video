import { Module } from '@nestjs/common';
import { FilterService } from './filter.service';
import { FilterController } from './filter.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Filter } from './entities/filter.entity';
import { SecurityModule } from 'src/tools/security.module';
import { Category } from 'src/category_filter/category.entity';
import { VideoExt } from 'src/video_ext/videoExt.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Filter,Category,VideoExt]),SecurityModule],
  controllers: [FilterController],
  providers: [FilterService]
})
export class FilterModule {}
