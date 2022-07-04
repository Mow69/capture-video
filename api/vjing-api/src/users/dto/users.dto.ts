import { PartialType } from "@nestjs/mapped-types";

export class UpdateUserDto {
	email: string;
	username: string;
	last_name: string;
	first_name: string;
	password: string;
}

export class PatchUserDto extends PartialType(UpdateUserDto) {}