import { modelOptions, prop } from '@typegoose/typegoose';

@modelOptions({
    options: {
        allowMixed: 0,
    },
})

export class User { // In this class the format of the user is defined (username and password) and the types
    @prop({ required: true, type: String, unique: true })
    public email!: string; // The ! means that the variable is not null or cant be null (it is required)

    @prop({ required: true, type: String })
    public password!: string;

    @prop({ required: true, default: new Date() })
    public createdAt!: Date;
}

export default null;