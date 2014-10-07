(function populateTestData() {
    print("DEBUG: populate test data");
    for(var i=0; i< 1000; i++) {
        db.collection.save({createdDtm: new Date().getTime()});
    }
})();