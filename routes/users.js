var express = require('express');
var router = express.Router();
const User = require('../Models').User;

const paginate = ({ page, pageSize }) => {
  const offset = page * pageSize;
  const limit = pageSize;

  return {
    offset,
    limit,
  };
};

/* GET users listing. */
router.get('/list', function(req, res, next) {
  User.findAll()
  .then(function(data){
    res.status(200).json({"code" : 200, "contactList" : data})
  })
  .catch(error => {
    res.json(error)
  });
});

router.post('/update', (req, res, next) => {
  let body = req.body;

  User.update({
    email_id : body.emailId,
    name : body.name,
    country_code : body.countryCode,
    phone_number : body.phoneNumber,
    updated_at : Date.now()
  },{
    where : {
      id : body.id
    }
  })
  .then(function(data){
    res.status(200).json({"code" : 200, success : true})
  })
  .catch(error => {
    res.json(error)
  })
})


router.post('/add', (req, res, next) => {
  let body = req.body;
  User.create ({ 
    email_id : body.emailId,
    name : body.name,
    country_code : body.countryCode,
    phone_number : body.phoneNumber
  })
  .then(function(data){
    res.status(200).json({"code" : 200, success : true})
}).catch(error => {
    res.json(error)
})
})



module.exports = router;
