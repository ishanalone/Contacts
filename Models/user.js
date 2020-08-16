'use strict';

module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    id : {
      type : DataTypes.UUID,
      primaryKey : true,
      defaultValue: DataTypes.UUIDV4
    },
    email_id : {
        type : DataTypes.STRING,
        uniqueKey : true
    },
    phone_number : DataTypes.STRING,
    name : DataTypes.STRING,
    country_code : DataTypes.INTEGER,
    created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW()
    },
    updated_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW()
    }
  }, {
    tableName: 'contact',
    created_at: 'createdAt', updated_at: 'updatedAt',
    timestamps: false
  });
  return User;
};