import { getModelForClass, ReturnModelType } from '@typegoose/typegoose';
import { Peak } from '../types/peak'

export type PeakModelType = ReturnModelType<typeof Peak>; // UserModelType is a mongoose model type that is based on the User class 

const PeakModel: PeakModelType = getModelForClass(Peak); // UserModel is a mongoose model that is based on the User class

export default PeakModel; 