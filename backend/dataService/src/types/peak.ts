import { modelOptions, prop } from '@typegoose/typegoose';

@modelOptions({
    options: {
        allowMixed: 0,
    },
})

export class Peak { // In this class the format of the user is defined (username and password) and the types
    @prop({ required: true, type: String})
    public peakId!: string; // The ! means that the variable is not null or cant be null (it is required)

    @prop({ required: true, type: String })
    public name!: string;
    
    @prop({ required: true, type: String })
    public averageVisitors!: string;

    @prop({ required: true, type: String })
    public timestamp!: string;
}

export default null;