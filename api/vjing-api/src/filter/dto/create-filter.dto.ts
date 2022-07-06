import { Category } from "src/category_filter/category.entity";
import { VideoExt } from "src/video_ext/videoExt.entity";

export class CreateFilterDto {
    name: string;
    description: string;
    image: string ;
    path: string;
    price: number;
    category_id: Category;
    video_ext_id: VideoExt;
}
