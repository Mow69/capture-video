import { BadRequestException, forwardRef, Inject, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateFilterDto } from './dto/create-filter.dto';
import { UpdateFilterDto } from './dto/update-filter.dto';
import { Filter } from './entities/filter.entity';
import { Response } from 'express';
import { SecurityService } from 'src/tools/security.service';
import { Category } from 'src/category_filter/category.entity';
import { VideoExt } from 'src/video_ext/videoExt.entity';

@Injectable()
export class FilterService {
  constructor(
    @InjectRepository(Filter) private readonly filterRepository: Repository<Filter>,
    @InjectRepository(Category) private readonly CategoryRepository: Repository<Category>,
    @InjectRepository(VideoExt) private readonly VideoExtRepository: Repository<VideoExt>,
    private securityService: SecurityService
  ) {}

  async create(createFilterDto: CreateFilterDto) {
    const filterData = await this.checkCreateFilter(createFilterDto);
    const newFilter = new Filter;
    newFilter.name = createFilterDto.name;
    newFilter.description = createFilterDto.description;
    newFilter.image = createFilterDto.image;
    newFilter.price = createFilterDto.price;
    newFilter.path = createFilterDto.path;
    newFilter.category = createFilterDto.category_id;
    newFilter.video_ext = createFilterDto.video_ext_id;
    
    await this.filterRepository.save(newFilter).catch((error) => {
      console.log(error)
      console.log(error)
		});;;

    return newFilter;
    
  }

  findAll() {
    return this.filterRepository.find({ relations: ['category','video_ext'] });
  }

  findOne(id: number) {
    return this.filterRepository.findOneBy({ id }).then((user) => {
      if(!user){
        throw new NotFoundException('Id not found');
      }
      return user
		});;
  }
  async delete(res: Response,id: number){
    const filter = await this.findOne(id)
    await this.filterRepository.remove(filter);
    return res.status(201).send(`Filter ${id} deleted successfully`);
  }
  async update(res: Response,id: number, updateFilterDto: UpdateFilterDto) {
    const filterData = await this.checkUpdatingFilter(updateFilterDto);
    await this.findOne(id);
    console.log(filterData)
    if(Object.keys(filterData).length === 0){
      return res.status(200).send(`No data to update`)
    } else{
      await this.filterRepository.update(id, filterData);
      return res.status(201).send(`Filter ${id} has been updated`);
    }
  }

  async remove(id: number) {
    await this.filterRepository.delete(id);
  }
  
  async checkUpdatingFilter(dto: UpdateFilterDto){
    let dtoVerify = {} as UpdateFilterDto;
    if (dto.name) dtoVerify.name = await this.securityService.cleanString(dto.name, "name", 1, 254);
    if (dto.description) dtoVerify.description = await this.securityService.cleanString(dto.description, "description", 1, null);
    if (dto.image) dtoVerify.image = await this.securityService.cleanString(dto.image, "image", 1, null);
    if (dto.path) dtoVerify.path = await this.securityService.cleanString(dto.path, "path", 1, null);
    if (dto.price) dtoVerify.price = await this.securityService.cleanInt(dto.price, "price",1,100000);
    if (dto.category_id) dtoVerify.category_id = await this.cleanRelationShip(dto.category_id, "category_id", this.CategoryRepository);
    if (dto.video_ext_id) dtoVerify.video_ext_id = await this.cleanRelationShip(dto.video_ext_id, "video_ext_id", this.VideoExtRepository);
    return dtoVerify;
  }
  async cleanRelationShip(relationId, input, repository){
    relationId = await this.securityService.cleanInt(relationId, input,1,null)
    await repository.findOneBy({id:relationId}).then((user) => {
      if(!user){
        throw new NotFoundException(`${input} doesn't exist for his relationShip with id ${relationId}`);
      }
		});
    return relationId
  }
  async checkCreateFilter(dto: CreateFilterDto){
    if (
      !dto.name ||
      !dto.description ||
      !dto.image ||
      !dto.path ||
      !dto.price ||
      !dto.category_id ||
      !dto.video_ext_id
    ) {
      throw new BadRequestException('data is missing');
    }
    let dtoVerify = {} as CreateFilterDto;
    dtoVerify.name = await this.securityService.cleanString(dto.name, "name", 1, 254);
    dtoVerify.description = await this.securityService.cleanString(dto.description, "description", 1, null);
    dtoVerify.image = await this.securityService.cleanString(dto.image, "image", 1, null);
    dtoVerify.path = await this.securityService.cleanString(dto.path, "path", 1, null);
    dtoVerify.price = await this.securityService.cleanInt(dto.price, "price",1,100000);
    dtoVerify.category_id = await this.cleanRelationShip(dto.category_id, "category_id", this.CategoryRepository);
    dtoVerify.video_ext_id = await this.cleanRelationShip(dto.video_ext_id, "video_ext_id", this.VideoExtRepository);
    return dtoVerify;
  }
}
