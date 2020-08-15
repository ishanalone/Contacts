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
router.get('/search', function(req, res, next) {
  var offset = req.query.page
  var limit = req.query.limit
  User.findAll({
    where : {
      email_id : req.query.emailId
    },
    ...paginate({ offset, limit }),
  })
  .then(function(data){
    res.json(data)
}).catch(error => {
    res.json(error)
});
});

router.post('/update', (req, res,next) => {
  let body = req.body;

  User.update({
    email_id : body.emailId,
    updated_at : Date.now()
  },{
    where : {
      id : body.id
    }
  })
  .then(function(data){
    res.json(data)
}).catch(error => {
    res.json(error)
})
})


router.post('/add', (req, res, next) => {
  let body = req.body;
  console.log("Swapnil Sir")
  User.create ({ 
    email_id : body.emailId,
    name : body.name,
    country_code : body.countryCode
  })
  .then(function(data){
    res.json(data)
}).catch(error => {
    res.json(error)
})
})



module.exports = router;
