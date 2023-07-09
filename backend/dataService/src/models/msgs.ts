import { getModelForClass, ReturnModelType } from '@typegoose/typegoose';
import { Msg } from '../types/msg'

export type MsgModelType = ReturnModelType<typeof Msg>; // UserModelType is a mongoose model type that is based on the User class 

const MsgModel: MsgModelType = getModelForClass(Msg); // UserModel is a mongoose model that is based on the User class

export default MsgModel; 