import 'package:appcore/entities/user.entity.dart';
import 'package:appcore/models/user.model.dart';
import 'package:appcore/shared_provider/user/data/dto/user.dto.dart';

class UserMapper {
  static UserEntity toEntity(UserDto userDto) {
    return UserEntity(
      id: userDto.id,
      name: userDto.name,
      email: userDto.email,
      birthDate: userDto.birthDate,
      image: userDto.image,
      phoneNumber: userDto.phoneNumber,
      referral: userDto.referral,
      status: userDto.status,
    );
  }

  static UserModel toModel(UserDto userDto) {
    return UserModel(
      id: userDto.id,
      name: userDto.name,
      email: userDto.email,
      birthDate: userDto.birthDate,
      image: userDto.image,
      phoneNumber: userDto.phoneNumber,
      referral: userDto.referral,
      status: userDto.status,
    );
  }

  static UserDto toDto(UserModel user) {
    return UserDto(
      id: user.id,
      name: user.name,
      email: user.email,
      birthDate: user.birthDate,
      image: user.image,
      phoneNumber: user.phoneNumber,
      referral: user.referral,
      status: user.status,
    );
  }
}
