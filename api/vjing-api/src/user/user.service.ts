import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Filter } from 'src/filter/entities/filter.entity';
import { User } from 'src/users/user.entity';
import { UsersService } from 'src/users/users.service';
import { Repository } from 'typeorm';

@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User) private readonly usersRepository: Repository<User>,
        @InjectRepository(Filter) private readonly filterRepository: Repository<Filter>,
        private usersService: UsersService
    ) {}
    getProfile(user){
        return user;
    }
    async userjson(userId: number){
        await this.usersService.findOne(userId);
        
        return await this.filterRepository.createQueryBuilder("filter")
        .leftJoinAndSelect("filter.orders", "order")
        .leftJoinAndSelect("filter.category", "category")
        .leftJoinAndSelect("filter.video_ext", "video_ext")
        .select([
            'filter.*',
            'order.is_downloaded AS is_downloaded',
            'category.name AS category_name',
            'video_ext.name AS video_ext_name'
        ])
        .where("order.user_id = :userId", { userId })
        .execute();    
    }
    async userjsonDownloaded(userId: number){
        await this.usersService.findOne(userId);

        return await this.filterRepository.createQueryBuilder("filter")
            .leftJoinAndSelect("filter.orders", "order")
            .leftJoinAndSelect("filter.category", "category")
            .leftJoinAndSelect("filter.video_ext", "video_ext")
            .select([
                'filter.*',
                'order.is_downloaded AS is_downloaded',
                'category.name AS category_name',
                'video_ext.name AS video_ext_name'
            ])
            .where("order.user_id = :userId", { userId })
            .andWhere("order.is_downloaded = true")
            .execute();
    }
   
}
/*return this.filterRepository.find({
                where: { 
                    orders: { 
                        user: { id:userId }
                    } 
                },
                relations: ["orders","category","video_ext"],
                select: {
                    orders.is_downloaded
                    orders: {
                        is_downloaded: true
                    }
                }
            });*/
