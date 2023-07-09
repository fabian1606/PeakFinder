import { modelOptions, prop } from '@typegoose/typegoose';

@modelOptions({
    options: {
        allowMixed: 0,
    },
})

export class PeakList { // In this class the format of the user is defined (username and password) and the types
    @prop({ required: true, type: String, unique: true })
    public peakId!: string;

    @prop({ required: true, type: String })
    public peakName!: string;
}

export default null;