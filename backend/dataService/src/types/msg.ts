import { modelOptions, prop } from '@typegoose/typegoose';

@modelOptions({
    options: {
        allowMixed: 0,
    },
})

export class Msg { // In this class the format of the user is defined (username and password) and the types
    @prop({ required: true, type: String })
    public email!: string; // The ! means that the variable is not null or cant be null (it is required)

    @prop({ required: true, type: String })
    public message!: string;

    @prop({ required: true, type: String })
    public peakId!: string;

    @prop({ required: true, type: String })
    public peakName!: string;
}

export default null;