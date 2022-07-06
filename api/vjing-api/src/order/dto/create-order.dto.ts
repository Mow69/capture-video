import { Filter } from "src/filter/entities/filter.entity";
import { PaymentMethod } from "src/payment/paymentMethod.entity";
import { User } from "src/users/user.entity";

export class CreateOrderDto {
    is_downloaded: boolean;
    price: number;
    user_id: User;
    filter_id: Filter;
    payment_method_id: PaymentMethod;
}
