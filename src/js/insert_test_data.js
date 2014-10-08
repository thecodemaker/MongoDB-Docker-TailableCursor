
var document = {
      createdDtm: "",
      status: {
         code: "STATUS_A",
         createdDtm: ""
      },
      statusHistory: [
        {
            code: "STATUS_A",
            createdDtm: ""
         }
      ]
    };

(function populateTestData() {

    print("DEBUG: populate test data");
    db.collection.save(document);

//    for(var i=0; i< 1000; i++) {
//        var currentTime = new Date().getTime();
//        document.createdDtm =
//        db.collection.save({createdDtm: new Date().getTime()});
//    }
})();