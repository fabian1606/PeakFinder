import { getModelForClass, ReturnModelType } from '@typegoose/typegoose';
import { User } from '../types/user'

export type UserModelType = ReturnModelType<typeof User>; // UserModelType is a mongoose model type that is based on the User class 

const UserModel: UserModelType = getModelForClass(User); // UserModel is a mongoose model that is based on the User class

export default UserModel; 