export class createUserDto {
	email: string;
	username: string;
	last_name: string;
	first_name: string;
	password: string;
    repeat_password: string;
}
export class InsertCreateUserDto { // When data is verified
	email: string;
	username: string;
	last_name: string;
	first_name: string;
	password: string;
}