import { PartialType } from "@nestjs/mapped-types";
import { createUserDto } from "src/auth/dto/auth.dto";

export class UpdateUserDto extends PartialType(createUserDto) {}