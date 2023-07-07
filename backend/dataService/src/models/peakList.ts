import { getModelForClass, ReturnModelType } from '@typegoose/typegoose';
import { PeakList } from '../types/peakList'

export type PeakListModelType = ReturnModelType<typeof PeakList>; // UserModelType is a mongoose model type that is based on the User class 

const PeakListModel: PeakListModelType = getModelForClass(PeakList); // UserModel is a mongoose model that is based on the User class

export default PeakListModel; 